/* --- CAROUSEL --- */

// copy carousel item div from empty carousel item and set new id
function add_new_carousel_item(){
  new_item = '<div id="item_' + false_id + '" class="block-container widget-modify open">';
  new_item += $('#empty_carousel_item').html().replace(/EMPTY_ID/g, false_id);
  new_item += '</div>';

  false_id--;
  $('#carousel_items').append(new_item);
}

// clone content from div to form and then submit the form
function update_carousel_item(display_div, edition_div){
  form = $('#hidden_form');
  div = $(form).find('.item_form');
  div.append(edition_div.html());

  // copy value of each input/textarea
  edition_div.find('input, textarea, select').each(function(){
    div_input = div.find('#' + $(this).attr('id'));
    div_input.val($(this).val());
  });

  $(form).trigger('onsubmit');
  div.html('');
}

// hide carousel item container and set item delete value to 1
function remove_carousel_item(destroy_link){
  block = $(destroy_link).parents('.block-container');
  $(block).hide();
  $(block).find('.delete').val(1);
}