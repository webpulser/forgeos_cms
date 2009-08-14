class Admin::WidgetWnewsController < Admin::BaseController
  def index
		@wnews = Wnew.find :all, :order => 'title'
	end

	def show
		get_wnew
    @news = @wnew.get_news
	end

	def new
		@wnew = Wnew.new
		@news = New.all
	end

	def create
		@wnew = Wnew.new params[:wnew]
		@news = params[:new]

    if @wnew && request.post?

      # check that the linked page exists if page_id is specified
      if params[:page_id] && !get_page
        flash[:error] = I18n.t('widget.link.create.failed').capitalize
        return
      end
      
      if @wnew.save

        flash[:notice] = I18n.t('wnew.create.success').capitalize
        return link_and_redirect_to_page if @page
        return redirect_to admin_widget_wnews_index_path
      else
        flash[:error] = I18n.t('wnew.create.failed').capitalize
        return redirect_to :action => 'new'
      end
    end
	end

	def edit
		get_wnew
		@news = New.all
	end

	def update
		get_wnew
		
    if @wnew && request.put?
      if @wnew.update_attributes(params[:wnew])

        flash[:notice] = I18n.t('wnew.update.success').capitalize

        if get_page
          return redirect_to admin_page_widgets_path(@page)
        else
          return redirect_to admin_widget_wnews_path(@wnew)
        end
        
      else
        flash[:error] = I18n.t('wnew.update.failed').capitalize
        return redirect_to :action => 'edit'
      end
    end
	end

	def destroy
		get_wnew
		if @wnew && @wnew.destroy
			flash[:notice] = I18n.t('wnew.destroy.success').capitalize
		else
			flash[:error] = I18n.t('wnew.destroy.failed').capitalize
		end
		return redirect_to admin_widget_wnews_index_path
	end

private

	def get_wnew
    @wnew = Wnew.find_by_id params[:id]
		unless @wnew
			flash[:error] = I18n.t('wnew.not_exist').capitalize
			return redirect_to(admin_widget_wnews_index_path)
		end
	end

  def get_page
    @page = Page.find_by_id params[:page_id]
  end

  def link_and_redirect_to_page
    @page.blocks << @wnew
    @page.blocks.reset_positions

    if @wnew.save
      return redirect_to admin_page_widgets_path(@page)
    else
      @wnew.destroy
      flash[:notice] = nil
      flash[:error] = @wnew.errors
      return
    end
  end

end
