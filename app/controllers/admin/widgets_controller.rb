class Admin::WidgetsController < Admin::BaseController

  before_filter :get_page, :only => [:move_up, :move_down, :link, :unlink]
  before_filter :get_widget, :only => [:destroy, :move_up, :move_down, :link, :unlink]

  def index
  end

  def move_up
    @page.widgets.move_higher(@widget)
    flash[:notice] = I18n.t('widget.moved.up').capitalize
    return redirect_to(admin_page_widgets_path(@page))
  end

  def move_down
    @page.widgets.move_lower(@widget)
    flash[:notice] = I18n.t('widget.moved.down').capitalize
    return redirect_to(admin_page_widgets_path(@page))
  end

  def link
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
    if request.delete?
      @widget.unlink_with @page
      flash[:notice] = I18n.t('widget.link.destroy.success').capitalize
    end
    return redirect_to(admin_page_widgets_path(@page))
  end

  def destroy
    if request.delete?
      @widget.destroy
      flash[:notice] = I18n.t('widget.destroy.success').capitalize
    else
      flash[:error] = @widget.errors if @widget
      flash[:error] = I18n.t('widget.destroy.failed').capitalize unless has_flash_error?
    end
    # redirects to correct controller
    if get_page
      return redirect_to(admin_page_widgets_path(@page))
    else
      return redirect_to(admin_widgets_path)
    end
  end

  private
    
    def get_page
      unless @page = Page.find_by_id(params[:page_id])
        flash[:error] = I18n.t('page.not_exist').capitalize
        redirect_to(admin_widgets_path)
      end
    end

    def get_widget
      unless @widget = Widget.find_by_id(params[:id])
        flash[:error] = I18n.t('widget.not_exist').capitalize
        redirect_to(admin_widgets_path)
      end
    end
end
