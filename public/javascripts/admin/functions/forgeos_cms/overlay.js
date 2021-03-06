//open widget/blocks tree's dialog box
function openBlockDialog(element, container){
  removeClasses();
  addBlockClasses();
  if(container != null){
    container.addClass('selectedPageCol');
  }
  jQuery('.lightbox-container').dialog('open');
  if(element.hasClass('static-content')){
    toggleHoverlayTrees('static-tab');
  }
  else if(element.hasClass('widget-content')){
    toggleHoverlayTrees('widget-tab')
  }
  return false;
}

//open pages tree's dialog box
function openPageDialog(element){
  var block_id = get_rails_element_id(element);
  // changes all href to page block link url
  jQuery('.lightbox-container .small-icons.page').each(function(){
      var page_id = get_rails_element_id(this);
      jQuery(this).attr('href', '/admin/pages/' + page_id + '/blocks/' + block_id + '/link');
  });

  removeClasses();
  addPageClasses(block_id);
  jQuery('.lightbox-container').dialog('open');
  return false;
}

//Switch widget/blocks tree in dialog box
function toggleHoverlayTrees(elementname){
  if(!jQuery('.'+elementname).hasClass('selected')){
    jQuery('.'+elementname).addClass('selected');
    jQuery('.'+elementname).siblings().removeClass('selected');
    jQuery('#widgets, #blocks').toggleClass('hidden');
  }
}

//the selected block/widget in dialog box, is put in block/widget list
function putInBlockList(type, name, id){
  var content = '';
  if(jQuery('.selectedPageCol').length > 0){
    firstInput = jQuery('.selectedPageCol input')[0];
    content = '\
      <div class="block-container">\n\
        <span class="block-type">\n\
          <span class="handler">\n\
            <span class="inner">&nbsp;</span>\n\
          </span>'+type+'</span>\n\
        <span class="block-name">'+name+'\n\
        </span>\n\
        <a href="/admin/blocks/'+id+'/edit" onclick="window.open(this.href); return false;" class="small-icons edit-link">\n\
        <a href="#" class="big-icons gray-destroy"/>\n\
        <input id="page_block_ids_" type="hidden" value="'+id+'" class="block-selected" name="'+jQuery(firstInput).attr('name')+'"/>\n\
      </div>';
   jQuery('.selectedPageCol .nested_sortable').append(content);
  }
  else{
    content = '\
      <div class="block-container">\n\
        <span class="block-type">\n\
          <span class="handler">\n\
            <span class="inner">&nbsp;</span>\n\
          </span>'+type+'</span>\n\
        <span class="block-name">'+name+'\n\
        </span>\n\
        <a href="/admin/blocks/'+id+'/edit" onclick="window.open(this.href); return false;" class="small-icons edit-link">\n\
        <a href="#" class="big-icons gray-destroy"/>\n\
        <input id="page_block_ids_" type="hidden" value="'+id+'" class="block-selected" name="page[page_cols_attributes][0][block_ids][]"/>\n\
      </div>';
   jQuery('.fieldset .nested_sortable').append(content);
  }
}

//the selected page in dialog box, is put in page list
function putInPageList(name, confirm_msg, block_id, id){
  jQuery('#links_block_' + block_id).append('\
     <span id="block_' + block_id + '_page_' + id + '" class="block-selected">\n\
       <a class="big-icons big-icons-verti-delete-icon" href="#" onclick="if (confirm(\'' + confirm_msg + '\')) { jQuery.ajax({data:\'_method=delete\' + \'&authenticity_token=\' + encodeURIComponent(window._forgeos_js_vars.token), dataType:\'script\', success:function(request){jQuery(\'#block_' + block_id + '_page_' + id + '\').remove()}, type:\'post\', url:\'/admin/pages/' + id + '/blocks/' + block_id + '/unlink\'}); }; return false;"/>\n\
       <a href="/admin/pages/' + id + '">' + name + '</a>\n\
       <br/>\n\
     </span>');
}
