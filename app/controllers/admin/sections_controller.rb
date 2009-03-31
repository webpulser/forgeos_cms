class Admin::SectionsController < Admin::BaseController
  def index
    @sections = Section.find :all, :order => 'position', :conditions => { :parent_id => nil }
  end

  def show
    get_section
  end

  def create
    @section = Section.new(params[:section])
    @sections = Section.find :all, :conditions => [ "parent_id IS NULL" ]
    if @section && request.post?
      if @section.save
        flash[:notice] = 'The section was successfully created'
        return redirect_to(:action => 'index')
      else
        flash[:error] = "The section can't be created"
      end
    end
  end

  def edit
    get_section
    @sections = Section.find :all, :conditions => [ "parent_id IS NULL AND id != ?", @section.id ] if @section

    if @section && request.post?

      # removes sub-section from parent sections
      old_parent_id = @section.parent ? @section.parent.id : nil
      @section.remove_from_list if requires_position_update? old_parent_id

      if @section.update_attributes(params[:section])

        # adds sub-section to parent sections
        if requires_position_update? old_parent_id
          @section.insert_at
          @section.move_to_bottom
        end

        flash[:notice] = 'The section was successfully updated'
        return redirect_to(:action => 'index')
      else
        flash[:error] = "The section can't be updated" unless has_flash_error?
      end
    end
  end

  def delete
    get_section
    if @section && @section.destroy
      flash[:notice] = 'The section was successfully deleted'
    else
      flash[:error] = "The section can't be deleted"
    end
    return redirect_to(:action => 'index')
  end

  def order
    get_section
    if @section && params[:order]
      case params[:order]
      when 'up'
        @section.move_higher
        flash[:notice] = 'The section was successfully moved upper'
      when 'down'
        @section.move_lower
        flash[:notice] = 'The section was successfully moved lower'
      end
    end
    return redirect_to(:action => 'index')
  end

private

  def get_section
    @section = Section.find_by_id params[:id]
    flash[:error] = 'The requested section does not exist' unless @section 
  end

  def requires_position_update?(current_parent_id)
    return params[:section] && params[:section][:parent_id].to_i != current_parent_id.to_i
  end
end
