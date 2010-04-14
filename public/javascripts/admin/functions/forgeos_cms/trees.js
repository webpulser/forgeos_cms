// initialize tree for category associations
function init_association_category_tree(selector, object_name){
  $(selector).tree({
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
}

// initialize tree for page associations
function init_association_page_tree(selector, object_name){
  $(selector).tree({
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
        category_id = get_rails_element_id(NODE);
        $(NODE).append('<input type="hidden" id="'+object_name+'_page_col_ids_'+category_id+'" name="'+object_name+'[page_col_ids][]" value="'+category_id+'" />');
        $(NODE).addClass('clicked');
      },
      ondeselect: function(NODE,TREE_OBJ){
        category_id = get_rails_element_id(NODE);
        $(NODE).children('input').remove();
        $(NODE).removeClass('clicked');
      }
    }
  });
}
