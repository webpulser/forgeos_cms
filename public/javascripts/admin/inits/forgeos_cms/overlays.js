jQuery(document).ready(function(){
  /*
  *Add click function on a.page-link  items
  *Those items are links that shows dialogBox to add a page to blocks
  **/
  $('a.page-link').live('click',function(){
    openPageDialog($(this));
    return false;
  });

  /*
  *Add click function on .small-icons.page items
  *Those items are li in page tree (in dialog box)
  * sends ajax request to link a page with a block
  * add the new linked page in pages list
  *and close the dialogg box
  **/
  $('.link-page.small-icons.page').bind('click',function(){
    if(!$(this).hasClass('active')){
      var url = $(this).attr('href');
      var block_id = url.split('/')[5];
      var page_id = $(this).parent().attr('id').substr(5);
      $.ajax({
          url: url,
            complete: putInPageList($(this).text(), $(this).attr('title'), block_id, page_id),
            data: 'authenticity_token=' + encodeURIComponent(AUTH_TOKEN),
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
  $('.static-tab,.widget-tab').bind('click',function(){
    toggleHoverlayTrees($(this).attr('class'));
    return false;
  });

 $('.lightbox-actuality').dialog({
       autoOpen:false,
       modal:true,
       minHeight: 400,
       width: 950,
//       open: function(){ tmce_load_children('#'+$(this).attr('id'));},
//       beforeClose: function(){tmce_unload_children('#'+$(this).attr('id'));},
       resizable: 'se'
    });
    
  $('.add-actuality').live('click',function(){
    empty_actuality_overlay_fields();
    $('.lightbox-actuality').dialog('open');
    
    $('#submit_actuality').addClass('create-actuality');
    $('#submit_actuality').removeClass('update-actuality');
    return false;
  });

  $('.edit-actuality').live('click',function(){
    $('.lightbox-actuality').dialog('open');
    $('#submit_actuality').removeClass('create-actuality');
    $('#submit_actuality').addClass('update-actuality');
    return false;
  });
});
