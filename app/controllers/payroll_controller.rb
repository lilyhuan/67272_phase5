class PayrollController < ApplicationController
    before_action :set_store, only: [:show, :edit, :update, :destroy]
    before_action :check_login

    def index
    end
  
    def show
        if params[:start_date].nil?
            params[:start_date] = 1.week.ago.to_date
            params[:end_date] = Date.current
        end
        date_range = DateRange.new(params[:start_date], params[:end_date])
        @calc = PayrollCalculator.new(date_range)
        @payroll = @calc.create_payrolls_for(@store)
    end

    def new
        date_range = DateRange.new(params[:start_date], params[:end_date])
        @payroll = PayrollCalculator.new(DateRange.new(1.week.ago.to_date, Date.current))
        @store = Store.find(params[:store_id])
        
    end
  
    def create
        @store = Store.find(params[:store_id])
        # render action: 'new', locals: { store: @store }

        @payroll = PayrollCalculator.new(DateRange.new(1.week.ago.to_date, Date.current))
        redirect_to @payroll, notice: "Successfully created payroll"
    end
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end
    
    def payroll_params
        params.require(:payroll).permit(:start_date, :end_date)
      end
  end