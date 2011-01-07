class Admin::CarouselsController < Admin::BaseController
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]
  before_filter :get_carousel, :only => [:show, :edit, :update, :destroy, :duplicate]
  before_filter :new_carousel, :only => [:new, :create]
  before_filter :get_pages_and_categories, :only => [:index, :show, :new, :create, :edit, :update, :duplicate]

  def index
    return redirect_to(admin_widgets_path)
  end

  def show; end

  def new; end

  def edit; end

  def duplicate
    @carousel = @carousel.clone
    render :action => 'new'
  end

  def create
    # check that the linked page exists if page_id is specified
    if params[:page_id] && !get_page
      flash[:error] = I18n.t('widget.link.create.failed').capitalize
      return
    end

    if @carousel.save
      flash[:notice] = I18n.t('carousel.create.success').capitalize
      redirect_to edit_admin_carousel_path(@carousel)
    else
      flash[:error] = I18n.t('carousel.create.failed').capitalize
      render :action => "new"
    end
  end

  def update
    if updated = @carousel.update_attributes(params[:carousel])
      flash[:notice] = I18n.t('carousel.update.success').capitalize
    else
      flash[:error] = I18n.t('carousel.update.failed').capitalize
    end

    respond_to do |format|
      format.html {
        return render :action => "edit"
      }

      format.js {
        return render :nothing => true
      }
    end
  end

  def destroy
    if @carousel.destroy
      flash[:notice] = I18n.t('carousel.destroy.success').capitalize
    else
      flash[:error] = I18n.t('carousel.destroy.failed').capitalize
    end
    return redirect_to(admin_widgets_path)
  end

private

  def get_carousel
    unless @carousel =  Carousel.find_by_id(params[:id])
      flash[:error] = I18n.t('carousel.not_exist').capitalize
      return redirect_to(admint_widgets_path)
    end
  end

  def get_page
    #flash[:error] = I18n.t('page.not_exist').capitalize
  end

  def get_pages_and_categories
    @page_categories = PageCategory.find_all_by_parent_id(nil,:joins => :translations, :order => 'name')
    @pages = Page.all(:include => :page_categories, :conditions => { :categories_elements => { :category_id => nil }})
  end

  def new_carousel
    @carousel = Carousel.new params[:carousel]
  end

  def link_and_redirect_to_page
    widget = @carousel.widgets
    @page.widgets << widget
    @page.widgets.reset_positions

    if @carousel.save
      return redirect_to(admin_page_widgets_path(@page))
    else
      @carousel.destroy
      flash[:notice] = nil
      flash[:error] = @carousel.errors
      return
    end
  end
end
