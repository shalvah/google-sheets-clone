class UsersController < ApplicationController
  def new
    if session[:filled_out_fields]
      filled_out_fields = session[:filled_out_fields]
      session[:filled_out_fields] = nil
    else
      filled_out_fields = {}
    end

    @user = User.new({email: "", name: ""}.merge(filled_out_fields))
  end

  def create
    user = User.new(user_params)

    if user.save
      log_in_user!(user)
      flash[:notice] = "Welcome to the site!"
      redirect_to :root
    else
      session[:filled_out_fields] = user_params.delete_if do |key, _|
        key == :password
      end
      flash[:errors] = user.errors.full_messages
      redirect_to new_user_url
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    
    if user.update(user_params.delete_if { |k, v| k == :password })
      flash[:notice] = "Your account details have been updated."
      redirect_to :root
    else
      flash[:errors] = user.errors.full_messages
      redirect_to edit_user_url
    end
  end

  def confirm_delete
    @user = User.find(params[:id])
  end

  def destroy
    user = User.find(params[:id])

    if user.email == user_params[:email]
      user.destroy!
      flash[:notice] = "Your account has been deleted."
      redirect_to new_user_url
    else
      flash[:errors] = ["The email address you entered does not match the account's email address. Account was not deleted."]
      redirect_to edit_user_url(user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end