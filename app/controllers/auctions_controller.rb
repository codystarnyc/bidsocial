require 'cgi'
class AuctionsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:wrapup]
  
  def new
    if @current_auction.nil? || auction_ended?
      @auction = Auction.new
    else
      redirect_back fallback_location: root_path, :alert => 'You may not create a new auction until the
                                    current auction has ended.'
    end
  end
  
  def edit
    @auction = @current_auction
  end
  
  def create
    @charity = Charity.last
    @auction = @charity.auctions.build(auction_params)
    if @auction.save
      @current_auction = @auction
      #schedule_wrapup (disabled for demo purposes)
      redirect_to root_url, :notice => 'Your auction has been created!'
    else
      render 'new', :alert => "We're sorry, but we are unable create your
                               auction at this time."
    end
  end
  
  def update
    original_finish = @current_auction.finish
    if @current_auction.update(auction_params)
      #schedule_wrapup unless original_finish == @current_auction.finish?
      #disabled for demo purposes
      redirect_to dashboard_path, notice: "Auction updated."
    else
      @auction = @current_auction
      render 'edit'
    end
  end
  
  def destroy
    @current_auction.destroy
    redirect_to dashboard_path, notice: 'Auction has been canceled.' 
  end
    

  # show corresponds to Auction summary report
  def show
    @auction = Auction.find(params[:id])
    @items = Item.where(auction_id: @auction.id)
    pledges = @auction.items.map { |item| item.high_bid.try(:amount) }
    @pledge_total = pledges.compact.sum
    @payments_received = @auction.winning_bids.where(paid: true).map { |wbid| wbid.bid.amount }.sum
    
    @donor_count = @auction.donors.uniq.length
    @bidder_count = @auction.bidders.uniq.length
    
    @donation_count = @auction.items.count
    @declined_items_count = @auction.items.where(declined: true).count

    items_sold = @auction.items.to_a.delete_if { |item| item.bids.empty? }
    @items_sold_count = items_sold.compact.length
    @items_unsold_count = @auction.items.count - @items_sold_count
    
    @bids_count = @auction.bids.count
  end

  def wrapup
    end_of_auction = @current_auction.finish
    now = DateTime.current
    if ((now - 5.minutes)..(now + 5.minutes)).cover? end_of_auction
      sleep 10
      @current_auction.determine_winning_bids
      sleep 10
      @current_auction.donors.uniq.each do |donor|
        UserMailer.email_donor_wrapup(donor).deliver
      end
      @current_auction.bidders.uniq.each do |bidder|
        UserMailer.email_bidder_wrapup(bidder).deliver
      end
      UserMailer.email_sponsor_wrapup.deliver
    end
    render :nothing => true, status: :ok
  end
  
  private

    def schedule_wrapup
      date = @current_auction.finish.utc.iso8601
      url = CGI::escape(wrapup_url)
      uri = URI(ENV["TEMPORIZE_URL"])
      HTTParty.post("https://api.temporize.net/v1/events/#{date}/#{url}",
        :basic_auth => {:username => uri.user, :password => uri.password})
    end

    def auction_params
      params.require(:auction).permit(:name, :start, :finish)
    end
end