class Admin::NewslettersController < Admin::BaseController
  before_filter :get_newsletter, :only => [:edit, :destroy, :show, :update, :activate, :duplicate]
  before_filter :new_newsletter, :only => [:new, :create]

  def index
    respond_to do |format|
      format.html
      format.json do
        sort
        render :layout => false
      end
      format.csv do
        params[:iDisplayLength] = 1000000
        sort
        csv_string = FasterCSV.generate( {:force_quotes => true}) do |csv|
          csv << @newsletters.first.attributes.keys

          @newsletters.each do |record|
            csv << record.attributes.values
          end

        end
        send_data csv_string,
        :type => 'text/csv; charset=utf-8; header=present',
        :disposition => "attachment; filename=#{controller_name}.csv"
      end
    end
  end

  def edit

  end

  def update
    if @newsletter.update_attributes(params[:newsletter])
      flash[:notice] = I18n.t('newsletter.update.success').capitalize
      redirect_to([forgeos_cms, :edit, :admin, @newsletter])
    else
      flash[:error] = I18n.t('newsletter.update.failed').capitalize
      render :action => 'edit'
    end
  end

  def new

  end

  def create
    if @newsletter.save
      flash[:notice] = I18n.t('newsletter.create.success').capitalize
      redirect_to([forgeos_cms, :edit, :admin, @newsletter])
    else
      flash[:error] = I18n.t('newsletter.create.failed').capitalize
      render :new
    end
  end

  def destroy
     @deleted = @newsletter.destroy
    if @deleted
      flash[:notice] = I18n.t('newsletter.destroy.success').capitalize
      return redirect_to([forgeos_cms, :admin, :newsletters]) if !request.xhr?
    else
      flash[:error] = I18n.t('newsletter.destroy.failed').capitalize
    end
    render :nothing => true
  end

private

  def get_newsletter
    unless @newsletter = Newsletter.find_by_id(params[:id])
      flash[:error] = I18n.t('Newsletter non trouvée').capitalize
      return redirect_to([forgeos_cms, :admin, :newsletters])
    end
  end


  def new_newsletter
    @newsletter = Newsletter.new(params[:newsletter])
  end

  def sort
    columns = %w(email created_at)

    per_page = params[:iDisplayLength] ? params[:iDisplayLength].to_i : 10
    offset = params[:iDisplayStart] ? params[:iDisplayStart].to_i : 0
    page = (offset / per_page) + 1
    order = "#{columns[params[:iSortCol_0].to_i]} #{params[:sSortDir_0] ? params[:sSortDir_0].upcase : 'ASC'}"

    conditions = {}
    includes = []
    options = { :page => page, :per_page => per_page }
    joins = []

    options[:conditions] = conditions unless conditions.empty?
    options[:include] = includes unless includes.empty?
    options[:order] = order unless order.squeeze.blank?
    options[:joins] = joins

    if params[:sSearch] && !params[:sSearch].blank?
      options[:joins] += options.delete(:include)
      options[:sql_order] = options.delete(:order)
      options[:star] = true
      @newsletters = Newsletter.search(params[:sSearch],options)
    else
      @newsletters = Newsletter.paginate(options)
    end
  end
end
