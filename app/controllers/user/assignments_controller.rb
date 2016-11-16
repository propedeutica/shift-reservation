class User::AssignmentsController < UserAuthenticatedController
  def new
    unless (@offspring = Offspring.find_by(id: params[:offspring_id], user: current_user))
      flash[:error] = t ".offspring_not_found"
      redirect_to user_offsprings_path
    end
    @rooms = Room.all
    @shifts = Shift.all
    # @assignment = Assignment.new # There is no need for this as the assignment is never used
  end

  def create
    debugger
    @assignment = Assignment.new(assignment_params)
    @assignment.user, @assignment.offspring = current_user, params[:offspring_id]
    if @assignment.save
      debugger
      flash[:success] = (t '.assignment_added', assignment: @assignment)
      redirect_to user_offsprings_path
    else
      flash[:alert] = (t '.assignment_not_added')
      render 'new'
    end
  end

  def destroy
  end

  private

  def assignment_params
    params.require(:assignment).permit(:shift)
  end
end
