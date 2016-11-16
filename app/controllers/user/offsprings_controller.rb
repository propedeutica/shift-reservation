class User::OffspringsController < UserAuthenticatedController
  def index
    @offsprings = current_user.offsprings
  end

  def new
    @offspring = Offspring.new
  end

  def create
    debugger
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
    @offspring = Offspring.find_by(id: params[:id], user: current_user)
    if @offspring.nil?
      flash[:alert] = t '.offspring_not_found'
      redirect_to user_offsprings_path
    end
  end

  def show
    @offspring = Offspring.find_by(id: params[:id], user: current_user)
    if @offspring.nil?
      flash[:alert] = t '.offspring_not_found'
      redirect_to user_offsprings_path
    end
  end

  def update
    @offspring = Offspring.find_by(id: params[:id], user: current_user)
    if @offspring.nil?
      flash[:alert] = t '.offspring_not_found'
      redirect_to user_offsprings_path
    elsif @offspring.update_attributes(offsprings_params)
      flash[:success] = t('.offspring_updated', offspring: @offspring.id)
      redirect_to user_offspring_path(@offspring)
    else
      flash[:alert] = t '.offspring_not_updated'
      render :edit
    end
  end

  def destroy
    @offspring = Offspring.find_by(id: params["id"], user: current_user)
    if @offspring.nil?
      flash[:alert] = t '.offspring_not_found'
    elsif @offspring.destroy
      flash[:success] = (t ".offspring_deleted", offspring: @offspring.first_name)
    else
      flash[:alert] = (t ".offspring_not_deleted")
    end
    redirect_to user_offsprings_path
  end

  private

  def offsprings_params
    params.require(:offspring).permit(:first_name, :last_name, :grade)
  end
end
