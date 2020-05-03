class HomeController < ApplicationController
  def index
    @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
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