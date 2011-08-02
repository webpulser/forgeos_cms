class Admin::ActualitiesController < Admin::BaseController

  cache_sweeper :page_sweeper, :only => [:create, :update, :destroy]
  before_filter :get_actuality, :only => [:show, :edit, :update, :destroy, :activate]
  before_filter :new_actuality, :only => [:new, :create]


  def index
    respond_to do |format|
      format.html
      format.json do
        sort
        render :layout => false
      end
    end
  end

  def edit
  end

  def update
    if @actuality.update_attributes(params[:actuality])
      flash[:notice] = t('actuality.update.success').capitalize
      redirect_to([forgeos_cms, :admin, :actualities])
    else
      flash[:error] = t('actuality.update.failed').capitalize
      render :action => 'edit'
    end

  end

  def new

  end

  def create
    if @actuality.save
      flash[:notice] = t('actuality.create.success').capitalize
      redirect_to([forgeos_cms, :admin, :actualities])
    else
      flash[:error] = @actuality.errors.first.inspect
      render :action => 'new'
    end
  end

  def activate
    render :text => @actuality.activate
  end

  def destroy
    if @actuality.destroy
      flash[:notice] = t('actuality.destroy.success').capitalize
      return redirect_to([forgeos_cms, :admin, :actualities]) if !request.xhr?
    else
      flash[:error] = t('actuality.destroy.failed').capitalize
    end
    render :nothing => true
  end


private

  def get_actuality
    @actuality = Actuality.find_by_id(params[:id])
  end

  def new_actuality
    @actuality = Actuality.new(params[:actuality])
  end

  def sort
    columns = %w(id title date active)

    per_page = params[:iDisplayLength] ? params[:iDisplayLength].to_i : 10
    offset = params[:iDisplayStart] ? params[:iDisplayStart].to_i : 0
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:sSortDir_0] ? params[:sSortDir_0].upcase : 'ASC'}"

    conditions = {}
    includes = []
    options = {:page => page, :per_page => per_page }

    options[:conditions] = conditions unless conditions.empty?
    options[:include] = includes unless includes.empty?
    options[:order] = order unless order.squeeze.blank?

    joins = []
    joins << :translations


    if params[:sSearch] && !params[:sSearch].blank?
      @actualities = Actuality.search(params[:sSearch],options)
    else
      options[:joins] = joins
      @actualities = Actuality.paginate(options)
    end
  end


end
