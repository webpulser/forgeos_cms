//open widget/blocks tree's dialog box
function openBlockDialog(element){
  removeClasses();
  addBlockClasses();
  $('.lightbox-container').dialog('open');
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
  $('.lightbox-container .small-icons.page').each(function(){
      var page_id = get_rails_element_id(this);
      $(this).attr('href', '/admin/pages/' + page_id + '/blocks/' + block_id + '/link');
  });

  removeClasses();
  addPageClasses(block_id);
  $('.lightbox-container').dialog('open');
  return false;
}

//Switch widget/blocks tree in dialog box
function toggleHoverlayTrees(elementname){
  if(!$('.'+elementname).hasClass('selected')){
    $('.'+elementname).addClass('selected');
    $('.'+elementname).siblings().removeClass('selected');
    $('#widgets, #blocks').toggleClass('hidden');
  }
}

//the selected block/widget in dialog box, is put in block/widget list
function putInBlockList(type, name, id){
   $('.fieldset .sortable').append('\
      <div class="block-container">\n\
        <span class="block-type">\n\
          <span class="handler">\n\
            <span class="inner">&nbsp;</span>\n\
          </span>'+type+'</span>\n\
        <span class="block-name">'+name+'\n\
        </span>\n\
        <a href="#" class="big-icons gray-destroy"/>\n\
        <input id="page_block_ids_" type="hidden" value="'+id+'" class="block-selected" name="page[block_ids][]"/>\n\
      </div>');
}

//the selected page in dialog box, is put in page list
function putInPageList(name, confirm_msg, block_id, id){
  $('#links_block_' + block_id).append('\
     <span id="block_' + block_id + '_page_' + id + '" class="block-selected">\n\
       <a class="big-icons big-icons-verti-delete-icon" href="#" onclick="if (confirm(\'' + confirm_msg + '\')) { $.ajax({data:\'_method=delete\' + \'&authenticity_token=\' + encodeURIComponent(AUTH_TOKEN), dataType:\'script\', success:function(request){$(\'#block_' + block_id + '_page_' + id + '\').remove()}, type:\'post\', url:\'/admin/pages/' + id + '/blocks/' + block_id + '/unlink\'}); }; return false;"/>\n\
       <a href="/admin/pages/' + id + '">' + name + '</a>\n\
       <br/>\n\
     </span>');
}
