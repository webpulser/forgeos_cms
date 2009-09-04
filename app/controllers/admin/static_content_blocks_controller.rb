class Admin::StaticContentBlocksController < Admin::BaseController
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

  before_filter :get_page, :only => [:destroy, :move_up, :move_down, :link, :unlink]
  before_filter :get_block, :only => [:show, :edit, :update, :destroy, :duplicate, :link, :unlink, :edit_links, :update_links, :move_up, :move_down]
  before_filter :new_block, :only => [:new, :create]
  before_filter :get_pages, :only => [:link, :edit_links]
  before_filter :get_pages_and_categories, :only => [:index, :new, :create, :edit, :update, :duplicate]
  
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
    @static_content_block_cloned = @static_content_block.clone
    @static_content_block_cloned.page_ids = @static_content_block.page_ids
    @static_content_block_cloned.block_category_ids = @static_content_block.block_category_ids
    @static_content_block = @static_content_block_cloned
    render :action => 'new'
  end

  def edit
  end
  
  def create
    if @static_content_block.save
      flash[:notice] = I18n.t('block.create.success').capitalize
      return redirect_to(admin_static_content_blocks_path)
    else
      flash[:error] = I18n.t('static_content_block.create.failed').capitalize
      render :action => "new"
    end
  end

  def update
    if @static_content_block.update_attributes(params[:static_content_block])
      flash[:notice] = I18n.t('static_content_block.update.success').capitalize
      redirect_to(admin_static_content_blocks_path)
    else
      flash[:error] = I18n.t('static_content_block.update.failed').capitalize unless has_flash_error?
      render :action => "edit"
    end
  end

  def destroy
    if @static_content_block.destroy
      flash[:notice] = I18n.t('static_content_block.destroy.success').capitalize
    else
      flash[:error] = @static_content_block.errors if @static_content_block
      flash[:error] = I18n.t('static_content_block.destroy.failed').capitalize unless has_flash_error?
    end
    render :nothing => true
  end
  
  def move_up
    @page.blocks.move_higher(@static_content_block)
    flash[:notice] = I18n.t('static_content_block.moved.up').capitalize
    return redirect_to([:admin, :static_content_blocks, @page])
  end
  
  def move_down
    @page.blocks.move_lower(@static_content_block)
    flash[:notice] = I18n.t('static_content_block.moved.down').capitalize
    return redirect_to([:admin, :static_content_blocks, @page])
  end


  def link
    unless @static_content_block.linked_with? @page
      if @static_content_block.link_with @page
        flash[:notice] = I18n.t('static_content_block.link.create.success').capitalize
      else
        flash[:error] = I18n.t('static_content_block.link.create.failed').capitalize
      end
    else
      if @static_content_block.unlink_with @page
        flash[:notice] = I18n.t('static_content_block.link.destroy.success').capitalize
      else
        flash[:error] = I18n.t('static_content_block.link.destroy.success').capitalize
      end
    end

    if request.xhr?
#      render(:controller => 'admin/pages', :action => 'blocks', :locals => { :blocks => @static_content_blocks })
      return render :text => true
    else
      return redirect_to(:back)
    end
  end

  def unlink
    if @page.blocks.delete(@static_content_block)
      @page.blocks.reset_positions
      flash[:notice] = I18n.t('static_content_block.link.destroy.success').capitalize
    else
      flash[:notice] = I18n.t('static_content_block.link.destroy.success').capitalize
    end
    
    render :nothing => true
  end
  
  def edit_links
  end
  
  def update_links
    if @static_content_block.update_attribute('page_ids', params[:static_content_block][:page_ids])
      flash[:notice] = I18n.t('static_content_block.link.update.success').capitalize
      return redirect_to(admin_static_content_blocks_path)
    else
      flash[:error] = I18n.t('static_content_block.link.update.failed').capitalize
      render :action => "edit_links"
    end
  end

private

  def new_block
    @static_content_block = StaticContentBlock.new(params[:static_content_block])
  end

  def get_block
    unless @static_content_block = Block.find_by_id(params[:id])
      flash[:error] = I18n.t('static_content_block.not_exist').capitalize
      return redirect_to(@page ? [:admin, :static_content_blocks, @page] : admin_blocks_path)
    end
  end

  def get_page
    @page = Page.find_by_id(params[:page_id])
  end

  def get_pages
    @pages = Page.all
  end

  def get_pages_and_categories
    # FIXME : change to PageCategory
    @page_categories = Section.find_all_by_parent_id(nil, :order => 'title')
    # pages not associated to any category
    # @pages = Page.all(:include => ['page_categories'], :conditions => { 'page_categories_blocks.page_category_id' => nil})
    @pages = Page.all(:conditions => { :section_id => nil})
  end

  def link_and_redirect_to_page
    @page.blocks << @static_content_block
    @page.blocks.reset_positions

    if @static_content_block.save
      return redirect_to([:admin, :static_content_blocks, @page])
    else
      @static_content_block.destroy
      flash[:notice] = nil
      flash[:error] = @static_content_block.errors
      return
    end
  end
  
  def sort
    columns = %w(blocks.title blocks.title count(pages.id))
    conditions = params[:category_id] ? ['block_categories_blocks.block_category_id = ? ', params[:category_id]] : []
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:iSortDir_0].upcase}"
    if params[:sSearch] && !params[:sSearch].blank?
      @blocks = StaticContentBlock.search(params[:sSearch],
        :conditions => conditions,
        :include => ['pages', 'block_categories'],
        :group => 'blocks.id',
        :order => order,
        :page => page,
        :per_page => per_page)
    else
      @blocks = StaticContentBlock.paginate(:all,
        :conditions => conditions,
        :include => ['pages', 'block_categories'],
        :group => 'blocks.id',
        :order => order,
        :page => page,
        :per_page => per_page)
    end
  end
end
