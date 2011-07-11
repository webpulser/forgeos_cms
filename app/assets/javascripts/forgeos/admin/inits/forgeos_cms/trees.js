jQuery(document).ready(function(){
  // init the category tress
  init_category_tree("#page-tree",'PageCategory','/admin/page_categories.json');
  init_category_tree("#block-tree",'StaticContentCategory','/admin/static_content_categories.json');
  init_category_tree("#widget-tree",'WidgetCategory','/admin/widget_categories.json');

  // init the tress for category associations
  init_association_block_category_tree('#association-static-content-tree', 'static_content_block');
  init_association_block_category_tree('#association-carousel-tree', 'carousel');
  init_association_block_category_tree('#association-widget-actuality-tree', 'widget_actuality');
  init_association_block_category_tree('#association-widget-faq-tree', 'widget_faq');

  // init the trees for page associations
  init_association_page_tree('#association-static-content-page-tree', 'static_content_block');
  init_association_page_tree('#association-carousel-page-tree', 'carousel');
  init_association_page_tree('#association-widget-actuality-page-tree', 'widget_actuality');
  init_association_page_tree('#association-widget-faq-page-tree', 'widget_faq');

  //init the tree of blocks
  jQuery('.blocks-tree').bind('select_node.jstree', function(e, data){
    var jnode = jQuery(data.rslt.obj);
    var link = jnode.find('a:first');
    if(!link.hasClass('active')){
      putInBlockList(link.attr('title'), link.text(), jnode.attr('id').substr(6));
      closeDialogBox();
      jQuery('.selectedPageCol').removeClass('selectedPageCol');
    }
    return false;
  }).jstree({
    "themes": {
      "theme": 'block_category'
    },
    "ui": {
      selected_parent_close: false
    },
    "plugins": ['html_data', 'ui', 'themes']
  });

  //init the tree of pages
  jQuery(".pages-tree").bind('select_node.jstree', function(e, data){
    var jnode = jQuery(data.rslt.obj);
    var link = jnode.children('a');
    if(!link.hasClass('active')){
      var url = link.attr('href');
      var block_id = url.split('/')[5];
      var page_id = get_rails_element_id(jnode);
      jQuery.ajax({
        "url": url,
        "complete": putInPageList(link.text(), link.attr('title'), block_id, page_id),
        "data": { authenticity_token: encodeURIComponent(window._forgeos_js_vars.token) },
        "dataType":'text',
        "type":'post'
      });
      closeDialogBox();
    }
    return false;
  }).jstree({
    "themes": {
      "theme": 'page_category'
    },
    "ui": {
      selected_parent_close: false
    },
    "plugins": ['html_data', 'ui', 'themes']
  });
});
