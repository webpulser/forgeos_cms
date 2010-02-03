class Admin::MenusController < Admin::BaseController
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy, :link, :activate]
  before_filter :get_menu, :only => [:show, :edit, :update, :destroy, :duplicate, :activate]
  before_filter :new_menu, :only => [:new, :create]

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json do
        sort
        render :layout => false
      end
    end
  end

  def show
  end
  
  def new
  end

  def duplicate
    @menu = @menu.clone
    render :action => 'new'
  end

  def create
    if @menu.save
      flash[:notice] = t('menu.create.success').capitalize
      return redirect_to([:admin, @menu])
    else
      flash[:error] = t('menu.create.failed').capitalize
      render :action => 'new'
    end
  end

  def edit
  end
  
  def update
    if @menu.update_attributes(params[:menu])
      flash[:notice] = t('menu.update.success').capitalize
      return redirect_to([:admin, @menu])
    else
      flash[:error] = t('menu.update.failed').capitalize
      render :action => 'edit'
    end
  end

  def destroy
    if @menu.destroy
      flash[:notice] = t('menu.destroy.success').capitalize
    else
      flash[:error] = t('menu.destroy.failed').capitalize
    end
    return redirect_to(admin_menus_path)
  end

  def activate
    render :text => @menu.activate
  end

private

  def get_menu
    unless @menu = ::Menu.find_by_id(params[:id])
      flash[:error] = t('menu.not_exist').capitalize
      return redirect_to(admin_menus_path)
    end
  end

  def new_menu
    @menu = Menu.new(params[:menu])
  end

  def sort
    columns = %w(menus.name menus.name active)
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order_column = params[:iSortCol_0].to_i
    order = "#{columns[order_column]} #{params[:iSortDir_0].upcase}"

    conditions = {}
    includes = []
    options = { :page => page, :per_page => per_page }

    if params[:category_id]
      conditions[:categories_elements] = { :category_id => params[:category_id] }
      includes << :menu_categories
    end

    options[:conditions] = conditions unless conditions.empty?
    options[:include] = includes unless includes.empty?
    options[:order] = order unless order.squeeze.blank?

    if params[:sSearch] && !params[:sSearch].blank?
      @menus = Menu.search(params[:sSearch], options)
    else
      @menus = Menu.paginate(:all, options)
    end
  end
end
