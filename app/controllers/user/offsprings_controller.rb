class User::OffspringsController < ApplicationController
  def index
    @offsprings = current_user.offsprings
  end

  def new
    unless (@offspring = Offspring.new)
      flash[:alert] = t '.missing_offspring_type'
      redirect_to root_path
    end
  end

  def create
    @offspring = Offspring.new(offsprings_params)
    @offspring.user = current_user
    if @offspring.save
      flash[:success] = t('.offspring_added', offspring: @offspring.first_name)
      redirect_to user_offsprings_path
    else
      flash[:alert] = t '.offspring_not_added'
      render :new
    end
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def offsprings_params
    params.require(:offspring).permit(:first_name, :last_name, :grade)
  end
end
