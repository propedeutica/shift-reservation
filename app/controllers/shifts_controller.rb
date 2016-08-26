class ShiftsController < ApplicationController
  def show
    @shift = Shift.find_by_id(params[:id])
    if @shift.nil?
      redirect_to rooms_path
    end
  end

  def new
    @shift = Shift.build
  end

  def create
    @shift = Shift.build(offsprings_params)
    if @offspring.save
      flash[:success] = t "application.models.shift.shift_added"
    else
      flash[:danger] = t "applicatoin.models.shift.shift_not_added"
    end
    redirect_to @shift
  end
end
