class UsersController < ApplicationController
  before_action :authorize!, only: [:show]

  def index
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(permitted_params)

    if user.save
      session[:user_id] = user.id
      redirect_to user_path(user)
    else
      redirect_to '/register'
      flash[:alert] = user.errors.full_messages.to_sentence
    end
  end

  def login_user 
    user = User.find_by(email: params[:email].downcase)
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user)

      # FOR IMPLEMENTING ROLES
      # if user.admin?
      #   flash[:success] = "Welcome, #{user.name}!"
      #   redirect_to admin_dashboard_path
      # elsif user.manager?
      #   flash[:success] = "Welcome, #{user.name}!"
      #   redirect_to manager_dashboard_path
      # elsif user.default?
      #   flash[:success] = "Welcome, #{user.name}!"
      #   redirect_to user_path(user)
      # end
    else
      flash[:error] = "Sorry, your credentials are bad"
      render :login_form
    end
  end

  def logout_user
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged Out"
  end

  private

  def permitted_params
    params.require(:user).permit(:name, 
                                 :email, 
                                 :password, 
                                 :password_confirmation)
  end

  def authorize! 
    unless current_user 
      flash[:notice] = 'You must be logged in or registered to access your dashboard'
      redirect_to root_path
    end
  end
end
