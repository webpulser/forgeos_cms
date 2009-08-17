class Admin::PagesController < Admin::BaseController
  uses_tiny_mce :only => [:new, :create, :edit, :update], :options => {
    :theme => 'advanced',
    :skin => 'forgeos',
    :theme_advanced_toolbar_location => 'top',
    :theme_advanced_toolbar_align => 'left',
    :theme_advanced_statusbar_location => 'bottom',
    :theme_advanced_resizing => true,
    :theme_advanced_resize_horizontal => false,
    :plugins => %w{ table fullscreen },
    :valid_elements => TMCEVALID
  }

  before_filter :get_page, :only => [:edit, :destroy, :show, :update, :edit_links, :update_links]
  before_filter :get_pages_unless_current, :only => [:edit_links, :update_links]
  before_filter :get_sections, :only => [:new, :create, :edit, :update]
  before_filter :new_page, :only => [:new, :create]

  def index
    respond_to do |format|
      format.html
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

  def create
    if @page.save
      flash[:notice] = I18n.t('page.create.success').capitalize
      return redirect_to(admin_pages_path)
    else
      flash[:error] = I18n.t('page.create.failed').capitalize unless has_flash_error?
      render :action => 'new'
    end
  end

  def edit
  end
  
  def update
    if @page.update_attributes(params[:page])
      flash[:notice] = I18n.t('page.update.success').capitalize
      return redirect_to(admin_pages_path)
    else
      flash[:error] = I18n.t('page.update.failed').capitalize unless has_flash_error?
      render :action => 'edit'
    end
  end

  def destroy
    if @page.destroy
      flash[:notice] = I18n.t('page.destroy.success').capitalize
    else
      flash[:error] = @page.errors if @page
      flash[:error] = I18n.t('page.destroy.failed').capitalize unless has_flash_error?
    end
    render :nothing => true
  end

  def blocks
    @blocks = Block.all
  end

  def widgets
    @widgets = Widget.all
  end

  def edit_links
  end
  
  def update_links
    if @page.update_attribute('linked_page_ids', params[:page][:linked_page_ids])
      flash[:notice] = I18n.t('page.link.update.success').capitalize
      redirect_to(admin_page_path(@page))
    else
      flash[:error] = I18n.t('page.link.update.failed').capitalize
      render :action => 'edit_links'
    end
  end

  def url
    render :text => Forgeos::url_generator(params[:url])
  end

private

  def new_page
    @page = Page.new(params[:page])
  end

  def get_page
    unless @page = Page.find_by_id(params[:id]) 
      flash[:error] = I18n.t('page.not_exist').capitalize
      return redirect_to(admin_pages_path)
    end
  end 
  
  def get_pages_unless_current
    @pages = Page.all :conditions => ['id != ?', @page.id]
  end

  def get_block 
    unless block = Block.find_by_id(params[:block_id])
      flash[:error] = I18n.t('block.link.not_exist').capitalize
      return redirect_to(admin_pages_path)
    end
  end 

  def get_sections
    @sections = Section.find_all_by_parent_id(nil, :order => 'title')
  end

  def sort
    columns = %w(title url section_id title active)
    conditions = []
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:iSortDir_0].upcase}"
    if params[:sSearch] && !params[:sSearch].blank?
      @pages = Page.search(params[:sSearch],
        :order => order,
        :page => page,
        :per_page => per_page)
    else
      @pages = Page.paginate(:all,
        :conditions => conditions,
        :order => order,
        :page => page,
        :per_page => per_page)
    end
  end
end
