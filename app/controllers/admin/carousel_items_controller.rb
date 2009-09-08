class Admin::CarouselItemsController < Admin::BaseController  

  before_filter :get_carousel
  before_filter :get_item, :only => [:edit, :update, :destroy]
  before_filter :new_item, :only => [:new, :create]

  def index
    return redirect_to(edit_admin_carousel_path(@carousel))
  end

  def new
  end

  def edit
  end

  def create
    # update picture and save item or return error
    if update_picture && @item.save
      flash[:notice] = I18n.t('item.create.success').capitalize
      return redirect_to(admin_carousel_item_path(@carousel))
    else
      flash[:error] = I18n.t('item.create.failed').capitalize unless has_flash_error?
      render :action => 'new'
    end
  end

  def update    
    if @item.update_attributes(params[:item])
      flash[:notice] = I18n.t('item.update.success').capitalize
    else
      flash[:error] = I18n.t('item.update.failed').capitalize unless has_flash_error?
    end
    render :nothing => true
  end

  def destroy
    if @item.destroy
      flash[:notice] = I18n.t('item.destroy.success').capitalize
    else
      flash[:error] = I18n.t('item.destroy.failed').capitalize
    end
    return redirect_to(admin_carousel_item_path(@carousel))
  end

private

  def get_carousel
    unless @carousel = Carousel.find_by_id(params[:carousel_id])
      flash[:error] = I18n.t('carousel.not_exist').capitalize 
      return redirect_to(admin_carousels_path)
    end
  end

  def get_item
    unless @item = CarouselItem.find_by_id(params[:id])
      flash[:error] = I18n.t('item.not_exist').capitalize
      return redirect_to(admin_carousel_item_path(@carousel))
    end
  end

  def new_item
    @item = @carousel.items.new(params[:item])
  end

  def update_picture
    # update picture if a file has been uploaded
    if !params[:picture][:uploaded_data].blank?
      picture = Picture.create params[:picture]
      if picture.save
        picture.sortable_attachments.create(:attachable => @item)
      else
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
