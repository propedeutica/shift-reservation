class Admin::RoomsController < Admin::AdminController
  def index
    @sites_available = Shift.total_sites_available
    @rooms = Room.all
    @number_of_rooms = Room.count
  end

  def new
    @room = Room.new
  end

  def edit
    @room = Room.find_by_id(params[:id])
  end

  def create
    @room = Room.new(rooms_params)
    if @room.save
      flash[:success] = (t 'application.models.room.room_added').capitalize
      redirect_to admin_room_path @room
    else
      flash[:error] = (t 'application.models.room.room_not_added').capitalize
      render 'new'
    end
  end

  def show
    @room = Room.find_by_id(params[:id])
  end

  def update
    @room = Room.find_by_id(params[:id])
    if @room.update_attributes(rooms_params)
      flash[:success] = (t "application.models.room.room_updated").capitalize
      redirect_to admin_room_path @room
    else
      flash[:danger] = (t "application.models.room.room_not_updated").capitalize
      render 'edit'
    end
  end

  def destroy
    @room = Room.find_by_id(params["id"])
    if @room && @room.destroy
      flash[:success] = (t "application.models.room.room_deleted").capitalize
    else
      flash[:danger] = (t "application.models.room.room_delete_error").capitalize
    end
    redirect_to admin_rooms_path
  end

  def destroy_all
    Room.destroy_all
    redirect_to admin_dashboard_path
  end

  private

  def rooms_params
    params.require(:room).permit(:name, :capacity)
  end
end
