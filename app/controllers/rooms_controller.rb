class RoomsController < ApplicationController
  def index
    @sites_available = Shift.total_sites_available
    @rooms = Room.all
  end
end
