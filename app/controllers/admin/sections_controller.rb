class Admin::SectionsController < Admin::BaseController
  before_filter :get_section, :only => [:show, :edit, :update, :destroy, :move_up, :move_down]
  before_filter :get_sections, :only => [:index, :edit, :update]
  before_filter :new_section, :only => [:new, :create]

  def index
  end

  def show
  end
  
  def new
  end

  def edit
  end
  
  def create
    if @section.save
      flash[:notice] = I18n.t('section.create.success').capitalize
      return redirect_to(admin_sections_path)
    else
      flash[:error] = I18n.t('section.create.failed').capitalize
      render :action => "new"
    end
  end
  
  def update
    # removes sub-section from parent sections
    old_parent_id = @section.parent ? @section.parent.id : nil
    @section.remove_from_list if requires_position_update? old_parent_id

    if @section.update_attributes(params[:section])

      # adds sub-section to parent sections
      if requires_position_update? old_parent_id
        @section.insert_at
        @section.move_to_bottom
      end

      flash[:notice] = I18n.t('section.update.success').capitalize
      return redirect_to(admin_sections_path)
    else
      flash[:error] = I18n.t('section.update.failed').capitalize
      render :action => "edit"
    end
  end

  def destroy
    if @section.destroy
      flash[:notice] = I18n.t('section.destroy.success').capitalize
    else
      flash[:error] = I18n.t('section.destroy.failed').capitalize
    end
    return redirect_to(admin_sections_path)
  end

  def move_up
    @section.move_higher
    flash[:notice] = I18n.t('section.moved.up').capitalize
    return redirect_to(admin_sections_path)
  end
  
  def move_down
    @section.move_lower
    flash[:notice] = I18n.t('section.moved.down').capitalize
    return redirect_to(admin_sections_path)
  end

  def url
    render :text => Forgeos::url_generator(params[:url])
  end

private

  def get_section
    unless @section = Section.find_by_id(params[:id])
      flash[:error] = I18n.t('section.not_exist').capitalize
      return redirect_to(admins_sections_path)
    end
  end

  def get_sections
    if @section
      @sections = Section.all(:conditions => [ "parent_id IS NULL AND id != ?", @section.id ])
    else
      @sections = Section.all :order => 'position', :conditions => { :parent_id => nil }
    end
  end

  def new_section
    @section = Section.new(params[:section])
    @sections = Section.all(:conditions => [ "parent_id IS NULL" ])
  end

  def requires_position_update?(current_parent_id)
    return params[:section] && params[:section][:parent_id].to_i != current_parent_id.to_i
  end
end
