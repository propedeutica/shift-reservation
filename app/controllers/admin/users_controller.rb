class Admin::UsersController < Admin::AdminIdentifiedController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find(params[:id])
    delete_password_params!

    if @user.update_attributes(users_params)
      flash[:success] = (t ".user_updated", user: @user.email)
      redirect_to admin_user_path(@user)
    else
      flash[:danger] = (t ".user_not_updated", user: @user.email)
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params["id"])
    if @user&.destroy
      flash[:success] = (t ".user_deleted", user: @user.email)
      redirect_to admin_users_path
    else
      flash[:danger] = (t ".user_delete_error", user: @user.email)
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
