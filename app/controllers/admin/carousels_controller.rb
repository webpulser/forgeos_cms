class Admin::CarouselsController < Admin::BaseController
  before_filter :get_carousel, :only => [:show, :edit, :update, :destroy, :duplicate]
  before_filter :new_carousel, :only => [:new, :create]
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
      return link_and_redirect_to_page if @page
      return redirect_to(admin_widgets_path)
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
    # FIXME : change to PageCategory
    @page_categories = Section.find_all_by_parent_id(nil, :order => 'title')
    # pages not associated to any category
    # @pages = Page.all(:include => ['page_categories'], :conditions => { 'page_categories_blocks.page_category_id' => nil})
    @pages = Page.find_all_by_section_id(nil)
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
