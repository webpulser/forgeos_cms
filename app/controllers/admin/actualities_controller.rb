class Admin::ActualitiesController < Admin::BaseController

  uses_tiny_mce :only => [:new, :create, :edit, :update], :options => {
    :theme => 'advanced',
    :theme_advanced_resizing => true,
    :theme_advanced_resize_horizontal => false,
    :plugins => %w{ table fullscreen },
    :valid_elements => TMCEVALID
  }

  before_filter :get_actuality, :only => [:show, :edit, :show, :update, :destroy]
  before_filter :new_actuality, :only => [:new, :create]

  def index
    @actualities = Actuality.all
  end
  
  def show
  end
  
  def new
  end
  
  def edit
  end
  
  def create
    if @actuality.save
      flash[:notice] = I18n.t('actuality.create.success').capitalize
      return redirect_to([:admin,@actuality])
    else
      flash[:error] = I18n.t('actuality.create.failed').capitalize
      render :action => "new"
    end
  end

  def update
    if @actuality.update_attributes(params[:actuality])
      flash[:notice] = I18n.t('actuality.update.success').capitalize
      return redirect_to(admin_actualities_path)
    else
      flash[:error] = I18n.t('actuality.update.failed').capitalize
      render :action => "edit"
    end
  end
  
  def destroy
    if @actuality.destroy
      flash[:notice] = I18n.t('actuality.destroy.success').capitalize
    else
      flash[:error] = I18n.t('actuality.destroy.failed').capitalize
    end

    return redirect_to(admin_actualities_path)
  end

  private
  
    def get_actuality
      unless @actuality = Actuality.find_by_id(params[:id])
        flash[:error] = I18n.t('actuality.not_exist').capitalize
        return redirect_to(admin_actualities_path)
      end
    end

    def new_actuality
      @actuality = Actuality.new(params[:actuality])
    end
    
end
