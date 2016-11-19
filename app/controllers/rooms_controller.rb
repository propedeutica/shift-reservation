class RoomsController < UserAuthenticatedController
  def index
    @rooms = Room.all
  end
end
