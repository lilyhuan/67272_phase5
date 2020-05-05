class HomeController < ApplicationController
  def index
    @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)


  end

  def dashboard

    if logged_in?
      @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @underage = Employee.younger_than_18.alphabetical
      @issues = Array.new
      Store.active.alphabetical.each{ |s| @issues << s.shifts.past.select{|x| x.status == 'pending'}.count}
      if current_user.role?(:manager)
        @upcoming_shifts = Shift.for_store(current_user.current_assignment.store).for_next_days(7).pending.chronological.paginate(page: params[:page]).per_page(10) 
        @shifts_today = Shift.for_store(current_user.current_assignment.store).for_dates(DateRange.new(Date.current, Date.current))
        @missed_shifts = Shift.for_store(current_user.current_assignment.store).past.pending.chronological 
        @incomplete_shifts = Shift.for_store(current_user.current_assignment.store).incomplete.finished.chronological 
      
        @my_employees = Assignment.for_store(current_user.current_assignment.store).current.map{|s| s.employee}
        @my_employees = @my_employees.sort_by{ |x| x.last_name }


        @upcoming_shift_self = Shift.for_employee(current_user).for_dates(DateRange.new(Date.tomorrow, Date.current)).chronological
        @shift_today_self = Shift.for_employee(current_user).for_dates(DateRange.new(Date.current, Date.current))
      
      else
        @upcoming_shifts = Shift.for_employee(current_user).for_dates(DateRange.new(Date.tomorrow, Date.current)).chronological
        @shifts_today = Shift.for_employee(current_user).for_dates(DateRange.new(Date.current, Date.current))
      end
    else
      @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
    end
  end

  def clock_in
    @shift = Shift.find(params[:id])
    @time_clock = TimeClock.new(@shift)
    if @time_clock.start_shift_at(Time.now)
      redirect_to dashboard_path, notice: "Shift clocked in."
    end
  end

  def clock_out
    @shift = Shift.find(params[:id])
    @time_clock = TimeClock.new(@shift)
    if @time_clock.end_shift_at(Time.now)
      redirect_to dashboard_path, notice: "Shift clocked out."
    end
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def search
    redirect_back(fallback_location: dashboard_path) if params[:query].blank?
    @query = params[:query]
    @employees = Employee.search(@query)
    @total_hits = @employees.size
    if @total_hits == 1
      redirect_to employee_path(@employees.first)
    end
  end
  
end