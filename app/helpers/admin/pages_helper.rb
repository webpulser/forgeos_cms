module Admin::PagesHelper
  # Returns a list of all top sections with their children 
  def get_sections_options(sections) 
    section_options = [] 
    # Insert all top sections 
    sections.each do |top_section| 
      section_options << [top_section.title, top_section.id] 
      # Insert all children of each top section 
      unless top_section.children.blank? 
        top_section.children.sort_by {|child| child.title}.each do |sub_section| 
          section_options << ["- #{sub_section.title}", sub_section.id] 
        end 
      end 
    end 
    return section_options 
  end
end
