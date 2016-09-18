class Admin::AdminsController < Admin::AdminController
  def index
    @admins = Admin.all
  end
end
