class ApplicationController < ActionController::Base
    include ApplicationHelper
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_app_environment

    
    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:fname, :lname, :username, :email, :password,  :admin)} 
    #   devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password)} 
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:fName, :lName, :username, :email, :password,  :admin)} 
      
    end
    def after_sign_in_path_for user
        session[:forward_url] ? session.delete(:forward_url) : super
      end
  
      def set_app_environment
        @charity = Charity.last
        @current_auction = Auction.order(:finish).last
        
      end
  
       def clear_item_search
         user_searching = params[:name_sort] || \
                          params[:current_bid_sort] || \
                          params[:bid_count_sort]
         session[:search] = nil unless user_searching
       end
  
      def require_admin
        unless current_user.admin?
          redirect_to :back,
                      :alert => 'Only Charity Administrators Allowed.'
        end
      end
  
      def require_login
        unless user_signed_in?
          session[:forward_url] = item_url(@item)
                   redirect_to new_user_session_path,
                   :alert => 'Please sign in or sign up before continuing.'
        end
      end
    
    def app_setup_if_needed
      unless Charity.any? 
       redirect_to new_charity_path
      end
    end
  end
