class Admin::WidgetsController < Admin::BaseController
  cache_sweeper :page_sweeper, :only => [:destroy]
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
      redirect_to([forgeos_cms, :admin, :widgets])
    end
  end

  def get_pages_and_categories
    @page_categories = PageCategory.find_all_by_parent_id(nil,:joins => :translations, :order => 'name')
    @pages = Page.all(:include => :categories, :conditions => { :categories_elements => { :category_id => nil }})
  end

  def sort
    columns = %w(blocks.id blocks.type blocks.title count(pages.id))
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order_column = params[:iSortCol_0].to_i
    order = "#{columns[order_column]} #{params[:sSortDir_0].upcase}"

    conditions = {}
    includes = []
    group_by = []
    options = { :page => page, :per_page => per_page }

    if params[:category_id]
      conditions[:categories_elements] = { :category_id => params[:category_id] }
      includes << :categories
    end

    if order_column == 3
      group_by << 'blocks.id'
      includes << :pages
    end

    options[:conditions] = conditions unless conditions.empty?
    options[:include] = includes unless includes.empty?
    options[:group] = group_by.join(', ') unless group_by.empty?
    options[:order] = order unless order.squeeze.blank?

    joins = []
    joins << :translations

    if params[:sSearch] && !params[:sSearch].blank?
      options[:index] = "block_#{ActiveRecord::Base.locale}_core"
      options[:order_sql] = options.delete(:order)
      options[:star] = true
      @widgets = Widget.search(params[:sSearch],options)
    else
      options[:joins] = joins
      options[:group] = :block_id
      @widgets = Widget.paginate(:all,options)
    end
  end
end
