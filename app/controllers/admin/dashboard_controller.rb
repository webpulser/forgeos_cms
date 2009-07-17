class Admin::DashboardController < Admin::BaseController

  def index
  end
  
  def search 
    redirect_to admin_root_path
  end
end
