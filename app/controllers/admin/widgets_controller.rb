class Admin::WidgetsController < Admin::BaseController
  def index
    @widgets = [['carousels', admin_widget_carousels_path]]
  end
end
