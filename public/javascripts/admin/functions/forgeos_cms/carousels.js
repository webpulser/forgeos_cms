/* --- CAROUSEL --- */

// copy carousel item div from empty carousel item and set new id
function add_new_carousel_item(){
  new_item = '<div id="item_' + false_id + '" class="block-container widget-modify carousel open">';
  new_item += $('#empty_carousel_item').html().replace(/EMPTY_ID/g, false_id);
  new_item += '</div>';

  false_id--;
  $('#carousel_items').append(new_item);
  update_block_container_positions($('#carousel_items'));
}

// clone content from div to form and then submit the form
function update_carousel_item(display_div, edition_div){
  var form = $('#hidden_form');
  var url = $(form).attr('action');
  var div = $(form).find('.item_form');

  div.append(edition_div.html());

  // copy value of each input/textarea
  edition_div.find('input, textarea, select').each(function(){
    div_input = div.find('#' + $(this).attr('id'));
    div_input.val($(this).val());
  });

  // post carousel item data
  $.ajax({
    url: url,
    data: $(form).serialize(),
    success:function(request){
      // close edition mode
      $(display_div).find('.edit-link').trigger('click');
    },
    type:'post'
  });

  // empty item form
  div.html('');
}

// hide carousel item container and set item delete value to 1
function remove_carousel_item(destroy_link){
  block = $(destroy_link).parents('.block-container');
  $(block).hide();
  $(block).find('.delete').val(1);
  update_block_container_positions($('#carousel_items'));
}

function add_picture_to_carousel_item(link,path,id,name){
  var image = $(link).prevAll('img');
  image.attr('src', path);
  image.attr('alt', name);
  $(link).prevAll('input').attr('value', id);
}
