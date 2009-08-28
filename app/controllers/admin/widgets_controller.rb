class Admin::WidgetsController < Admin::BaseController

  before_filter :get_page, :only => [:move_up, :move_down, :link, :unlink]
  before_filter :get_widget, :only => [:destroy, :move_up, :move_down, :link, :unlink]

  def index
    # FIXME : change to PageCategory
    @page_categories = Section.find_all_by_parent_id(nil, :order => 'title')
    # pages not associated to any category
    # @pages = Page.all(:include => ['page_categories'], :conditions => { 'page_categories_blocks.page_category_id' => nil})
    @pages = Page.all(:conditions => { :section_id => nil})

    respond_to do |format|
      format.html
      format.json do
        sort
        render :layout => false
      end
    end
  end

  def move_up
    @page.blocks.move_higher(@widget)
    flash[:notice] = I18n.t('widget.moved.up').capitalize
    return redirect_to(admin_page_widgets_path(@page))
  end

  def move_down
    @page.blocks.move_lower(@widget)
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
    if @page.blocks.delete(@widget)
      @page.blocks.reset_positions
      flash[:notice] = I18n.t('widget.link.destroy.success').capitalize
    else
      flash[:notice] = I18n.t('widget.link.destroy.success').capitalize
    end
    render :nothing => true
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

    def sort
      columns = %w(title type title count(pages.id))
      conditions = []
      per_page = params[:iDisplayLength].to_i
      offset =  params[:iDisplayStart].to_i
      page = (offset / per_page) + 1
      order = "#{columns[params[:iSortCol_0].to_i]} #{params[:iSortDir_0].upcase}"
      if params[:sSearch] && !params[:sSearch].blank?
        @widgets = Widget.search(params[:sSearch],
          :include => ['pages'],
          :group => 'blocks.id',
          :order => order,
          :page => page,
          :per_page => per_page)
      else
        @widgets = Widget.paginate(:all,
          :conditions => conditions,
          :include => ['pages'],
          :group => 'blocks.id',
          :order => order,
          :page => page,
          :per_page => per_page)
      end
    end

end
