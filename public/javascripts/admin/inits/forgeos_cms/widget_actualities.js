jQuery(document).ready(function(){
  jQuery('.create-actuality').live('click', function() {
    create_actuality('item_' + false_id);
    return false;
  });
  
  jQuery('.update-actuality').live('click', function() {
    update_actuality('item_' + actuality_id);
    return false;
  });

  jQuery('.duplicate-actuality').live('click', function() {
    duplicate_actuality('item_' + false_id);
    return false;
  });

  // Edition mode in widget actuality item edit
  jQuery('.block-container.widget-modify.actuality .back-link').live('click',function(){
    jQuery('.lightbox-actuality').dialog('close');
    empty_actuality_overlay_fields();
    return false;
  });
});