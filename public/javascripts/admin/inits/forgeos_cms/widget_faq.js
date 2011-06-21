jQuery(document).ready(function(){
  jQuery('.add-faq-item').live('click',function(e){
    e.preventDefault();
    var list = jQuery('.faq_ul');
    var new_id = list.find('li').size() + 1;
    list.append('<li id="faq_'+new_id+'">'+jQuery('#faq_item_pattern').html().replace(new RegExp('EMPTY_ID','g'),new_id)+'</li>');
    var item = list.find('li:last');
    item.find('textarea').addClass('mceEditor');
    tmce_load_children('#'+item.attr('id'));
    jQuery('html,body').animate({scrollTop: jQuery('#faq_'+new_id).offset().top},'slow');
    return false;
  });
});
