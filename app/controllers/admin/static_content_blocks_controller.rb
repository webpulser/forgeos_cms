class Admin::StaticContentBlocksController < Admin::BaseController
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy, :link, :unlink]
  before_filter :new_block, :only => [:new, :create]
  before_filter :get_block, :only => [:show, :edit, :update, :destroy, :duplicate, :link, :unlink]
  before_filter :get_page, :only => [:destroy, :link, :unlink]
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
    @static_content_block = @static_content_block.clone
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
      flash[:error] = I18n.t('static_content_block.update.failed').capitalize
      render :action => "edit"
    end
  end

  def destroy
    if @static_content_block.destroy
      flash[:notice] = I18n.t('static_content_block.destroy.success').capitalize
    else
      flash[:error] = @static_content_block.errors if @static_content_block
      flash[:error] = I18n.t('static_content_block.destroy.failed').capitalize
    end
    render :nothing => true
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

  def get_pages_and_categories
    @page_categories = PageCategory.find_all_by_parent_id(nil, :order => 'name')
    @pages = Page.all(:include => :page_categories, :conditions => { :categories_elements => { :category_id => nil }})
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
    columns = %w(blocks.id blocks.title count(pages.id) blocks.id)
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

    if order_column == 2
      includes << :pages
      group_by << 'blocks.id'
    end

    options[:conditions] = conditions unless conditions.empty?
    options[:include] = includes unless includes.empty?
    options[:group] = group_by.join(', ') unless group_by.empty?
    options[:order] = order unless order.squeeze.blank?
    
    if params[:sSearch] && !params[:sSearch].blank?
      @blocks = StaticContentBlock.search(params[:sSearch],options)
    else
      @blocks = StaticContentBlock.paginate(:all,options)
    end
  end
end
