class Admin::RoomsController < Admin::AdminIdentifiedController
  def index
    @sites_available = Shift.total_sites_available
    @rooms = Room.all
    @number_of_rooms = Room.count
    respond_to do |format|
      format.html
      format.csv { send_data @rooms.to_csv, filename: "rooms.csv" }
    end
  end

  def new
    @room = Room.new
  end

  def edit
    @room = Room.find_by_id(params[:id])
    if @room.nil?
      flash[:alert] = (t ".room_not_found")
      redirect_to admin_rooms_path
    end
  end

  def create
    @room = Room.new(rooms_params)
    if @room.save
      flash[:success] = (t '.room_added')
      redirect_to admin_room_path @room
    else
      flash[:alert] = (t '.room_not_added')
      render 'new'
    end
  end

  def show
    @room = Room.find_by_id(params[:id])
    if @room.nil?
      flash[:alert] = (t ".room_not_found")
      redirect_to admin_rooms_path
    end
  end

  def update
    @room = Room.find_by_id(params[:id])
    if @room&.update_attributes(rooms_params)
      flash[:success] = (t ".room_updated")
      redirect_to admin_room_path @room
    else
      flash[:alert] = (t ".room_not_updated")
      render 'edit'
    end
  end

  def destroy
    @room = Room.find_by_id(params["id"])
    if @room&.destroy
      flash[:success] = (t ".room_deleted", room: @room.name)
    else
      flash[:alert] = (t ".room_not_deleted")
    end
    redirect_to admin_rooms_path
  end

  def destroy_all
    if Room.destroy_all
      flash[:success] = (t ".rooms_destroy_all")
    else
      flash[:alert] = (t ".rooms_destroy_all_error")
    end
    redirect_to admin_dashboard_path
  end

  private

  def rooms_params
    params.require(:room).permit(:name, :capacity)
  end
end
