class ShiftJobsController < ApplicationController
    before_action :set_shift_job, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
    
    def index
    end
  
    def show
    end
  
    def new
      @shift_job = ShiftJob.new
      @shift = Shift.find(params[:shift_id])
      @employee = @shift.employee
    end
  
    def edit
    end
  
    def create
        @shift_job = ShiftJob.new(shift_job_params)
        if @shift_job.save
          flash[:notice] = "Successfully added shift job."
          redirect_to shift_path(@shift_job.shift)
        else
          @shift     = Shift.find(params[:shift_job][:shift_id])
          @employee = @shift.employee
          render action: 'new', locals: { shift: @shift, employee: @employee }
        end
    end
  
    def update
    end

    def destroy
        @shift_job = ShiftJob.find(params[:id])
        @shift = @shift_job.shift
        @shift_job.destroy
        flash[:notice] = "Successfully removed this job."
        redirect_to shift_path(@shift)
    end
  
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift_job
      @shift_job = ShiftJob.find(params[:id])
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def shift_job_params
        params.require(:shift_job).permit(:job_id, :shift_id)
    end
  
  end
  