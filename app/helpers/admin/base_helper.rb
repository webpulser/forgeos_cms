load File.join(Gem.loaded_specs['forgeos_core'].full_gem_path, 'app', 'helpers', 'admin', 'base_helper.rb')

module Admin::BaseHelper
  def block_container(model_name, block_name, block, &proc)
    content_tag :div, :class => 'block-container ui-corner-all' do
      content_tag(:span, :class => 'block-type') do
        content_tag(:span, content_tag(:span, '&nbsp;', :class => 'inner'), :class => 'handler') +
        block.model_name.human
      end +
      content_tag(:span, capture(&proc), :class => 'block-name') +
      link_to('', [:edit, :admin, block], :class => 'small-icons edit-link', :popup => true) +
      link_to('', '#', :class => 'big-icons gray-destroy') +
      hidden_field_tag("#{model_name}[#{block_name}_ids][]", block.id, :class => 'block-selected')
    end
  end
end
