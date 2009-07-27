module Admin::BaseHelper

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
