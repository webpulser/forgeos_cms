class Admin::WidgetsController < Admin::BaseController
  def index
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

  def link
    get_widget
    get_page

    if @widget
      unless @widget.linked_with? @page
        if @widget.link_with @page
          flash[:notice] = I18n.t('widget.link.create.success').capitalize
        else
          flash[:error] = I18n.t('widget.link.create.failed').capitalize
        end
      else
        if @widget.unlink_with @page
          flash[:notice] = I18n.t('widget.link.destroy.success').capitalize
        else
          flash[:error] = I18n.t('widget.link.destroy.failed').capitalize
        end
      end
    else
      flash[:error] = I18n.t('widget.not_exist').capitalize
      if request.xhr?
        return render(:controller => 'admin/pages', :action => 'widgets', :locals => { :widgets => @widgets})
      else
        return redirect_to(:back)
      end
    end
    
    if request.xhr?
      return render(:controller => 'admin/pages', :action => 'widgets', :locals => { :widgets => @widgets })
    else
      return redirect_to(:back)
    end
  end

  def unlink
    get_page
    get_widget

    if @page
      if @widget && request.delete?
        @widget.unlink_with @page
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
