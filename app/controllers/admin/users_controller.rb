class Admin::UsersController < Admin::AdminIdentifiedController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user.nil?
      redirect_to admin_users_path
      flash[:alert] = (t ".user_not_found")
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
    if @user.nil?
      redirect_to admin_users_path
      flash[:alert] = (t ".user_not_found")
    end
  end

  def update
    @user = User.find(params[:id])
    delete_password_params!

    if @user&.update_attributes(users_params)
      flash[:success] = (t ".user_updated", user: @user.email)
      redirect_to admin_user_path(@user)
    else
      flash[:alert] = (t ".user_not_updated", user: @user.email)
      render 'edit'
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    if !@user
      flash[:alert] = (t ".user_not_found")
      redirect_to admin_users_path
    elsif @user.destroy
      flash[:success] = (t ".user_deleted", user: @user.email)
      redirect_to admin_users_path
    else
      flash[:alert] = (t ".user_not_deleted", user: @user.email)
      render 'edit'
    end
  end

  private

  def users_params
    params.require(:user).permit(:first_name, :last_name, :phone, :email, :password, :password_confirmation)
  end

  def delete_password_params!
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end
end
