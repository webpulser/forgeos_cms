jQuery(document).ready(function(){
  $('.add-faq-item').live('click',function(e){
    e.preventDefault();
    var list = $('.faq_ul');
    var new_id = list.find('li').size() + 1;
    list.append('<li id="faq_'+new_id+'">'+$('#faq_item_pattern').html().replace(new RegExp('EMPTY_ID','g'),new_id)+'</li>');
    var item = list.find('li:last');
    item.find('textarea').addClass('mceEditor');
    tmce_load_children('#'+item.attr('id'));
    return false;
  });
});
