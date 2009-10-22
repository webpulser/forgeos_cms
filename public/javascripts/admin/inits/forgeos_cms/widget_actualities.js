jQuery(document).ready(function(){
  $('.create-actuality').live('click', function() {
    create_actuality('item_' + false_id);
    return false;
  });
  
  $('.update-actuality').live('click', function() {
    update_actuality('item_' + actuality_id);
    return false;
  });

  $('.duplicate-actuality').live('click', function() {
    duplicate_actuality('item_' + false_id);
    return false;
  });

  // Edition mode in widget actuality item edit
  $('.block-container.widget-modify.actuality .back-link').live('click',function(){
    $('.lightbox-actuality').dialog('close');

    // empty fields
    $(this).parents('.block-name').find('.widget_actuality_title input').val('');
    $(this).parents('.block-name').find('.widget_actuality_content textarea').val('');
    return false;
  });
});