class Admin::WidgetsController < Admin::BaseController
  before_filter :get_widget, :only => :destroy
  before_filter :get_pages_and_categories, :only => :index

  def index
    respond_to do |format|
      format.html
      format.json do
        sort
        render :layout => false
      end
    end
  end

  def destroy
    if request.delete?
      @widget.destroy
      flash[:notice] = I18n.t('widget.destroy.success').capitalize
    else
      flash[:error] = @widget.errors if @widget
      flash[:error] = I18n.t('widget.destroy.failed').capitalize
    end
    render :nothing => true
  end

private

  def get_widget
    unless @widget = Widget.find_by_id(params[:id])
      flash[:error] = I18n.t('widget.not_exist').capitalize
      redirect_to(admin_widgets_path)
    end
  end
    
  def get_pages_and_categories
    # FIXME : change to PageCategory
    @page_categories = Section.find_all_by_parent_id(nil, :order => 'title')
    # pages not associated to any category
    # @pages = Page.all(:include => ['page_categories'], :conditions => { 'page_categories_blocks.page_category_id' => nil})
    @pages = Page.find_all_by_section_id(nil)
  end

  def sort
    columns = %w(blocks.id blocks.type blocks.title count(pages.id))
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order_column = params[:iSortCol_0].to_i
    order = "#{columns[order_column]} #{params[:iSortDir_0].upcase}"

    conditions = {}
    includes = []
    group_by = []
    options = { :page => page, :per_page => per_page }

    if params[:category_id]
      conditions[:categories_elements] = { :category_id => params[:category_id] }
      includes << :block_categories
    end

    if order_column == 3
      group_by << 'blocks.id'
      includes << :pages
    end

    options[:conditions] = conditions unless conditions.empty?
    options[:include] = includes unless includes.empty?
    options[:group] = group_by.join(', ') unless group_by.empty?
    options[:order] = order unless order.squeeze.blank?
 
    if params[:sSearch] && !params[:sSearch].blank?
      @widgets = Widget.search(params[:sSearch],options)
    else
      @widgets = Widget.paginate(:all,options)
    end
  end
end
