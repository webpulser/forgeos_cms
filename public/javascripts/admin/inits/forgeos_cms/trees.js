jQuery(document).ready(function(){
  //init the tree for pages, blocks, widgets
  jQuery("#page-tree").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'product_category',
      selected_parent_close: false
    },
    callback: {
      onload: function(TREE_OBJ){
        tree_id = jQuery(TREE_OBJ.container).attr('id');
        jQuery(TREE_OBJ.container).removeClass('tree-default');
      }
    }
  });

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
  jQuery('.blocks-tree').tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'block_category',
      selected_parent_close: false
    },
    callback: {
      onload: function(TREE_OBJ){
        tree_id = jQuery(TREE_OBJ.container).attr('id');
        jQuery(TREE_OBJ.container).removeClass('tree-default');
      },
      onselect: function(NODE,TREE_OBJ){
        /*
        *Add click function on .small-icons.block items
        *Those items are li in blocks/widget tree (in dialog box)
        *and close the dialogg box
        **/
        var link = jQuery(NODE).find('a:first');
        if(!link.hasClass('active')){
          putInBlockList(link.attr('title'), link.text(), jQuery(NODE).attr('id').substr(6));
          closeDialogBox();
          jQuery('.selectedPageCol').removeClass('selectedPageCol');
        }
        return false;
      }
    }
  });

  //init the tree of pages
  jQuery(".pages-tree").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'page_category',
      selected_parent_close: false
    },
    callback: {
      onload: function(TREE_OBJ){
        tree_id = jQuery(TREE_OBJ.container).attr('id');
        jQuery(TREE_OBJ.container).removeClass('tree-default');
      },
      onselect: function(NODE,TREE_OBJ){
        var link = jQuery(NODE).children('a');
        if(!link.hasClass('active')){
          var url = jQuery(link).attr('href');
          var block_id = url.split('/')[5];
          var page_id = get_rails_element_id(NODE);
          jQuery.ajax({
              url: url,
                complete: putInPageList(jQuery(link).text(), jQuery(link).attr('title'), block_id, page_id),
                data: 'authenticity_token=' + encodeURIComponent(window._forgeos_js_vars.token),
                dataType:'text',
                type:'post'
                });
          closeDialogBox();
        }
        return false;
        }
      }
  });
});
