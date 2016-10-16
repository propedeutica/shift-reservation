class User::OffspringsController < ApplicationController
  def index
    @offsprings = current_user.offsprings
  end

  def new
    unless (@offspring = Rails.application.config.offspring_type.safe_constantize&.new)
      flash[:alert] = t '.missing_offspring_type'
      redirect_to root_path
    end
  end

  def create
    @offspring = Rails.application.config.offspring_type.safe_constantize&.new offsprings_params(Rails.application.config.offspring_type)
    if @offspring.nil?
      flash[:alert] = t '.missing_offspring_type'
      redirect_to root_path
    elsif @offspring.save
      flash[:success] = t '.offspring_added'
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

  def offsprings_params(type)
    an = type.attribute_names
    an.delete("id")
    an.delete("created_at")
    an.delete("updated_at")
    an.delete("tyoe")
    params.require(type).permit(an)
  end
end
