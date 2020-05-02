class ShiftsController < ApplicationController
    before_action :set_shift, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
    
    def index
      if current_user.role?(:employee)
        @pending_shifts = current_user.shifts.pending.chronological.paginate.per_page(10)
        @started_shifts = current_user.shifts.started.chronological.paginate(page: params[:page]).per_page(10)
        @finished_shifts = current_user.shifts.finished.chronological.paginate(page: params[:page]).per_page(10)
        @completed_shifts = current_user.shifts.completed.chronological.paginate(page: params[:page]).per_page(10)
        @incompleted_shifts = current_user.shifts.incomplete.chronological.paginate(page: params[:page]).per_page(10)
      else
        @pending_shifts = Shift.pending.chronological.paginate.per_page(10)
        @started_shifts = Shift.started.chronological.paginate(page: params[:page]).per_page(10)
        @finished_shifts = Shift.finished.chronological.paginate(page: params[:page]).per_page(10)
        @completed_shifts = Shift.completed.chronological.paginate(page: params[:page]).per_page(10)
        @incompleted_shifts = Shift.incomplete.chronological.paginate(page: params[:page]).per_page(10)
      end

    end
  
    def show
    end
  
    def new
      @shift = Shift.new
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
  