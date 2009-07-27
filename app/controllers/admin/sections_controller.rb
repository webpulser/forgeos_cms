class Admin::SectionsController < Admin::BaseController
  def index
    @sections = Section.find :all, :order => 'position', :conditions => { :parent_id => nil }
  end

  def show
    get_section
  end
  
  def new
    @section = Section.new
    @sections = Section.find :all, :conditions => [ "parent_id IS NULL" ]
  end
  
  def create
    @section = Section.new(params[:section])
    @sections = Section.find :all, :conditions => [ "parent_id IS NULL" ]
    if @section && request.post?
      if @section.save
        flash[:notice] = I18n.t('section.create.success').capitalize
        return redirect_to admin_sections_path
      else
        flash[:error] = I18n.t('section.create.failed').capitalize
        render :action => "new"
      end
    end
  end

  def edit
    get_section
    @sections = Section.find :all, :conditions => [ "parent_id IS NULL AND id != ?", @section.id ] if @section
  end

  def update
    get_section
    @sections = Section.find :all, :conditions => [ "parent_id IS NULL AND id != ?", @section.id ] if @section

    if @section && request.put?

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
        return redirect_to admin_sections_path
      else
        flash[:error] = I18n.t('section.update.failed').capitalize unless has_flash_error?
        render :action => "edit"
      end
    end
  end

  def destroy
    get_section
    if @section && request.delete?
      @section.destroy
      flash[:notice] = I18n.t('section.destroy.success').capitalize
    else
      flash[:error] = I18n.t('section.destroy.failed').capitalize
    end
    return redirect_to admin_sections_path
  end

  def move_up
    get_section
    if @section
      @section.move_higher
      flash[:notice] = I18n.t('section.moved.up').capitalize
    else
      flash[:error] = I18n.t('section.not_exist').capitalize
    end
    return redirect_to admin_sections_path
  end
  
  def move_down
    get_section
    if @section
      @section.move_lower
      flash[:notice] = I18n.t('section.moved.down').capitalize
    else
      flash[:error] = I18n.t('section.not_exist').capitalize
    end
    return redirect_to admin_sections_path
  end

private

  def get_section
    @section = Section.find_by_id params[:id]
    flash[:error] = I18n.t('section.not_exist').capitalize unless @section 
  end

  def requires_position_update?(current_parent_id)
    return params[:section] && params[:section][:parent_id].to_i != current_parent_id.to_i
  end
end
