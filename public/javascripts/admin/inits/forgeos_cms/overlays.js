jQuery(document).ready(function(){
  /*
  *Add click function on a.page-link  items
  *Those items are links that shows dialogBox to add a page to blocks
  **/
  jQuery('a.page-link').live('click',function(){
    openPageDialog(jQuery(this));
    return false;
  });

  /*
  *Add click function on .small-icons.page items
  *Those items are li in page tree (in dialog box)
  * sends ajax request to link a page with a block
  * add the new linked page in pages list
  *and close the dialogg box
  **/
  jQuery('.link-page.small-icons.page').bind('click',function(){
    if(!jQuery(this).hasClass('active')){
      var url = jQuery(this).attr('href');
      var block_id = url.split('/')[5];
      var page_id = jQuery(this).parent().attr('id').substr(5);
      jQuery.ajax({
          url: url,
            complete: putInPageList(jQuery(this).text(), jQuery(this).attr('title'), block_id, page_id),
            data: 'authenticity_token=' + encodeURIComponent(window._forgeos_js_vars.token),
            dataType:'script',
            type:'post'
            });
      closeDialogBox();
    }
    return false;
  });

  /*
  *Add click function on .static-tab,.widget-tab items
  *Those items are headers links in blocks/widget dialog box
  *that display the widgets or blocks trees
  **/
  jQuery('.static-tab,.widget-tab').bind('click',function(){
    toggleHoverlayTrees(jQuery(this).attr('class'));
    return false;
  });

 jQuery('.lightbox-actuality').dialog({
       autoOpen:false,
       modal:true,
       minHeight: 400,
       width: 950,
       open: function(){ tmce_load_children('#form_actuality'); },
       beforeclose: function(){ tmce_unload_children('#form_actuality'); },
       resizable: 'se'
  });
    
  jQuery('.add-actuality').live('click',function(){
    empty_actuality_overlay_fields();
    tmce_unload_children('#form_actuality');
    jQuery('.lightbox-actuality').dialog('open');
    jQuery('#submit_actuality').addClass('create-actuality');
    jQuery('#submit_actuality').removeClass('update-actuality');
    return false;
  });

  jQuery('.edit-actuality').live('click',function(){
    tmce_unload_children('#form_actuality');
    jQuery('.lightbox-actuality').dialog('open');
    jQuery('#submit_actuality').removeClass('create-actuality');
    jQuery('#submit_actuality').addClass('update-actuality');
    return false;
  });
});
