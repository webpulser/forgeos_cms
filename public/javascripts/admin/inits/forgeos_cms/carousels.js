var false_id = -1;
var current_carousel_item_link = null;

jQuery(document).ready(function(){

  $('.change-picture').live('click',function(){
    current_carousel_item_link = $(this).attr('id');
    openimageUploadDialog($(this));
    return false;
  });

  $('.button-carousel-item').bind('click', function() {
    add_new_carousel_item('item_' + false_id);
    return false;
  });

  // Duplicate widget carousel item
  $('.block-container.widget-modify.carousel .duplicate-link').live('click',function(){
    // get source carousel
    var src_item = $(this).parents('.block-container').find('.inner_block-container');
    var display_block = $(src_item.children('.block-name')[0]);
    var link = $(display_block).find('a');

    // attribute values
    var title = link.html();
    var url = link.attr('href');
    var description = $(display_block).find('p').html();

    // create new empty carousel item
    var item_id = 'item_' + false_id;
    add_new_carousel_item(item_id);
    var new_item = $('#carousel_items').find('#' + item_id);

    // picture
    var src_img = $(src_item).find('img');
    var new_img = $(new_item).find('img');

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
    var new_display_block = $(new_item.children('.block-name')[0]);
    $(new_display_block).children('a').html(title);
    $(new_display_block).children('href').html(url);
    $(new_display_block).find('p').html(description);
    return false;
  });

  //Edition mode in widget carousel item edit
  $('.block-container.widget-modify.carousel .edit-link, .block-container.widget-modify.carousel .back-link').live('click',function(){
    var blockContainer = $(this).parents('.block-container.widget-modify').find('.inner_block-container');
    var blockNameBlocks = blockContainer.children('.block-name');
    var blockType = blockContainer.children('.block-type');

    blockType.toggle();
    blockNameBlocks.toggle();
    blockContainer.toggleClass('open');

    // on closing edition block
    if (!$(blockContainer).hasClass('open')){
      var display_block = blockNameBlocks[0];
      var edition_block = blockNameBlocks[1];
      var link = $(display_block).find('a');
      var edition_img = $(edition_block).find('img');
      var display_img = $(blockType).find('img');

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
