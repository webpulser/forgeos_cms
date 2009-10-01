jQuery(document).ready(function(){
  // duplicate widget item
  $('.block-container.widget-modify .duplicate-link').live('click',function(){
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

  //Edition mode in widget edit
  $('.block-container.widget-modify .edit-link, .block-container.widget-modify .back-link').live('click',function(){
    var blockContainer=$(this).parents('.block-container.widget-modify');
    var blockNameBlocks=blockContainer.children('.block-name');
    var blockType=blockContainer.children('.block-type');

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