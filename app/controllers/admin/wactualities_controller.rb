class Admin::WactualitiesController < Admin::BaseController

  before_filter :get_wactuality, :only => [:show, :edit, :update, :destroy]
  before_filter :new_wactuality, :only => [:new, :create]
  before_filter :get_actualities, :only => [:new, :edit]

  def index
		@wactualities = Wactuality.find :all, :order => 'title'
	end

	def show
    @actualities = @wactuality.get_actualities
	end

	def new
	end

	def edit
	end

	def create
		@actualities = params[:new]
    
    # check that the linked page exists if page_id is specified
    if params[:page_id] && !get_page
      flash[:error] = I18n.t('widget.link.create.failed').capitalize
      return
    end

    if @wactuality.save
      flash[:notice] = I18n.t('wactuality.create.success').capitalize
      return link_and_redirect_to_page if @page
      return redirect_to(admin_widgets_path)
    else
      flash[:error] = I18n.t('wactuality.create.failed').capitalize
      return redirect_to :action => 'new'
    end

	end
  
	def update
    if @wactuality.update_attributes(params[:wactuality])

      flash[:notice] = I18n.t('wactuality.update.success').capitalize

      if get_page
        return redirect_to(admin_page_widgets_path(@page))
      else
        return redirect_to(admin_widgets_path)
      end
      
    else
      flash[:error] = I18n.t('wactuality.update.failed').capitalize
      return redirect_to :action => 'edit'
    end
	end

	def destroy
		if @wactuality.destroy
			flash[:notice] = I18n.t('wactuality.destroy.success').capitalize
		else
			flash[:error] = I18n.t('wactuality.destroy.failed').capitalize
		end
		return redirect_to(admin_widgets_path)
	end

private

	def get_wactuality
		unless @wactuality = Wactuality.find_by_id(params[:id])
			flash[:error] = I18n.t('wactuality.not_exist').capitalize
			return redirect_to(admin_wactualities_path)
		end
	end

  def new_wactuality
		@wactuality = Wactuality.new params[:wactuality]
  end

  def get_actualities
		@actualities = Actuality.all
  end

  def get_page
    @page = Page.find_by_id(params[:page_id])
  end

  def link_and_redirect_to_page
    @page.blocks << @wactuality
    @page.blocks.reset_positions

    if @wactuality.save
      return redirect_to(admin_page_widgets_path(@page))
    else
      @wactuality.destroy
      flash[:notice] = nil
      flash[:error] = @wactuality.errors
      return
    end
  end

end
