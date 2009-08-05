class Admin::WidgetWnewsController < Admin::BaseController
  def index
		@wnews = Wnew.find :all, :order => 'title'
	end

	def show
		get_wnew
    if @wnew.news_since.blank?
      @news = @wnew.news
    else
      @news = New.all(:conditions => ['created_at >= ?', @wnew.news_since])
    end
	end

	def new
		@wnew = Wnew.new
		@news = New.all
	end

	def create
		@wnew = Wnew.new params[:wnew]
		@news = params[:new]

    if @wnew && request.post?
      if @wnew.save

        @wnew.widgets.create(:widgetable => @wnew)

        flash[:notice] = I18n.t('wnew.create.success').capitalize
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
		@news = params[:new]
		
    if @wnew && request.put?
      if @wnew.update_attributes(params[:wnew])

        flash[:notice] = I18n.t('wnew.update.success').capitalize
        return redirect_to admin_widget_wnews_path(@wnew)
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

end
