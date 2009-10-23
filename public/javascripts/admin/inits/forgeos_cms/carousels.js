false_id = -1;

jQuery(document).ready(function(){
  current_carousel_item_link = null;

  $('.change-picture').live('click',function(){
    current_carousel_item_link = $(this).attr('id');
    openimageUploadDialog($(this));
    return false;
  });

  $('.button-carousel-item').bind('click', function() {
    add_new_carousel_item('item_' + false_id);
    return false;
  });

  $('#limited-time-offer-end').bind('click', function() {
    $(this).val('');
  });

  $('#limited-time-offer-end').bind('blur', function() {
    $(this).val('dd/mm/yyyy');
  });

  /* Inline create right*/
  $('.create-right').live('click', function(){

    /* Create the form, and move it around the table */
    $('#table').wrap('<form action="/admin/rights/create" id="form_right" method="POST" onsubmit="' + form_ajax_right('/admin/rights/create', 'post') + '"></form>');

    /* Create new row-right */
    new_row = '<tr id="new_right" class="even ui-draggable">';
      new_row += '<td><div class="small-icons right-ico">&nbsp;</div></td>';
      new_row += '<td><input type="text" name="right[name]" size="15" /></td>';
      new_row += '<td><input type="text" name="right[controller_name]" size="15" /></td>';
      new_row += '<td><input type="text" name="right[action_name]" size="15" /></td>';
      new_row += '<td>';
         new_row += '<a href="#" onclick="$(\'#form_right\').trigger(\'onsubmit\'); return false;"><span class="small-icons green-add-right-icon">&nbsp;</span></a>';
         new_row += '<a href="#" onclick="discard(); return false;"><span class="small-icons red-delete-right-icon">&nbsp;</span></a>';
      new_row += '</td>';
    new_row += '</tr>';

    $('#table').prepend(new_row);

    disable_links();

  });

  /* Inline edit right */
  $('.edit-right').live('click', function(){

    row = $(this).parents('tr');
    row_id = row.attr('id');

    right_id = get_rails_element_id(row);

    /* Get each cell */
    cell_name = row.children().get(1);
    cell_controller = row.children().get(2);
    cell_action = row.children().get(3);
    cell_actions = $(this).parent();

    /* Get each value */
    cell_name_value = $(cell_name).children('div').html();
    cell_controller_value = $(cell_controller).html();
    cell_action_value = $(cell_action).html();

    /* Create form, & move it around the table */
    $('table').wrap('<form action="/admin/rights/'+right_id+'" id="form_right" method="PUT" onsubmit="'+form_ajax_right('/admin/rights/'+right_id, 'put')+'"></form>');

    /* Create a row with values of the selected rights */
    new_row = '<tr id="new_right" class="odd ui-draggable">';
      new_row += '<td><div class="small-icons right-ico">&nbsp;</div></td>';
      new_row += '<td><input type="text" value="'+ cell_name_value +'" name="right[name]" size="15"/></td>';
      new_row += '<td><input type="text" value="'+ cell_controller_value +'" name="right[controller_name]" size="15"/></td>';
      new_row += '<td><input type="text" value="'+ cell_action_value +'" name="right[action_name]" size="15"/></td>';
      new_row += '<td>';
         new_row += '<a href="#" onclick="$(\'#form_right\').trigger(\'onsubmit\'); return false;"><span class="small-icons green-add-right-icon">&nbsp;</span></a>';
         new_row += '<a href="#" onclick="discard(); row.show(); return false;"><span class="small-icons red-delete-right-icon">&nbsp;</span></a>';
      new_row += '</td>';
    new_row += '</tr>';

    row.hide();
    row.after(new_row);

    disable_links();

  });

  /* Inline duplicate right*/
  // :right => right_clone
  $('.duplicate-right').live('click', function(){

    row = $(this).parents('tr');

    /* Get each cell */
    cell_name = row.children().get(1);
    cell_controller = row.children().get(2);
    cell_action = row.children().get(3);
    cell_actions = $(this).parent();

    /* Get each value */
    cell_name_value = $(cell_name).children('div').html();
    cell_controller_value = $(cell_controller).html();
    cell_action_value = $(cell_action).html();

    /* Create the form, and move it around the table */
    $('#table').wrap('<form action="/admin/rights/create" id="form_right" method="POST" onsubmit="' + form_ajax_right('/admin/rights/create', 'post') + '"></form>');

    /* Create new row-right */
    new_row = '<tr id="new_right" class="'+ row.attr('class') +' ui-draggable">';
      new_row += '<td><div class="small-icons right-ico">&nbsp;</div></td>';
      new_row += '<td><input type="text" value="'+ cell_name_value +'" name="right[name]" size="15" /></td>';
      new_row += '<td><input type="text" value="'+ cell_controller_value +'" name="right[controller_name]" size="15" /></td>';
      new_row += '<td><input type="text" value="'+ cell_action_value +'" name="right[action_name]" size="15" /></td>';
      new_row += '<td>';
         new_row += '<a href="#" onclick="$(\'#form_right\').trigger(\'onsubmit\'); return false;"><span class="small-icons green-add-right-icon">&nbsp;</span></a>';
         new_row += '<a href="#" onclick="discard(); return false;"><span class="small-icons red-delete-right-icon">&nbsp;</span></a>';
      new_row += '</td>';
    new_row += '</tr>';

    row.after(new_row);

    disable_links();

  });

  // Duplicate widget carousel item
  $('.block-container.widget-modify.carousel .duplicate-link').live('click',function(){
    // get source carousel
    src_item = $(this).parents('.block-container');
    display_block = $(src_item.children('.block-name')[0]);
    link = $(display_block).find('a');

    // attribute values
    title = link.html();
    url = link.attr('href');
    description = $(display_block).find('p').html();

    // create new empty carousel item
    item_id = 'item_' + false_id;
    add_new_carousel_item(item_id);
    new_item = $('#carousel_items').find('#' + item_id);

    // picture
    src_img = $(src_item).find('img');
    new_img = $(new_item).find('img');

    $(new_img).attr('src', $(src_img).attr('src'));
    $(new_img).attr('alt', $(src_img).attr('alt'));
    $(new_img).nextAll('input').val($(src_img).nextAll('input').val());

    // copy value of each input/textarea
    $(new_item).find('input, textarea, select').each(function(){
      switch(get_rails_element_id($(this)))
        {
        case 'title':
          $(this).val(title);
          break;
        case 'url':
          $(this).val(url.replace('http://', ''));
          break;
        case 'description':
          $(this).val(description);
          break;
        }
    });

    // copy value for display block
    new_display_block = $(new_item.children('.block-name')[0]);
    $(new_display_block).children('a').html(title);
    $(new_display_block).children('href').html(url);
    $(new_display_block).find('p').html(description);
    return false;
  });

  //Edition mode in widget carousel item edit
  $('.block-container.widget-modify.carousel .edit-link, .block-container.widget-modify.carousel .back-link').live('click',function(){
    var blockContainer = $(this).parents('.block-container.widget-modify');
    var blockNameBlocks = blockContainer.children('.block-name');
    var blockType = blockContainer.children('.block-type');

    blockType.toggle();
    blockNameBlocks.toggle();
    blockContainer.toggleClass('open');

    // on closing edition block
    if (!$(blockContainer).hasClass('open')){
      display_block = blockNameBlocks[0];
      edition_block = blockNameBlocks[1];
      link = $(display_block).find('a');
      edition_img = $(edition_block).find('img');
      display_img = $(blockType).find('img');

      // update attributes
      if ($(this).hasClass('edit-link')) {
        // picture
        $(display_img).attr('src', $(edition_img).attr('src'));
        $(display_img).attr('alt', $(edition_img).attr('alt'));

        // title, url and description
        $(edition_block).find('input, textarea, select').each(function(){
            switch(get_rails_element_id($(this)))
              {
              case 'title':
                link.html($(this).val());
                break;
              case 'url':
                link.attr('href', 'http://' + $(this).val());
                break;
              case 'description':
                $(display_block).find('p').html($(this).val());
                break;
              }
          });
      }
      // reset attributes
      else {
        // picture
        $(edition_img).attr('src', $(display_img).attr('src'));
        $(edition_img).attr('alt', $(display_img).attr('alt'));

        // title, url and description
        $(edition_block).find('input, textarea, select').each(function(){
            switch(get_rails_element_id($(this)))
              {
              case 'title':
                $(this).val(link.html());
                break;
              case 'url':
                $(this).val(link.attr('href').replace('http://', ''));
                break;
              case 'description':
                $(this).val($(display_block).find('p').html());
                break;
              }
          });
      }
    }
    return false;
  });
});
