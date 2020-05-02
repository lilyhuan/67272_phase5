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
  
end