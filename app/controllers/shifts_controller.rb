class ShiftsController < ApplicationController
    before_action :set_shift, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
    
    def index
      if current_user.role?(:employee)
        @pending_shifts = current_user.shifts.for_dates(DateRange.new(Date.tomorrow, 1.week.from_now.to_date)).chronological.paginate(page: params[:page]).per_page(10)
        @shifts_today = current_user.shifts.for_dates(DateRange.new(Date.current, Date.current)).chronological.paginate(page: params[:page]).per_page(10)
        @started_shifts = current_user.shifts.started.chronological.paginate(page: params[:page]).per_page(10)


        @finished_shifts = current_user.shifts.finished.chronological.paginate(page: params[:page]).per_page(10)
        @completed_shifts = current_user.shifts.completed.chronological.paginate(page: params[:page]).per_page(10)
        @incompleted_shifts = current_user.shifts.incomplete.chronological.paginate(page: params[:page]).per_page(10)
      elsif current_user.role?(:admin)
        @pending_shifts = Shift.for_dates(DateRange.new(Date.tomorrow, 1.week.from_now.to_date)).chronological.paginate(page: params[:page]).per_page(10)
        @shifts_today = Shift.for_dates(DateRange.new(Date.current, Date.current)).chronological.paginate(page: params[:page]).per_page(10)
        @started_shifts = Shift.started.chronological.paginate(page: params[:page]).per_page(10)


        @finished_shifts = Shift.finished.chronological.paginate(page: params[:page]).per_page(10)
        @completed_shifts = Shift.completed.chronological.paginate(page: params[:page]).per_page(10)
        @incompleted_shifts = Shift.incomplete.chronological.paginate(page: params[:page]).per_page(10)
      elsif current_user.role?(:manager)
        @pending_shifts = Shift.for_store(current_user.current_assignment.store).for_dates(DateRange.new(Date.tomorrow, 1.week.from_now.to_date)).chronological.paginate(page: params[:page]).per_page(10)
        @shifts_today = Shift.for_store(current_user.current_assignment.store).for_dates(DateRange.new(Date.current, Date.current)).chronological.paginate(page: params[:page]).per_page(10)
        @started_shifts = Shift.for_store(current_user.current_assignment.store).started.chronological.paginate(page: params[:page]).per_page(10)

        
        @finished_shifts = Shift.for_store(current_user.current_assignment.store).finished.chronological.paginate(page: params[:page]).per_page(10)
        @completed_shifts = Shift.for_store(current_user.current_assignment.store).completed.chronological.paginate(page: params[:page]).per_page(10)
        @incompleted_shifts = Shift.for_store(current_user.current_assignment.store).incomplete.chronological.paginate(page: params[:page]).per_page(10)
      end

    end

  
    def show
        @shift_jobs = @shift.shift_jobs
    end
  
    def new
      @shift = Shift.new
      @shift.assignment_id = params[:assignment_id] unless params[:assignment_id].nil?
    end
  
    def edit
    end
  
    def create
      @shift = Shift.new(shift_params)
      if @shift.save
        redirect_to @shift, notice: "Successfully added as an shift."
      else
        render action: 'new'
      end
    end
  
    def update
      if @shift.update_attributes(shift_params)
        redirect_to @shift, notice: "Updated shift information."
      else
        render action: 'edit'
      end
    end

    def destroy
      @shift.destroy
      redirect_to shifts_path, notice: "Removed shift from the system."
    end
  
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.find(params[:id])
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def shift_params
        params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :notes, :status)
    end
  
  end
  