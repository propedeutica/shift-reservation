class Admin::OffspringsController < ApplicationController
  def index
    @offsprings = Offspring.all
  end

  def show
    @offspring = Offspring.find_by_id(params[:id])
    if @offspring.nil?
      redirect_to admin_offsprings_path
      flash[:alert] = (t ".offspring_not_found")
    end
  end
end
