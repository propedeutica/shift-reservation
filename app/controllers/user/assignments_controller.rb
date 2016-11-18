class User::AssignmentsController < UserAuthenticatedController
  def new
    unless (@offspring = Offspring.find_by(id: params[:offspring_id], user: current_user))
      flash[:alert] = t ".offspring_not_found"
      redirect_to user_offsprings_path
    end
    @rooms = Room.all
    @shifts = Shift.all
    # @assignment = Assignment.new # There is no need for this as the assignment is never used
  end

  def create
    @assignment = Assignment.find_by(offspring: params[:offspring_id]) || Assignment.new
    @assignment.shift_id = assignment_shift[:shift]
    @assignment.offspring_id = params[:offspring_id]
    @assignment.user = current_user
    if @assignment.save
      flash[:success] = (t '.assignment_added')
      redirect_to user_offsprings_path
    else
      flash[:alert] = (t '.assignment_not_added')
      render 'new'
    end
  end

  def destroy
    @offspring = Offspring.find_by(id: params["offspring_id"], user: current_user)
    if @offspring&.assignment&.destroy
      flash[:success] = (t ".assignment_deleted", offspring: helpers.full_name(@offspring))
    else
      flash[:alert] = (t ".assignment_not_deleted")
    end
    redirect_to user_offsprings_path
  end

  private

  def assignment_shift
    params.require(:assignment).permit(:shift)
  end
end
