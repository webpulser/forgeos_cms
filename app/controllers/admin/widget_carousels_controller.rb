class Admin::WidgetCarouselsController < Admin::BaseController  
  def index
    @carousels = Carousel.find :all, :order => 'title'
  end

  def show
    get_carousel
  end
 
  def new
    @carousel = Carousel.new
  end

  def create
    @carousel = Carousel.new params[:carousel]
    if @carousel && request.post?

      # check that the linked page exists if page_id is specified
      if params[:page_id] && !get_page
        flash[:error] = I18n.t('widget.link.create.failed').capitalize
        return
      end
      
      if @carousel.save
        @carousel.widgets.create(:widgetable => @carousel)

        flash[:notice] = I18n.t('carousel.create.success').capitalize
        return link_and_redirect_to_page if @page
        return redirect_to(admin_widget_carousels_path)
      else
        flash[:error] = I18n.t('carousel.create.failed').capitalize
        render :action => "new"
      end
    end
  end

  def edit
    get_carousel
  end

  def update
    get_carousel
    if @carousel && request.put?
      if @carousel.update_attributes(params[:carousel])
        flash[:notice] = I18n.t('carousel.update.success').capitalize

        if get_page
          return redirect_to admin_page_widgets_path(@page)
        else
          return redirect_to admin_widget_carousel_path(@carousel)
        end

      else
        flash[:error] = I18n.t('carousel.update.failed').capitalize
        render :action => "edit"
      end
    end
  end

  def destroy
    get_carousel
    if @carousel && @carousel.destroy
      flash[:notice] = I18n.t('carousel.destroy.success').capitalize
    else
      flash[:error] = I18n.t('carousel.destroy.failed').capitalize
    end
    return redirect_to(admin_widget_carousels_path)
  end

private

  def get_carousel
    @carousel = Carousel.find_by_id params[:id]
    unless @carousel
      flash[:error] = I18n.t('carousel.not_exist').capitalize 
      return redirect_to(admin_widget_carousels_path)
    end
  end

  def get_page
    @page = Page.find_by_id params[:page_id]
  end

  def link_and_redirect_to_page
    widget = @carousel.widgets
    @page.widgets << widget
    @page.widgets.reset_positions

    if @carousel.save
      return redirect_to admin_page_widgets_path(@page)
    else
      @carousel.destroy
      flash[:notice] = nil
      flash[:error] = @carousel.errors
      return
    end
  end
end
