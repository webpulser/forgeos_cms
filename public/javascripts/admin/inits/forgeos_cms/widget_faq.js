jQuery(document).ready(function(){

  $('.add-faq-item').live('click',function(){
	$('.faq_ul').append("<li>"+$('#faq_item_pattern').html()+"</li>");
	return false;
  });	

});