class Admin::WidgetFaqsController < Admin::BaseController
  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]
  before_filter :get_widget_faq, :only => [:show, :edit, :update, :destroy, :duplicate]
  before_filter :new_widget_faq, :only => [:new, :create]
  before_filter :get_faqs, :only => [:update, :create]
  before_filter :get_pages_and_categories, :only => [:new, :create, :edit, :update, :duplicate]

  def index
    return redirect_to(admin_widgets_path)
  end

  def create
    if @widget_faq.save
      flash[:notice] = t('destination.create.success').capitalize
      redirect_to(admin_widgets_path)
    else
      flash[:error] = @widget_faq.errors.first.inspect
      render :action => 'new'
    end
  end

  def new
  end

  def edit
  end

  def duplicate
    @widget_faq = @widget_faq.clone
    render :action => 'new'
  end


  def update
    if @widget_faq.update_attributes(params[:widget_faq])
      flash[:notice] = t('widget_faq.update.success').capitalize
      redirect_to(admin_widgets_path)
    else
      flash[:error] = t('widget_faq.update.failed').capitalize
      render :action => 'edit'
    end
  end

  def destroy
    if request.delete?
      @widget_faq.destroy
      flash[:notice] = I18n.t('widget.destroy.success').capitalize
    else
      flash[:error] = @widget_faq.errors if @widget_faq
      flash[:error] = I18n.t('widget.destroy.failed').capitalize
    end
    render :nothing => true
  end


private
  def get_faqs
    @widget_faq.faqs = []
    params[:faqs].each do |faq|
      @widget_faq.faqs << Faq.new(faq)
    end if params[:faqs]
  end

  def get_widget_faq
    unless @widget_faq = WidgetFaq.find_by_id(params[:id])
      flash[:error] = t('widget_faq.not_exist').capitalize
      return redirect_to(admin_widgets_path)
    end
  end

  def new_widget_faq
    @widget_faq = WidgetFaq.new(params[:widget_faq])
  end

  def get_pages_and_categories
    @page_categories = PageCategory.find_all_by_parent_id(nil,:joins => :translations, :order => 'name')
    @pages = Page.all(:include => :page_categories, :conditions => { :categories_elements => { :category_id => nil }})
  end

end
