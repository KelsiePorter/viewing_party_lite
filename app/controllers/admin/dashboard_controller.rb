class Admin::DashboardController < Admin::BaseController
  #     ^^^^^
  #     this is where we note the namespace
  #     this will come up again when we build APIs later

    #the before_action :require_admin is now in the Admin::BaseController
    #This before action checks to see if the user is an admin before it
    #allows the user to see the admin features like an admin dashboard. 
    
    def index
    end
  end 