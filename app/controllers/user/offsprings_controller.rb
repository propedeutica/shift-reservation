class User::OffspringsController < ApplicationController
  prepend_before_action :test_offspring_type

  def index
    @offsprings = current_user.offsprings
  end

  def new
    unless (@offspring = Offspring.new(type: Rails.application.config.offspring_type))
      flash[:alert] = t '.missing_offspring_type'
      redirect_to root_path
    end
  end

  def new_graded_offspring
    unless (@offspring = Offspring.new(type: Rails.application.config.offspring_type))
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
    an = type&.camelize.safe_constantize&.attribute_names
    if an.nil?
      flash[:error] = t '.param_error'
      redirect_to root_path
    else
      an.delete("id")
      an.delete("created_at")
      an.delete("updated_at")
      an.delete("type")
      params.require(type.camelize(:lower)).permit(an)
    end
  end

  def test_offspring_type
    if Rails.application.config.offspring_type.safe_constantize.nil?
      flash[:alert] = t '.missing_offspring_type'
      redirect_to root_path
    end
  end
end
