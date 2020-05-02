class PayGradesController < ApplicationController
    before_action :set_pay_grade, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
  
    def index
      @active_pay_grades = PayGrade.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @inactive_pay_grades = PayGrade.inactive.alphabetical.paginate(page: params[:ipage]).per_page(10)
    end
  
    def show
    end
  
    def new
      @pay_grade = PayGrade.new
    end
  
    def edit
    end
  
    def create
      @pay_grade = PayGrade.new(pay_grade_params)
      if @pay_grade.save
        redirect_to @pay_grade, notice: "Successfully added #{@pay_grade.level} to the system."
      else
        render action: 'new'
      end
    end
  
    def update
      if @pay_grade.update_attributes(pay_grade_params)
        redirect_to @pay_grade, notice: "Updated pay grade information for #{@pay_grade.level}."
      else
        render action: 'edit'
      end
    end
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_pay_grade
      @pay_grade = PayGrade.find(params[:id])
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def pay_grade_params
      params.require(:pay_grade).permit(:level, :active)
    end
  
  end
  