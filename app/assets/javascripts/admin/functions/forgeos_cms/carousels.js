/* --- CAROUSEL --- */

// copy carousel item div from empty carousel item and set new id
function add_new_carousel_item(){
  var new_item = '<div id="item_' + false_id + '" class="block-container widget-modify carousel">';
  new_item += jQuery('#empty_carousel_item').html().replace(/EMPTY_ID/g, false_id);
  new_item += '</div>';

  false_id--;
  jQuery('#carousel_items').append(new_item);
  update_block_container_positions(jQuery('#carousel_items'));
}

// clone content from div to form and then submit the form
function update_carousel_item(display_div, edition_div){
  var form = jQuery('#hidden_form');
  var url = jQuery(form).attr('action');
  var div = jQuery(form).find('.item_form');

  div.append(edition_div.html());

  // copy value of each input/textarea
  edition_div.find('input, textarea, select').each(function(){
    var div_input = div.find('#' + jQuery(this).attr('id'));
    div_input.val(jQuery(this).val());
  });

  // post carousel item data
  jQuery.ajax({
    url: url,
    data: jQuery(form).serialize(),
    success:function(request){
      // close edition mode
      jQuery(display_div).find('.edit-link').trigger('click');
    },
    type:'post'
  });

  // empty item form
  div.html('');
}

// hide carousel item container and set item delete value to 1
function remove_carousel_item(destroy_link){
  var block = jQuery(destroy_link).parents('.block-container');
  jQuery(block).hide();
  jQuery(block).find('.delete').val(1);
  update_block_container_positions(jQuery('#carousel_items'));
}

function add_picture_to_carousel_item(link,path,id,name){
  var image = jQuery(link).prevAll('img');
  image.attr('src', path);
  image.attr('alt', name);
  jQuery(link).prevAll('input').attr('value', id);
}
