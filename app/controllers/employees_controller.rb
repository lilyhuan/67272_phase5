class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    # for phase 3 only
    @active_managers = Employee.managers.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @active_employees = Employee.regulars.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_employees = Employee.inactive.alphabetical.paginate(page: params[:page]).per_page(10)

    if current_user.role?(:manager)
      # @my_employees = Array.new
      # @my_employees = current_user.current_assignment.store.employees.alphabetical.paginate(page: params[:page]).per_page(10)
      # Employee.all do |e|
      #     my_stores = current_user.stores
      #     my_stores.each { |my_store|
      #         @my_employees << my_store.employees
      #     }
      # end
      # @my_employees = @my_employees.flatten

      @my_employees = Assignment.for_store(current_user.current_assignment.store).current.map{|s| s.employee}
      @my_employees = @my_employees.sort_by{ |x| x.last_name }

    end
  end

  def show
    retrieve_employee_assignments
    @upcoming_shifts = Shift.for_employee(@employee).for_next_days(7).chronological
    @recent_shifts = Shift.for_employee(@employee).for_past_days(7).chronological
    @missed_shifts = Shift.for_employee(@employee).pending.past.chronological
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to @employee, notice: "Successfully added #{@employee.proper_name} as an employee."
    else
      render action: 'new'
    end
  end

  def update
    if @employee.update_attributes(employee_params)
      redirect_to @employee, notice: "Updated #{@employee.proper_name}'s information."
    else
      render action: 'edit'
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path, notice: "Removed employee from the system."
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :ssn, :phone, :date_of_birth, :role, :active, :username, :password, :password_confirmation)
  end

  def retrieve_employee_assignments
    @current_assignment = @employee.current_assignment
    @previous_assignments = @employee.assignments.to_a - [@current_assignment]
  end

end
