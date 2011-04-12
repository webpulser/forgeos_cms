// initialize tree for page associations
function init_association_page_tree(selector, object_name){
  init_association_category_tree(selector, object_name, 'page_col', 'association_page');
}
// initialize block category associations
function init_association_block_category_tree(selector, object_name){
  init_association_category_tree(selector, object_name, 'block_category', 'association_categories');
}
