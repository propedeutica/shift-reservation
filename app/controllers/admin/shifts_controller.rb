class Admin::ShiftsController < Admin::AdminIdentifiedController
  def show
    @shift = Shift.find_by_id(params[:id])
    if @shift.nil?
      redirect_to admin_rooms_path
      flash[:alert] = (t ".shift_not_found")
    end
  end

  def new
    @room = Room.find_by_id(params[:room_id])
    @shift = @room.shifts.build
  end

  def create
    @room = Room.find_by_id(params[:room_id])
    @shift = @room.shifts.build(shifts_params)
    if @shift.save
      flash[:success] = (t ".shift_added", shift: @shift.id)
      redirect_to admin_rooms_path
    else
      flash[:alert] = (t ".shift_not_added")
      render 'new'
    end
  end

  def edit
    @shift = Shift.find_by_id(params[:id])
    @room = @shift.room
  end

  def update
    @shift = Shift.find(params[:id])
    @room = @shift.room
    if @shift.update_attributes(shifts_params)
      flash[:success] = (t ".shift_updated")
      redirect_to admin_shift_path(@shift)
    else
      flash[:alert] = (t ".shift_not_updated")
      render 'edit'
    end
  end

  def destroy
    @shift = Shift.find_by_id(params["id"])
    if @shift&.destroy
      flash[:success] = (t ".shift_deleted", shift: @shift.id)
    else
      flash[:alert] = (t ".shift_not_deleted")
    end
    redirect_to admin_rooms_path
  end

  def destroy_all
    if Shift.destroy_all
      flash[:success] = (t ".shift_destroy_all")
    else
      flash[:alert] = (t ".shift_destroy_all_error")
    end
    redirect_to admin_dashboard_path
  end

  private

  def shifts_params
    params.require(:shift).permit(:day_of_week, :start_time, :end_time, :sites_reserved)
  end
end
