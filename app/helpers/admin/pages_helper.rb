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

  def block_container(model_name, block_name, block)
    content_tag :div, :class => 'block-container' do
      content_tag(:span, :class => 'block-type') do
        content_tag(:span, content_tag(:span, '&nbsp;', :class => 'inner'), :class => 'handler') +
        block.class.to_s
      end +
      content_tag(:span, block.title, :class => 'block-name') +
      link_to('', '#', :class => 'big-icons gray-destroy') +
      hidden_field_tag("#{model_name}[#{block_name}_ids][]", block.id)
    end
  end
end
