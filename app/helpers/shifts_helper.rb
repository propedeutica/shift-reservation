module ShiftsHelper
  def total_capacity
    tcapacity = 0
    Shift.all.each do |x|
      tcapacity += x.room.capacity
    end
    tcapacity
  end

  def total_sites_available
    tsitesavailable = 0
    Shift.all.each do |x|
      tsitesavailable += x.sites_available
    end
    tsitesavailable
  end
end
