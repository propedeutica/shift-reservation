class UsersController < UserAuthenticatedController
  def show
    @user = current_user
  end
end
