class Admin::PagesController < Admin::BaseController
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy, :link, :activate]
  before_filter :get_page, :only => [:edit, :destroy, :show, :update, :link, :activate, :duplicate]
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

  def show; end

  def new
    number_of_cols = @page.min_cols_by_page - @page.page_cols.size
    number_of_cols.times do
      @page.page_cols.build
    end
  end

  def duplicate
    @page = @page.clone
    render :action => 'new'
  end

  def create
    if @page.save
      flash[:notice] = I18n.t('page.create.success').capitalize
       redirect_to edit_admin_page_path(@page)
    else
      flash[:error] = I18n.t('page.create.failed').capitalize
      render :action => 'new'
    end
  end

  def edit
    number_of_cols = @page.min_cols_by_page - @page.page_cols.size
    number_of_cols.times do
      @page.page_cols.build
    end
  end

  def update
    if @page.update_attributes(params[:page])
      flash[:notice] = I18n.t('page.update.success').capitalize
      redirect_to :action => 'edit'
    else
      flash[:error] = I18n.t('page.update.failed').capitalize
      render :action => 'edit'
    end
  end

  def destroy
    #set page_url for cache sweeper
    @page.page_url = @page.translations.collect(&:url)
    if @page.destroy
      flash[:notice] = I18n.t('page.destroy.success').capitalize
    else
      flash[:error] = @page.errors if @page
      flash[:error] = I18n.t('page.destroy.failed').capitalize
    end
    render :nothing => true
  end

  def link
    if request.post?
      @page.update_attributes!(params[:page])
    end
    return redirect_to(admin_page_path(@page))
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

  def get_block
    unless block = Block.find_by_id(params[:block_id])
      flash[:error] = I18n.t('block.link.not_exist').capitalize
      return redirect_to(admin_pages_path)
    end
  end

  def get_blocks_and_categories
    @static_block_categories = StaticContentCategory.find_all_by_parent_id(nil,:joins => :translations, :order => 'name')
    @static_blocks = StaticContentBlock.all(:include => :block_categories, :conditions => { :categories => { :id => nil}})

    @widget_categories = WidgetCategory.find_all_by_parent_id(nil,:joins => :translations, :order => 'name')
    @widgets = Widget.all(:include => :block_categories, :conditions => { :categories => { :id => nil }})
  end

  def manage_tags
    #tag_list = params[:tags].join(',')
    #@page.set_tag_list_on(:tags, tags_list)
    #current_user.tag(@page, :with => tags_list, :on => :tags)
    #params[:page][:tag_list]= params[:tag_list].join(',')
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

    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:iSortDir_0].upcase}"

    conditions = {}
    options = { :order => order, :page => page, :per_page => per_page }

    includes = []
    if params[:category_id]
      conditions[:categories_elements] = { :category_id => params[:category_id] }
      includes << :page_categories
    end

    if params[:ids]
      conditions[:pages] = { :id => params[:ids].split(',') }
    end

    options[:conditions] = conditions unless conditions.empty?
    options[:include] = includes unless includes.empty?
    options[:order] = order unless order.squeeze.blank?

    joins = []
    joins << :translations

    if params[:sSearch] && !params[:sSearch].blank?
      options[:index] = "page_#{ActiveRecord::Base.locale}_core"
      options[:star] = true
      @pages = Page.search(params[:sSearch],options)
    else
      options[:joins] = joins
      options[:group] = 'page_id'
      @pages = Page.paginate(:all,options)
    end
  end
end
