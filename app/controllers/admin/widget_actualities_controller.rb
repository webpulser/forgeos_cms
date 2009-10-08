class Admin::WidgetActualitiesController < Admin::BaseController

  before_filter :get_widget_actuality, :only => [:show, :edit, :update, :destroy, :duplicate]
  before_filter :new_widget_actuality, :only => [:new, :create]
  before_filter :get_pages_and_categories, :only => [:index, :show, :new, :create, :edit, :update, :duplicate]

  def index
    return redirect_to(admin_widgets_path)
  end

  def show
  end

  def new
  end

  def edit
  end

  def duplicate
    @widget_actuality = @widget_actuality.clone
    render :action => 'new'
  end

  def create
    # check that the linked page exists if page_id is specified
    if params[:page_id] && !get_page
      flash[:error] = I18n.t('widget.link.create.failed').capitalize
      return
    end

    if @widget_actuality.save
      flash[:notice] = I18n.t('widget_actuality.create.success').capitalize
      return link_and_redirect_to_page if @page
      return redirect_to(admin_widgets_path)
    else
      flash[:error] = I18n.t('widget_actuality.create.failed').capitalize
      render :new
    end
  end
  
  def update
    if updated = @widget_actuality.update_attributes(params[:carousel])
      flash[:notice] = I18n.t('widget_actuality.update.success').capitalize
    else
      flash[:error] = I18n.t('widget_actuality.update.failed').capitalize
    end

    respond_to do |format|
      format.html {
        if updated
          if get_page
            return redirect_to(admin_page_widgets_path(@page))
          else
            return redirect_to(admin_widgets_path)
          end
        else
          return render :action => "edit"
        end
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
    redirect_to(admin_widgets_path)
  end

private

  def get_widget_actuality
    unless @widget_actuality = WidgetActuality.find_by_id(params[:id])
      flash[:error] = I18n.t('widget_actuality.not_exist').capitalize
      return redirect_to(admin_wactualities_path)
    end
  end

  def new_widget_actuality
    @widget_actuality = WidgetActuality.new params[:widget_actuality]
  end

  def get_page
    @page = Page.find_by_id(params[:page_id])
  end

  def get_pages_and_categories
    # FIXME : change to PageCategory
    @page_categories = Section.find_all_by_parent_id(nil, :order => 'title')
    # pages not associated to any category
    # @pages = Page.all(:include => ['page_categories'], :conditions => { 'page_categories_blocks.page_category_id' => nil})
    @pages = Page.find_all_by_section_id(nil)
  end

  def link_and_redirect_to_page
    @page.blocks << @widget_actuality
    @page.blocks.reset_positions

    if @widget_actuality.save
      return redirect_to(admin_page_widgets_path(@page))
    else
      @widget_actuality.destroy
      flash[:notice] = nil
      flash[:error] = @widget_actuality.errors
      return
    end
  end
end
