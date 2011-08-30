var false_id = -1;
var current_carousel_item_link = null;

jQuery(document).ready(function(){

  jQuery('.change-picture').live('click',function(){
    current_carousel_item_link = jQuery(this);
    jQuery('.add-image').removeClass('current');
    current_carousel_item_link.addClass('add-image');
    current_carousel_item_link.addClass('current');
    current_carousel_item_link.data('callback', 'add_picture_to_carousel_item');
    openimageUploadDialog();
    return false;
  });

  jQuery('.button-carousel-item').bind('click', function() {
    add_new_carousel_item('item_' + false_id);
    return false;
  });

  // Duplicate widget carousel item
  jQuery('.block-container.widget-modify.carousel .duplicate-link').live('click',function(){
    // get source carousel
    var src_item = jQuery(this).parents('.block-container').find('.inner_block-container');
    var display_block = jQuery(src_item.children('.block-name')[0]);
    var link = jQuery(display_block).find('a');

    // attribute values
    var title = link.html();
    var url = link.attr('href');
    var description = jQuery(display_block).find('p').html();

    // create new empty carousel item
    var item_id = 'item_' + false_id;
    add_new_carousel_item(item_id);
    var new_item = jQuery('#carousel_items').find('#' + item_id);

    // picture
    var src_img = jQuery(src_item).find('img');
    var new_img = jQuery(new_item).find('img');

    jQuery(new_img).attr('src', jQuery(src_img).attr('src'));
    jQuery(new_img).attr('alt', jQuery(src_img).attr('alt'));
    jQuery(new_img).nextAll('input').val(jQuery(src_img).nextAll('input').val());

    // copy value of each input/textarea
    jQuery(new_item).find('input, textarea, select').each(function(){
      switch(get_rails_element_id(jQuery(this)))
        {
        case 'title':
          jQuery(this).val(title);
          break;
        case 'url':
          jQuery(this).val(url.replace('http://', ''));
          break;
        case 'description':
          jQuery(this).val(description);
          break;
        }
    });

    // copy value for display block
    var new_display_block = jQuery(new_item.children('.block-name')[0]);
    jQuery(new_display_block).children('a').html(title);
    jQuery(new_display_block).children('href').html(url);
    jQuery(new_display_block).find('p').html(description);
    return false;
  });

  //Edition mode in widget carousel item edit
  jQuery('.block-container.widget-modify.carousel .edit-link, .block-container.widget-modify.carousel .back-link').live('click',function(){
    var blockContainer = jQuery(this).parents('.block-container.widget-modify').find('.inner_block-container');
    var blockNameBlocks = blockContainer.children('.block-name');
    var blockType = blockContainer.children('.block-type');

    blockType.toggle();
    blockNameBlocks.toggle();
    blockContainer.toggleClass('open');

    // on closing edition block
    if (!jQuery(blockContainer).hasClass('open')){
      var display_block = blockNameBlocks[0];
      var edition_block = blockNameBlocks[1];
      var link = jQuery(display_block).find('a');
      var edition_img = jQuery(edition_block).find('img');
      var display_img = jQuery(blockType).find('img');

      // update attributes
      if (jQuery(this).hasClass('edit-link')) {
        // picture
        jQuery(display_img).attr('src', jQuery(edition_img).attr('src'));
        jQuery(display_img).attr('alt', jQuery(edition_img).attr('alt'));

        // title, url and description
        jQuery(edition_block).find('input, textarea, select').each(function(){
            switch(get_rails_element_id(jQuery(this)))
              {
              case 'title':
                link.html(jQuery(this).val());
                break;
              case 'url':
                link.attr('href', 'http://' + jQuery(this).val());
                break;
              case 'description':
                jQuery(display_block).find('p').html(jQuery(this).val());
                break;
              }
          });
      }
      // reset attributes
      else {
        // picture
        jQuery(edition_img).attr('src', jQuery(display_img).attr('src'));
        jQuery(edition_img).attr('alt', jQuery(display_img).attr('alt'));

        // title, url and description
        jQuery(edition_block).find('input, textarea, select').each(function(){
            switch(get_rails_element_id(jQuery(this)))
              {
              case 'title':
                jQuery(this).val(link.html());
                break;
              case 'url':
                jQuery(this).val(link.attr('href').replace('http://', ''));
                break;
              case 'description':
                jQuery(this).val(jQuery(display_block).find('p').html());
                break;
              }
          });
      }
    }
    return false;
  });
});
