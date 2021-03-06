class CharitiesController < ApplicationController
    before_action :require_admin, only: :show
   
    def new
      if Charity.any?
        flash[:alert] = "Charity setup already completed"
        redirect_to and return root_url
      else    
        @charity = Charity.new
        render :layout => false
      end
    end
    
    def create
      @charity = Charity.new(charity_params)
      if @charity.save
        redirect_to new_user_registration_path
      else
        render 'new', :layout => false
      end
    end
    
    # Charities#show corresponds to the sponsor dashboard.
    def show
      # @charity = Charity.all
      @auctions = Auction.order(finish: :desc)
      unless @current_auction.nil?
        @pending_items_count = @current_auction.items.where(approved: false, declined: false).count
      else
        @pending_items_count = 0
      end
    end
    
    def edit
      @charity = Charity.last
    end
    
    def update
      @charity = Charity.last
      if @charity.update(charity_params)
        flash[:notice] = "Your Charity's information has been updated!"
        redirect_to dashboard_path
      else
        render 'edit'
      end
    end
    
    private
    
    def charity_params
      params.require(:charity).permit(:name, :subhead, :email, :url, :logo, :bg_color)
    end
  
  end