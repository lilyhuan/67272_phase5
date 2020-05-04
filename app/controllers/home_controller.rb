class HomeController < ApplicationController
  def index
    if logged_in?
      @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @issues = Array.new
      Store.active.alphabetical.each{ |s| @issues << s.shifts.past.select{|x| x.status == 'pending'}.count}
      @upcoming_shifts = Shift.for_employee(current_user).upcoming.pending.chronological
      @shifts_today = Shift.for_employee(current_user).for_dates(DateRange.new(Date.current, Date.current))

    else
      @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
    end

  end

  def clock_in
    @shift = Shift.find(params[:id])
    @time_clock = TimeClock.new(@shift)
    if @time_clock.start_shift_at(Time.now)
      redirect_to home_path, notice: "Shift clocked in."
    end
  end

  def clock_out
    @shift = Shift.find(params[:id])
    @time_clock = TimeClock.new(@shift)
    if @time_clock.end_shift_at(Time.now)
      redirect_to home_path, notice: "Shift clocked out."
    end
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def search
    redirect_back(fallback_location: home_path) if params[:query].blank?
    @query = params[:query]
    @employees = Employee.search(@query)
    @total_hits = @employees.size
  end
  
end