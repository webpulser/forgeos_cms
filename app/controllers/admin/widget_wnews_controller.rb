class Admin::WidgetWnewsController < Admin::BaseController
  def index
		@wnews = Wnew.find :all, :order => 'title'
	end

	def show
		get_wnew
    if @wnew.news_since.blank?
      @news = New.all(:conditions => ['wnew_id = ?', @wnew.id])
    else
      @news = New.all(:conditions => ['updated_at >= ?', @wnew.news_since])
    end
	end

	def new
		@wnew = Wnew.new
		@news = New.all( :select => 'title')
	end

	def create
		@wnew = Wnew.new params[:wnew]
		@news = params[:new]

		if @wnew && request.post?
			begin
				if @wnew.save
					update_news unless @news.nil?

					flash[:notice] = I18n.t('wnews.create.success').capitalize
					return redirect_to admin_widget_wnews_index_path
				end
			rescue
				flash[:error] = I18n.t('wnews.create.failed').capitalize
				render :action => 'new'
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
			begin
				if @wnew.update_attributes(params[:wnew])
					update_news unless @news.nil?
					
					flash[:notice] = I18n.t('wnews.update.success').capitalize
					return redirect_to admin_widget_wnews_path(@wnew)
				end
			rescue
				flash[:error] = I18n.t('wnews.update.failed').capitalize
				render :action => 'edit'
			end
		end
	end

	def destroy
		get_wnew
		if @wnew && @wnew.destroy
			flash[:notice] = I18n.t('wnews.destroy.success').capitalize
		else
			flash[:error] = I18n.t('wnews.destroy.failed').capitalize
		end
		return redirect_to admin_widget_wnews_index_path
	end

private

	def get_wnew
		@wnew = Wnew.find_by_id params[:id]
		unless @wnew
			flash[:error] = I18n.t('wnews.not_exist').capitalize
			return redirect_to(admin_widget_wnews_index_path)
		end
	end

	def update_news
		@news.each do |key, value|
			new = New.find_by_id key
			if value[:id].to_i == 1
				new.update_attribute('wnew_id', @wnew.id)
			elsif new.wnew_id == @wnew.id
				new.update_attribute('wnew_id', 0)
			end
		end
	end
	
end
