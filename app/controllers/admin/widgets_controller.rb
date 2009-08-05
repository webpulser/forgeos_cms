class Admin::WidgetsController < Admin::BaseController
  def index
    @widgets = [['carousels', admin_widget_carousels_path], 
                ['wnews', admin_widget_wnews_index_path]]
  end

  def move_up
    get_page
    get_widget

    if @page
      if @widget
        @page.widgets.move_higher(@widget)
        flash[:notice] = I18n.t('widget.moved.up').capitalize
        return redirect_to admin_page_widgets_path(@page)
      else
        flash[:error] = I18n.t('widget.not_exist').capitalize
        return redirect_to admin_page_path(@page)
      end
    else
      flash[:error] = I18n.t('page.not_exist').capitalize
      return redirect_to admin_pages_path
    end
  end

  def move_down
    get_page
    get_widget

    if @page
      if @widget
        @page.widgets.move_lower(@widget)
        flash[:notice] = I18n.t('widget.moved.down').capitalize
        return redirect_to admin_page_widgets_path(@page)
      else
        flash[:error] = I18n.t('widget.not_exist').capitalize
        return redirect_to admin_page_path(@page)
      end
    else
      flash[:error] = I18n.t('page.not_exist').capitalize
      return redirect_to admin_pages_path
    end
  end

  def unlink
    get_page
    get_widget

    if @page
      if @widget && request.delete?
        @page.widgets.delete(@widget)
        @page.widgets.reset_positions
        flash[:notice] = I18n.t('widget.link.destroy.success').capitalize
      end
    end
    return redirect_to admin_page_widgets_path(@page)
  end

  def destroy
    get_widget
    if @widget && request.delete?
      @widget.widgetable.destroy
      flash[:notice] = I18n.t('widget.destroy.success').capitalize
    else
      flash[:error] = @widget.errors if @widget
      flash[:error] = I18n.t('widget.destroy.failed').capitalize unless has_flash_error?
    end
    # redirects to correct controller
    if get_page
      return redirect_to admin_page_widgets_path(@page)
    else
      return redirect_to admin_widgets_path
    end
  end

  private
    
    def get_page
      @page = Page.find_by_id params[:page_id]
    end

    def get_widget
      @widget = Widget.find_by_id params[:id]
    end
end
