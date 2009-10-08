/* --- WIDGET ACTUALITIES --- */

function add_new_actuality(){

  new_item = '<div id="item_' + false_id + '" class="block-container widget-modify open">';
  new_item += $('#empty_actuality').html().replace(/EMPTY_ID/g, false_id);
  new_item += '</div>';

  title = $('#widget_actuality_items_attributes_FORM_ID_title').val();
  content = $('#widget_actuality_items_attributes_FORM_ID_content').val();

  $('#widget_actuality_items_attributes_FORM_ID_title').val('');
  $('#widget_actuality_items_attributes_FORM_ID_content').val('');


  $('#actualities').append(new_item);
  
  p_title = '<p id="widget_actuality_item_title_'+false_id+'">'+title+'</p>';
  p_content = '<p id="widget_actuality_item_description'+false_id+'">'+content+'</p>';
  $('#widget_actuality_items_attributes_'+ false_id +'_title').before(p_title);
  $('#widget_actuality_items_attributes_'+ false_id +'_title').val(title);
  $('#widget_actuality_items_attributes_'+ false_id +'_content').before(p_content);
  $('#widget_actuality_items_attributes_'+ false_id +'_content').val(content);

  false_id--;

  $('.lightbox-actuality').dialog('close');
  
}

function edit_actuality(edit_link) {
  block = $(edit_link).parents('.block-container');

  console.log(block)

//  edit_item_id = block.find('.block-type').attr('id').split('_');
//  id = edit_item_id[2];
//  title = $('#widget_actuality_items_attributes_'+ id +'_title').val();
//  content = $('#widget_actuality_items_attributes_'+ id +'_content').val();
//
//  console.log(title);
//  console.log(content);
//

}

// clone content from div to form and then submit the form
function update_actuality(display_div, edition_div){
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
function remove_actuality(destroy_link){
  block = $(destroy_link).parents('.block-container');
  $(block).hide();
  $(block).find('.delete').val(1);
}