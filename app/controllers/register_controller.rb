class RegisterController < ApplicationController
  protect_from_forgery with: :exception
  include RegisterHelper

  def new
  end

  def create
    user = User.find_by(username: params[:register][:username].downcase)
    if user
      flash.now[:danger] = 'Bad user, no donut'
      render 'new'
    else
      username = params[:register][:username].downcase
      password = params[:register][:password]
      password_confirmation = params[:register][:password_confirmation]
      user = User.create(username: username, password: password, password_confirmation: password_confirmation)
      redirect_to '/'
    end
  end
end
