module Admin::BaseHelper
  def hide_html_elements_onload(element_ids)
    return javascript_tag("$('##{element_ids.join(",#")}').hide()")
  end 

  def link_to_effect_toggle(title,element_id,effect = :toggle_appear )
    return link_to_function(title,visual_effect(effect,element_id))
  end

  def yield_for_tools
    content_for :tools, link_to(I18n.t('back').capitalize, :back, :class => 'back')
    out = ''
    @content_for_tools.each do |content|
      out += content_tag('li', content) unless content.blank?
    end
    return out
  end

  def editor_toggler
    javascript_tag "
    function toggleEditor(id,textLink) {
      if (!tinyMCE.get(id)) {
          tinyMCE.execCommand('mceAddControl', false, id);
          $(textLink).text('#{escape_javascript I18n.t('editor.hide.action').capitalize}');
        } else {
          tinyMCE.execCommand('mceRemoveControl', false, id);
          $(textLink).text('#{escape_javascript I18n.t('editor.show.action').capitalize}');
      }
    }"
  end
  
  def include_tiny_mce_if_needed
    super + editor_toggler
  end
end
