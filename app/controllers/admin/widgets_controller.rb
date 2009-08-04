class Admin::WidgetsController < Admin::BaseController
  def index
    @widgets = [['carousels', admin_widget_carousels_path], ['wnews.other', admin_widget_wnews_index_path]]
  end
end
