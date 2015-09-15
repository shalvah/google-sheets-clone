class SessionsController < ApplicationController
  def new
    if session[:filled_out_email]
      filled_out_email = session[:filled_out_email]
      session[:filled_out_email] = nil
    else
      filled_out_email = ""
    end

    @user = User.new(email: filled_out_email)
  end

  def create
    user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password]
    )

    if user
      log_in_user!(user)
      flash[:notice] = "Welcome back!"
      redirect_to :root
    else
      flash[:errors] = ["Incorrect email address or password."]
      session[:filled_out_email] = params[:user][:email]
      redirect_to new_session_url
    end
  end

  def destroy
    log_out!
    redirect_to new_session_url
  end
end
