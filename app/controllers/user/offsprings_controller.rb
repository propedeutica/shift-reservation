class User::OffspringsController < ApplicationController
  def index
    @offsprings = current_user.offsprings
  end

  def new
  end

  def create
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
end
