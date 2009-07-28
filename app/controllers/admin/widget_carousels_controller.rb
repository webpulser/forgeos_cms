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

  # item management

  def new_item
    get_carousel
    @item = @carousel.items.new
  end

  def create_item
    get_carousel
    @item = @carousel.items.new params[:carousel_item] 
    if @item && request.post?
      # update picture and save item or return error
      if update_picture && @item.save
        flash[:notice] = I18n.t('item.create.success').capitalize
        return redirect_to(admin_widget_carousel_path(@carousel))
      else
        flash[:error] = I18n.t('item.create.failed').capitalize unless has_flash_error?
        render :action => 'new_item'
      end
    end
  end

  def edit_item
    get_item
  end

  def update_item
    get_item
    if @item && request.put?
      if @item.update_attributes(params[:carousel_item]) && update_picture
        flash[:notice] = I18n.t('item.update.success').capitalize
        return redirect_to(admin_widget_carousel_path(@item.carousel))
      else
        flash[:error] = I18n.t('item.update.failed').capitalize unless has_flash_error?
        render :action => 'edit_item'
      end
    end
  end

  def destroy_item
    get_item
    unless @item
      flash[:error] = I18n.t('item.not_exist').capitalize
      return redirect_to(admin_widget_carousels_path)
    end

    if @item.destroy
      flash[:notice] = I18n.t('item.destroy.success').capitalize
    else
      flash[:error] = I18n.t('item.destroy.failed').capitalize
    end
    return redirect_to(admin_widget_carousel_path(@item.carousel))
  end

private

  def get_carousel
    @carousel = Carousel.find_by_id params[:id]
    unless @carousel
      flash[:error] = I18n.t('carousel.not_exist').capitalize 
      return redirect_to(admin_widget_carousels_path)
    end
  end

  def get_item
    @item = CarouselItem.find_by_id params[:id]
    unless @item
      flash[:error] = I18n.t('item.not_exist').capitalize
      return redirect_to(admin_widget_carousels_path)
    end
  end

  def update_picture
    # update picture if a file has been uploaded
    if !params[:picture][:uploaded_data].blank?
      picture = Picture.create params[:picture]
      unless picture.save
        flash[:error] = I18n.t('picture.update.failed').capitalize
        return false
      end

      @item.picture.destroy if @item.picture
      @item.picture = picture
      unless @item.save
        @item.picture.destroy
        return false
      end
    end

    # update alternative text
    return @item.picture.update_attribute('alternative', params[:picture][:alternative]) if @item.picture
  end
end
