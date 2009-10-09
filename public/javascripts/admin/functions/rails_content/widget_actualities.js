/* --- WIDGET ACTUALITIES --- */

function create_actuality(){

  new_actuality = '<div id="item_' + false_id + '" class="block-container widget-modify open">';
  new_actuality += $('#empty_actuality').html().replace(/EMPTY_ID/g, false_id);
  new_actuality += '</div>';

  title = $('#widget_actuality_items_attributes_FORM_ID_title').val();
  content = $('#widget_actuality_items_attributes_FORM_ID_content').val();


  if ( title == '' || content == '' ) {
    alert('The two fields are required.')
  } else {
    $('#widget_actuality_items_attributes_FORM_ID_title').val('');
    $('#widget_actuality_items_attributes_FORM_ID_content').val('');

    $('#actualities').append(new_actuality);

    p_title = '<p id="widget_actuality_item_title_'+false_id+'">'+title+'</p>';
    p_content = '<p id="widget_actuality_item_content_'+false_id+'">'+content+'</p>';
    $('#widget_actuality_items_attributes_'+ false_id +'_title').before(p_title);
    $('#widget_actuality_items_attributes_'+ false_id +'_title').val(title);
    $('#widget_actuality_items_attributes_'+ false_id +'_content').before(p_content);
    $('#widget_actuality_items_attributes_'+ false_id +'_content').val(content);


    $('.lightbox-actuality').dialog('close');
    false_id--;
  }

}

function duplicate_actuality(item_id) {
  block = $('#'+item_id);

  block_array = item_id.split('_');
  id = block_array[1];

  inputs = block.find('input');
  title = $(inputs[inputs.length - 1]).val();
  content = $(block.find('textarea')).val();
  
  new_actuality = '<div id="item_'+ false_id +'" class="block-container widget-modify open">';
  new_actuality += $('#empty_actuality').clone().html().replace(/EMPTY_ID/g, false_id);
  new_actuality += '</div>';
  
//  new_actuality = block.clone();
//  regexp = new RegExp('_'+id,"gi");
//  new_actuality.html().replace(regexp, false_id);


  block.after(new_actuality);
  
  p_title = '<p id="widget_actuality_item_title_'+false_id+'">'+title+'</p>';
  p_content = '<p id="widget_actuality_item_content_'+false_id+'">'+content+'</p>';
  $('#widget_actuality_items_attributes_'+ false_id +'_title').before(p_title);
  $('#widget_actuality_items_attributes_'+ false_id +'_title').val(title);
  $('#widget_actuality_items_attributes_'+ false_id +'_content').before(p_content);
  $('#widget_actuality_items_attributes_'+ false_id +'_content').val(content);
  
  false_id--;
  
}

function edit_actuality(edit_link) {
  block = $(edit_link).parents('.block-container');

  block_id = block.attr('id').split('_');
  actuality_id = block_id[1];

  inputs = block.find('input');
  title = $(inputs[inputs.length - 1]).val();
  content = $(block.find('textarea')).val();

  $('#widget_actuality_items_attributes_FORM_ID_title').val(title);
  $('#widget_actuality_items_attributes_FORM_ID_content').val(content);

}

function update_actuality() {
  block = $('#item_'+actuality_id);

console.log(block);
  title = $('#widget_actuality_items_attributes_FORM_ID_title').val();
  content = $('#widget_actuality_items_attributes_FORM_ID_content').val();

  $('#widget_actuality_items_attributes_FORM_ID_title').val('');
  $('#widget_actuality_items_attributes_FORM_ID_content').val('');


  inputs = block.find('input');
  console.log($(inputs[inputs.length - 1]));
  $(inputs[inputs.length - 1]).val(title);
  $(block.find('textarea')).val(content);
  console.log($(block.find('textarea')));
  
//  $('#widget_actuality_items_attributes_'+ actuality_id +'_title').val(title);
  $('#widget_actuality_item_title_'+actuality_id).html(title);
  
//  $('#widget_actuality_items_attributes_'+ actuality_id +'_content').val(content);
  $('#widget_actuality_item_content_'+actuality_id).html(content);
  
  $('.lightbox-actuality').dialog('close');
}

// hide actuality container and set item delete value to 1
function remove_actuality(destroy_link){
  block = $(destroy_link).parents('.block-container');
  $(block).hide();
  $(block).find('.delete').val(1);
}
