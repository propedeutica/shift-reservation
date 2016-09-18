class Admin::DashboardController < Admin::AdminController
  def index
    @global_lock_in_status = Myconfig.global_lock?
    @number_of_rooms = Room.count
    @number_of_shifts = Shift.count
    @total_sites_available = Shift.total_sites_available
    @total_capacity = Shift.total_capacity
    @number_of_admins = Admin.count
  end
end
