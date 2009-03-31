class Admin::DashboardController < Admin::BaseController

  def index
  end
  
  def search 
    redirect_to(:action => "index")
  end
end
