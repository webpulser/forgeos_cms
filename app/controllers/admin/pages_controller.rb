class Admin::PagesController < Admin::BaseController
  uses_tiny_mce :only => [:new, :create, :edit, :update, :duplicate], :options => {
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

  before_filter :get_page, :only => [:edit, :destroy, :show, :update, :edit_links, :update_links, :widgets, :blocks, :link, :activate, :duplicate]
  before_filter :get_pages_unless_current, :only => [:edit_links, :update_links]
  before_filter :get_blocks_and_categories, :only => [:new, :create, :edit, :update]
  before_filter :new_page, :only => [:new, :create]
  before_filter :set_status, :only => [:create, :update]
  before_filter :manage_tags, :only => [:create, :update]

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

  def duplicate
    @page_cloned = @page.clone
    @page_cloned.meta_info = @page.meta_info.clone
    @page_cloned.block_ids = @page.block_ids
    @page_cloned.tags = @page.tags
    @page = @page_cloned
    render :action => 'new'
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
    @blocks = StaticContentBlock.all
  end

  def widgets
    @widgets = Widget.all
  end

  def link
    if request.post?
      @page.update_attributes!(params[:page])
    end
    return redirect_to(admin_page_path(@page))
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

  def activate
    render :text => @page.activate
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

  def get_blocks_and_categories
    @static_block_categories = StaticContentCategory.find_all_by_parent_id(nil, :order => 'name')
    @widget_categories = WidgetCategory.find_all_by_parent_id(nil, :order => 'name')

    # blocks not associated to any category
    @static_blocks = StaticContentBlock.all(:include => ['block_categories'], :conditions => { 'block_categories_blocks.block_category_id' => nil})
    @widgets = Widget.all(:include => ['block_categories'], :conditions => { 'block_categories_blocks.block_category_id' => nil})
  end

  def manage_tags
    #tag_list = params[:tags].join(',')
    #@page.set_tag_list_on(:tags, tags_list)
    #current_user.tag(@page, :with => tags_list, :on => :tags)
    params[:page][:tag_list]= params[:tag_list].join(',')
  end

  def set_status
    case params[:status]
    when 'published'
      # update publication date only if page wasn't already active or date is nil
      @page.published_at = Time.now if !@page.active or @page.published_at.nil?
      @page.active = true
    when 'draft'
      @page.active = false
    end
  end

  def sort
    columns = %w(title title '' '' created_at active '')
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
        :order => order,
        :page => page, 
        :per_page => per_page)
    end
  end
end
