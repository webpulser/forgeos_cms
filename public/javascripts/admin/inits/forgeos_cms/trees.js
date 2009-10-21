jQuery(document).ready(function(){
  //init the tree for pages, blocks, widgets
  $("#page-tree").tree({
    ui: { 
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'product_category',
      selected_parent_close: false
    },
    callback: {
      onload: function(TREE_OBJ){
        tree_id = $(TREE_OBJ.container).attr('id');
        $(TREE_OBJ.container).removeClass('tree-default');
      }
    }
  });

  init_category_tree("#page-tree",'PageCategory','/admin/page_categories.json');
  init_category_tree("#block-tree",'StaticContentCategory','/admin/static_content_categories.json');
  init_category_tree("#widget-tree",'WidgetCategory','/admin/widget_categories.json');

  //init the tree of blocks
  $('.blocks-tree').tree({
    ui: { 
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'block_category',
      selected_parent_close: false
    },
    callback: {
      onload: function(TREE_OBJ){
        tree_id = $(TREE_OBJ.container).attr('id');
        $(TREE_OBJ.container).removeClass('tree-default');
      },
      onselect: function(NODE,TREE_OBJ){
        /*
        *Add click function on .small-icons.block items
        *Those items are li in blocks/widget tree (in dialog box)
        *and close the dialogg box
        **/
        var link = $(NODE).find('a:first');
        if(!link.hasClass('active')){
          putInBlockList(link.attr('title'), link.text(), $(NODE).attr('id').substr(6));
          closeDialogBox();
        }
        return false;
      }
    }
  });

  // TODO: refactor
  //init the tree of pages
  $(".pages-tree").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'page_category',
      selected_parent_close: false
    },
    callback: {
      onload: function(TREE_OBJ){
        tree_id = $(TREE_OBJ.container).attr('id');
        $(TREE_OBJ.container).removeClass('tree-default');
      },
      onselect: function(NODE,TREE_OBJ){
        if(!$(NODE).hasClass('active')){
          var link = $(NODE).children('a');
          var url = $(link).attr('href');
          var block_id = url.split('/')[5];
          var page_id = get_rails_element_id(NODE);
          $.ajax({
              url: url,
                complete: putInPageList($(link).text(), $(link).attr('title'), block_id, page_id),
                data: 'authenticity_token=' + encodeURIComponent(AUTH_TOKEN),
                dataType:'text',
                type:'post'
                });
          closeDialogBox();
        }
        return false;
        }
      }
  });

  $("#association-static-content-tree").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'association_product',
      selected_parent_close: false
    },
    rules: { multiple:'on' },
    callback: {
      onload: function(TREE_OBJ){
        tree_id = $(TREE_OBJ.container).attr('id');
        $(TREE_OBJ.container).removeClass('tree-default');
      },
      onrgtclk: function(NODE,TREE_OBJ,EV){
        EV.preventDefault(); EV.stopPropagation(); return false
      },
      onselect: function(NODE,TREE_OBJ){
        object_name = 'static_content_block';
        category_id = get_rails_element_id(NODE);
        $(NODE).append('<input type="hidden" id="'+object_name+'_block_category_'+category_id+'" name="'+object_name+'[block_category_ids][]" value="'+category_id+'" />');
        $(NODE).addClass('clicked');
      },
      ondeselect: function(NODE,TREE_OBJ){
        object_name = $(NODE).attr('id').split('_')[0];
        category_id = get_rails_element_id(NODE);
        $(NODE).children('input').remove();
        $(NODE).removeClass('clicked');
      }
    }
  });

  $("#association-carousel-tree").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'association_product',
      selected_parent_close: false
    },
    rules: { multiple:'on' },
    callback: {
      onload: function(TREE_OBJ){
       tree_id = $(TREE_OBJ.container).attr('id');
        $(TREE_OBJ.container).removeClass('tree-default');
      },
      onrgtclk: function(NODE,TREE_OBJ,EV){
        EV.preventDefault(); EV.stopPropagation(); return false
      },
      onselect: function(NODE,TREE_OBJ){
        object_name = 'carousel';
        category_id = get_rails_element_id(NODE);
        $(NODE).append('<input type="hidden" id="'+object_name+'_block_category_'+category_id+'" name="'+object_name+'[block_category_ids][]" value="'+category_id+'" />');
        $(NODE).addClass('clicked');
      },
      ondeselect: function(NODE,TREE_OBJ){
        object_name = $(NODE).attr('id').split('_')[0];
        category_id = get_rails_element_id(NODE);
        $(NODE).children('input').remove();
        $(NODE).removeClass('clicked');
      }
    }
  });


  $("#association-widget-actuality-tree").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'association_product',
      selected_parent_close: false
    },
    rules: { multiple:'on' },
    callback: {
      onload: function(TREE_OBJ){
       tree_id = $(TREE_OBJ.container).attr('id');
        $(TREE_OBJ.container).removeClass('tree-default');
      },
      onrgtclk: function(NODE,TREE_OBJ,EV){
        EV.preventDefault(); EV.stopPropagation(); return false
      },
      onselect: function(NODE,TREE_OBJ){
        object_name = 'widget_actuality';
        category_id = get_rails_element_id(NODE);
        $(NODE).append('<input type="hidden" id="'+object_name+'_block_category_'+category_id+'" name="'+object_name+'[block_category_ids][]" value="'+category_id+'" />');
        $(NODE).addClass('clicked');
      },
      ondeselect: function(NODE,TREE_OBJ){
        object_name = $(NODE).attr('id').split('_')[0];
        category_id = get_rails_element_id(NODE);
        $(NODE).children('input').remove();
        $(NODE).removeClass('clicked');
      }
    }
  });


  // TODO: refactor
  //init the trees for page associations with static contents, carousels and actualities
  $("#association-static-content-page-tree").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'association_page',
      selected_parent_close: false
    },
    rules: {multiple:'on'},
    callback: {
      onload: function(TREE_OBJ){
        tree_id = $(TREE_OBJ.container).attr('id');
        $(TREE_OBJ.container).removeClass('tree-default');
      },
      onrgtclk: function(NODE,TREE_OBJ,EV){
        EV.preventDefault(); EV.stopPropagation(); return false
      },
      onselect: function(NODE,TREE_OBJ){
        object_name = 'static_content_block';
        category_id = get_rails_element_id(NODE);
        $(NODE).append('<input type="hidden" id="'+object_name+'_page_ids_'+category_id+'" name="'+object_name+'[page_ids][]" value="'+category_id+'" />');
        $(NODE).addClass('clicked');
      },
      ondeselect: function(NODE,TREE_OBJ){
        category_id = get_rails_element_id(NODE);
        $(NODE).children('input').remove();
        $(NODE).removeClass('clicked');
      }
    }
  });

  $("#association-carousel-page-tree").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'association_page',
      selected_parent_close: false
    },
    rules: { multiple:'on'},
    callback: {
      onload: function(TREE_OBJ){
        tree_id = $(TREE_OBJ.container).attr('id');
        $(TREE_OBJ.container).removeClass('tree-default');
      },
      onrgtclk: function(NODE,TREE_OBJ,EV){
        EV.preventDefault(); EV.stopPropagation(); return false
      },
      onselect: function(NODE,TREE_OBJ){
        object_name = 'carousel';
        category_id = get_rails_element_id(NODE);
        $(NODE).append('<input type="hidden" id="'+object_name+'_page_ids_'+category_id+'" name="'+object_name+'[page_ids][]" value="'+category_id+'" />');
        $(NODE).addClass('clicked');
      },
      ondeselect: function(NODE,TREE_OBJ){
        category_id = get_rails_element_id(NODE);
        $(NODE).children('input').remove();
        $(NODE).removeClass('clicked');
      }
    }
  });

  $("#association-widget-actuality-page-tree").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'association_page',
      selected_parent_close: false
    },
    rules: { multiple:'on'},
    callback: {
      onload: function(TREE_OBJ){
        tree_id = $(TREE_OBJ.container).attr('id');
        $(TREE_OBJ.container).removeClass('tree-default');
      },
      onrgtclk: function(NODE,TREE_OBJ,EV){
        EV.preventDefault(); EV.stopPropagation(); return false
      },
      onselect: function(NODE,TREE_OBJ){
        object_name = 'widget_actuality';
        category_id = get_rails_element_id(NODE);
        $(NODE).append('<input type="hidden" id="'+object_name+'_page_ids_'+category_id+'" name="'+object_name+'[page_ids][]" value="'+category_id+'" />');
        $(NODE).addClass('clicked');
      },
      ondeselect: function(NODE,TREE_OBJ){
        category_id = get_rails_element_id(NODE);
        $(NODE).children('input').remove();
        $(NODE).removeClass('clicked');
      }
    }
  });
});
