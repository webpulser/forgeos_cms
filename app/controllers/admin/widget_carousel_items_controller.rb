class Admin::WidgetCarouselItemsController < Admin::BaseController  
  before_filter :get_carousel

  def index
    return redirect_to(edit_admin_widget_carousel_path(@carousel))
  end

  def new
    @item = @carousel.items.new
  end

  def create
    @item = @carousel.items.new params[:carousel_item] 
    if @item && request.post?
      # update picture and save item or return error
      if update_picture && @item.save
        flash[:notice] = I18n.t('item.create.success').capitalize
        return redirect_to(admin_widget_carousel_items_path(@carousel))
      else
        flash[:error] = I18n.t('item.create.failed').capitalize unless has_flash_error?
        render :action => 'new'
      end
    end
  end

  def edit
    get_item
  end

  def update
    get_item
    if @item && request.put?
      if @item.update_attributes(params[:carousel_item]) && update_picture
        flash[:notice] = I18n.t('item.update.success').capitalize
        return redirect_to(admin_widget_carousel_items_path(@item.carousel))
      else
        flash[:error] = I18n.t('item.update.failed').capitalize unless has_flash_error?
        render :action => 'edit'
      end
    end
  end

  def destroy
    get_item
    unless @item
      flash[:error] = I18n.t('item.not_exist').capitalize
    end

    if @item.destroy
      flash[:notice] = I18n.t('item.destroy.success').capitalize
    else
      flash[:error] = I18n.t('item.destroy.failed').capitalize
    end
    return redirect_to(admin_widget_carousel_items_path(@carousel))
  end

private

  def get_carousel
    @carousel = Carousel.find_by_id params[:widget_carousel_id]
    unless @carousel
      flash[:error] = I18n.t('carousel.not_exist').capitalize 
      return redirect_to(admin_widget_carousels_path)
    end
  end

  def get_item
    @item = CarouselItem.find_by_id params[:id]
    unless @item
      flash[:error] = I18n.t('item.not_exist').capitalize
      return redirect_to(admin_widget_carousel_items_path(@carousel))
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
