function toggle_menu_types_overlays(id){
  var overlay_to_turn_off = (id == 'target-link') ? '#external-link' : '#target-link';
  var overlay_to_turn_on = (id == 'target-link') ? '#target-link' : '#external-link';

  if (jQuery(overlay_to_turn_off).is(':visible'))
    jQuery(overlay_to_turn_off).hide();
  jQuery(overlay_to_turn_on).show();
}

function update_menu_link(title, link_span, link, url, link_type, target_id, target_type, data){
  // update link
  if (title.val() == '')
    title.val(data.title);
  link_span.addClass(data.type);
  link.html(data.link_name);
  link.attr('href', data.link_url);

  // update hidden fields
  url.val(data.hidden_url);
  link_type.val(data.hidden_type);
  target_id.val(data.hidden_target_id);
  target_type.val(data.hidden_target_type);
}

function update_menu_span_icon(base_span, span_to_update){
  span_to_update.removeClass('external page product category');
  if (base_span.hasClass('external'))
    span_to_update.addClass('external');
  else if (base_span.hasClass('page'))
    span_to_update.addClass('page');
  else if (base_span.hasClass('product'))
    span_to_update.addClass('product');
  else if (base_span.hasClass('category'))
    span_to_update.addClass('category');
}

// mode is either 'open' or 'closed'
function toggle_menu_link(menu_link, mode){
  var folder = (mode == 'closed') ? 'file' : 'folder';

  if (menu_link.hasClass('closed')){
    menu_link.removeClass('closed');
    menu_link.addClass('open');
  } else {
    menu_link.addClass('closed');
    menu_link.removeClass('open');
  }

  if (!menu_link.hasClass(folder)){
    menu_link.toggleClass('file');
    menu_link.toggleClass('folder');
  }
}

// update position for each child of the list and for their children
function update_menu_positions(list){
  jQuery(list).children('li').each(function(){
    var index = jQuery(this).parent().children('li').index(this);
    var position = jQuery(this).find('.menu_link:first').find('input:regex(id,.+_position)');
    var child_list = jQuery(this).children('ul:first');

    position.val(index);

    // update those of its children
    if (child_list.length > 0)
      update_menu_positions(child_list);
  });
}

// update name, id and parent_id for each child of the list and for their children
function update_menu_names_and_ids(list, base_name, base_id){
  jQuery(list).children('li').each(function(){
    var index = jQuery(this).parent().children('li').index(this);
    var name = base_name + '[' + index + ']';
    var id = base_id + index;

    var parent_id = jQuery(this).parents('li:first').find('input:regex(id,.+_id)')[0];
    var input_parent_id = jQuery(this).find('.menu_link:first').find('input:regex(id,.+_parent_id)');
    var input_menu_id = jQuery(this).find('.menu_link:first').find('input:regex(id,.+_menu_id)');

    var child_list = jQuery(this).children('ul:first');

    // update parent_id
    if (parent_id){
      input_parent_id.val(jQuery(parent_id).val());
      input_menu_id.val('');
    }else{
      input_parent_id.val('');
      input_menu_id.val(get_id_from_rails_url());
    }

    // update those of its children
    if (child_list.length > 0)
      update_menu_names_and_ids(child_list, name + '[children_attributes]', id + '_children_attributes_');
  });
}
