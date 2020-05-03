class PayGradeRatesController < ApplicationController
    before_action :set_pay_grade_rates, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
  
    def index
      @current_pay_grade_rates = PayGradeRate.current.chronological.paginate(page: params[:page]).per_page(10)
      @past_pay_grade_rates = PayGradeRate.where('end_date IS NOT NULL').chronological.paginate(page: params[:ipage]).per_page(10)
    end
  
    def show
    end
  
    def new
      @pay_grade_rate = PayGradeRate.new
    end
  
    def edit
    end
  
    def create
      @pay_grade_rate = PayGradeRate.new(pay_grade_rate_params)
      if @pay_grade_rate.save
        redirect_to @pay_grade_rate, notice: "Successfully added new rate to the system."
      else
        render action: 'new'
      end
    end
  
    def update
      if @pay_grade_rate.update_attributes(pay_grade_params)
        redirect_to @pay_grade_rate, notice: "Updated pay grade rate information."
      else
        render action: 'edit'
      end
    end
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_pay_grade_rate
      @pay_grade_rate = PayGradeRate.find(params[:id])
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def pay_grade_rate_params
      params.require(:pay_grade_rate).permit(:pay_grade_id, :rate, :start_date, :end_date)
    end
  
  end
  