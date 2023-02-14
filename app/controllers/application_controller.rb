# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def current_user 
    if session[:user_id]
      User.find(session[:user_id])
    end
  end

  # def current_admin?
  #   current_user && current_user.admin?
  # end
end
