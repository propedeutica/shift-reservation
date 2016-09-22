class Admin::AdminsController < Admin::AdminIdentifiedController
  def index
    @admins = Admin.all
  end
end
