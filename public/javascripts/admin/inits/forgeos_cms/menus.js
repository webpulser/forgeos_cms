jQuery(document).ready(function(){
  // Add root menu link
  jQuery('.button-menu-link').live('click',function(){
    var menu = jQuery('#menu-tree').children('ul');
    var new_menu_link = '<li class="file last closed">';
    new_menu_link += jQuery('#empty_menu_link').html().replace(/EMPTY_ID/g, false_id).replace(/EMPTY_NAME/g, false_id);
    new_menu_link += '</li>';

    jQuery(menu).append(new_menu_link);
    update_menu_positions(menu);

    false_id--;
    return false;
  });

  // Add sub menu link
  jQuery('.tree-menu-tree li .menu_link .action-links .add-green-plus').live('click',function(){
    var current_menu_link = jQuery(this).parents('li:first');
   
    // get list of the current menu_link or create one
    var menu_list = jQuery(current_menu_link).children('ul');
    if (menu_list.length == 0) {
      jQuery(current_menu_link).append(jQuery('<ul>'));
      menu_list = jQuery(current_menu_link).children('ul');
    }

    // get menu_link ancestors
    var ancestor_ids = [];
    jQuery(this).parents('li').each(function(){
        var attributes = jQuery(this).find('input:first').attr('name').split('[');
        var ancestor_id = attributes[attributes.length-2].replace(']','');
        ancestor_ids.push(ancestor_id);
    });

    // constructs new menu_link id/name depending on its ancestors
    var new_id = false_id;
    var new_name = false_id;
    if (ancestor_ids.length > 0){
      ancestor_ids = ancestor_ids.reverse();
      new_id = ancestor_ids.join('_children_attributes_') + '_children_attributes_' + false_id;
      new_name = ancestor_ids.join('][children_attributes][') + '][children_attributes][' + false_id;
    }

    // create new menu link and append it to the list of the current menu_link
    var new_menu_link = '<li class="file last closed">';
    new_menu_link += jQuery('#empty_menu_link').html().replace(/EMPTY_ID/g, new_id).replace(/EMPTY_NAME/g, new_name);
    new_menu_link += '</li>';
    jQuery(menu_list).append(new_menu_link);

    // update positions and open current menu_link
    update_menu_positions(jQuery('#menu-tree').children('ul'));
    toggle_menu_link(current_menu_link, 'open');

    false_id--;
    return false;
  });

  // Edition mode in menu link edit
  jQuery('.tree-menu-tree li .menu_link .action-links .edit-link, .tree-menu-tree li .menu_link .actions .back-link, .tree-menu-tree li .menu_link .editing .save').live('click',function(){
    var menu_link = jQuery(this).parents('li:first');
    var link = jQuery(menu_link).find('a.tree-link:first');
    var link_span = jQuery(link).find('.name');

    var edition_block = jQuery(menu_link).find('.editing:first');
    var edition_span = jQuery(edition_block).find('.linked-to-span');
    var edition_link = jQuery(edition_span).find('a');

    // toggle link and edition_block
    link.toggle();
    edition_block.toggle();

    // on closing edition part
    if (!jQuery(edition_block).is(':visible')){
      var back_link = jQuery(this).hasClass('back-link');

      // back-link is pressed then reset icon else update icon
      if (back_link)
        update_menu_span_icon(link_span, edition_span);
      else
        update_menu_span_icon(edition_span, link_span);

      // back-link is pressed then reset attributes else update attributes
      jQuery(edition_block).find('input, textarea, select').each(function(){
        switch(get_rails_element_id(jQuery(this)))
          {
          // TODO: interactivity
          case 'title':
            if (back_link){
              // reset title text field...
              jQuery(this).val(link_span.html());
              
              // and edition link title
              if (edition_span.hasClass('external'))
                // edition link url
                edition_link.html(link.attr('href'));
              else
                // target name
                edition_link.html(jQuery(edition_block).find('.linked-to').html());
            }
            else{
              // update view link title
              link_span.html(jQuery(this).val());
              jQuery(edition_block).find('.linked-to').html(edition_link.html());
            }
            break;

          case 'url':
            if (back_link){
              // reset url hidden field and edition link url
              jQuery(this).val(link.attr('href'));
              edition_link.attr('href', link.attr('href'));
            }
            else
              // update view link url
              link.attr('href', edition_link.attr('href'));
            break;

          case 'active':
            status_span = link.find('.status');
            if (back_link){
              // update select
              jQuery(this).val(status_span.hasClass('see-on') ? 1 : 0);
              rebuild_custom_select('.select-status');
            }
            else {
              // set visible or not
              status_span.removeClass((jQuery(this).val() == '1') ?  'see-off' : 'see-on');
              status_span.addClass((jQuery(this).val() == '1') ?  'see-on' : 'see-off');
            }
            break;  
          }
      });
    }
    return false;
  });

  // Remove menu link
  jQuery('.tree-menu-tree li .menu_link .action-links .destroy-link').live('click',function(){
    var menu_link = jQuery(this).parents('li:first');

    // set the menu link and all its children to deleted
    jQuery(menu_link).find('.menu_link').each(function(){
      jQuery(this).find('.delete').val(1);
    });

    // hide menu link and its children and update positions
    jQuery(menu_link).children().hide();   
    update_menu_positions(jQuery('#menu-tree').children('ul'));

    // close parent menu_link if there was only one sub menu_link
    var parent_menu_link = menu_link.parents('li:first');
    var sub_menu_links = parent_menu_link.find('li.open:visible, li.closed:visible');
    if (sub_menu_links.length == 0)
      toggle_menu_link(parent_menu_link, 'closed');

    return false;
  });

  // Dialog to change menu link type
  jQuery('#menuLinkTypeDialog').dialog({
    autoOpen:false,
    modal:true,
    minHeight: 380,
    width: 800,
    resizable:'se',
    buttons: {
      Ok: function(){
        jQuery('#fileSelectDialog').dialog('close');
      }
    },
    open: function(){ 
      jQuery('#table-files').dataTableInstance().fnDraw();
    }
  });

  // Change menu link type
  jQuery('.tree-menu-tree li .menu_link .editing .change-type').live('click',function(){
    var edition_block = jQuery(this).parents('.editing');
    var link_type = jQuery(edition_block).find('.input-type');

    var title = jQuery(edition_block).find('.input-title');
    var url = jQuery(edition_block).find('.input-url');
    var span = jQuery(edition_block).find('.linked-to-span');
    var link = jQuery(edition_block).find('.linked-to-span a');
    var target_id = jQuery(edition_block).find('.input-target-id');
    var target_type = jQuery(edition_block).find('.input-target-type');
    var overlay_url = jQuery('#overlay-url');
    
    // on open - show overlay and hide other overlays
    jQuery('#menuLinkTypeDialog').bind('dialogopen', function(event, ui) {
      var overlay_tab;
      var overlay_type = 'target-link';

      switch(link_type.val())
        {
        case 'PageLink':
          overlay_tab = 'page';
          update_current_dataTable_source('#table-files','/admin/pages.json?mode=menu_link');
          break;

        case 'ProductLink':
          overlay_tab = 'product';
          update_current_dataTable_source('#table-files','/admin/products.json?mode=menu_link');
          break;
          
        case 'CategoryLink':
          overlay_tab = 'category';
          update_current_dataTable_source('#table-files',"/admin/categories.json?mode=menu_link&types[]=page&types[]=product");
          break;

        default:
          overlay_tab = 'external';
          overlay_type = 'external-link';
          // set overlay input value
          overlay_url.val(url.val());
        }

      toggleSelectedOverlay('#inner-lightbox.backgrounds .' + overlay_tab);
      toggle_menu_types_overlays(overlay_type);
    });

    // on OK button pressed - update link, hidden fields and close dialog
    jQuery('#menuLinkTypeDialog').dialog('option', 'buttons', {
      "Ok": function(){
        var current_tab = jQuery('#inner-lightbox.backgrounds .selected');

        span.removeClass('external page product category');

        if (current_tab.hasClass('external')){
          update_menu_link(title, span, link, url, link_type, target_id, target_type, {
            'title': title.val(),
            'type': 'external',
            'link_name': overlay_url.val(),
            'link_url': overlay_url.val(),
            'hidden_url': overlay_url.val(),
            'hidden_type': 'ExternalLink',
            'hidden_target_id': '',
            'hidden_target_type': ''       
            }
          ); 
        }
        else{
          dataTableSelectRows('#table-files:visible',function(current_table,indexes){
            var row = current_table.fnGetData(indexes[0]);
            var id = row.slice(-2,-1)[0];
            var name = row.slice(-3,-2)[0];
            var target = row.slice(-1)[0];

            var type;
            if (current_tab.hasClass('page'))
              type = 'page';
            else if (current_tab.hasClass('product'))
              type = 'product';
            else if (current_tab.hasClass('category'))
              type = 'category';

            update_menu_link(title, span, link, url, link_type, target_id, target_type, {
              'title': jQuery(name).html(),
              'type': type,
              'link_name': jQuery(name).html(),
              'link_url': jQuery(target).attr('href'),
              'hidden_url': '',
              'hidden_type': capitalize(type)+'Link',
              'hidden_target_id': id,
              'hidden_target_type': capitalize(type)
              }
            );
          });
        }

        jQuery(this).dialog("close"); 
      }
    });

    // on close - reset overlay url input text field
    jQuery('#menuLinkTypeDialog').bind('dialogbeforeclose', function(event, ui) {
      overlay_url.val('');
    });

    jQuery('#menuLinkTypeDialog').dialog('open');
    return false;
  });

  //add hover on menu list elments
  jQuery('.tree-menu-tree').find('li').live('mouseover',function(){
    jQuery('.action-links').hide();
    jQuery(this).find('.action-links:first').show();

  });

   jQuery('.tree-menu-tree').find('li').live('mouseout',function(){
     jQuery('.action-links').hide();
  });
});
