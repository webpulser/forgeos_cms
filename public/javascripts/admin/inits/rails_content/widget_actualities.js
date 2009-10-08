jQuery(document).ready(function(){
  $('.create-actuality').live('click', function() {
    create_actuality('item_' + false_id);
    return false;
  });
  
  $('.update-actuality').live('click', function() {
    update_actuality('item_' + false_id);
    return false;
  });

  $('.duplicate-actuality').live('click', function() {
    duplicate_actuality('item_' + false_id);
    return false;
  });
});