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
      if @carousel.save
        flash[:notice] = I18n.t('carousel.create.success').capitalize
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
        return redirect_to(admin_widget_carousel_path(@carousel))
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
end
