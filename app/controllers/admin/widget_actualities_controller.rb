class Admin::WidgetActualitiesController < Admin::BaseController

  #cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]
  before_filter :get_widget_actuality, :only => [:show, :edit, :update, :destroy, :duplicate]
  before_filter :new_widget_actuality, :only => [:new, :create]
  before_filter :get_pages_and_categories, :only => [:index, :show, :new, :create, :edit, :update, :duplicate]

  def index
    return redirect_to([forgeos_cms, :admin, :widgets])
  end

  def show; end

  def new;  end

  def edit; end

  def duplicate
    @widget_actuality = @widget_actuality.clone
    render :action => 'new'
  end

  def create
    # check that the linked page exists if page_id is specified
=begin
    if params[:page_id] && !get_page
      flash[:error] = I18n.t('widget.link.create.failed').capitalize
      return
    end
=end

    if @widget_actuality.save
      flash[:notice] = I18n.t('widget_actuality.create.success').capitalize
      redirect_to([forgeos_cms, :edit, :admin, @widget_actuality])
    else
      flash[:error] = I18n.t('widget_actuality.create.failed').capitalize
      render :action => 'new'
    end
  end

  def update
    if updated = @widget_actuality.update_attributes(params[:widget_actuality])
      flash[:notice] = I18n.t('widget_actuality.update.success').capitalize
    else
      flash[:error] = I18n.t('widget_actuality.update.failed').capitalize
    end

    respond_to do |format|
      format.html {
        return render :action => "edit"
      }

      format.js { return render :nothing => true }
    end
  end

  def destroy
    if @widget_actuality.destroy
      flash[:notice] = I18n.t('widget_actuality.destroy.success').capitalize
    else
      flash[:error] = I18n.t('widget_actuality.destroy.failed').capitalize
    end
    redirect_to([forgeos_cms, :admin, :widgets])
  end

private

  def get_widget_actuality
    unless @widget_actuality = WidgetActuality.find_by_id(params[:id])
      flash[:error] = I18n.t('widget_actuality.not_exist').capitalize
      return redirect_to([forgeos_cms, :admin, :actualities])
    end
  end

  def new_widget_actuality
    @widget_actuality = WidgetActuality.new params[:widget_actuality]
  end

  def get_page
    @page = Page.find_by_id(params[:page_id])
  end

  def get_pages_and_categories
    @page_categories = PageCategory.find_all_by_parent_id(nil,:joins => :translations, :order => 'name')
    @pages = Page.all(:include => :categories, :conditions => { :categories_elements => { :category_id => nil }})
  end

  def link_and_redirect_to_page
    @page.blocks << @widget_actuality
    @page.blocks.reset_positions

    if @widget_actuality.save
      return redirect_to([forgeos_cms, :admin, @page, :widgets])
    else
      @widget_actuality.destroy
      flash[:notice] = nil
      flash[:error] = @widget_actuality.errors
      return
    end
  end
end
