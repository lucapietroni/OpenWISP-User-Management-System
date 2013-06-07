$(document).ready(function() {
  
  $("#div_update th a, #div_update .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  
  $("#div_update_search input").keyup(function() {
    $.get($("#div_update_search").attr("action"), $("#div_update_search").serialize(), null, "script");
    return false;
  });  
  
  $("a[rel^='prettyPhoto']").prettyPhoto({keyboard_shortcuts: false, animation_speed:'normal',theme:'light_square',slideshow:3000, autoplay_slideshow: false, social_tools:false, default_width: 650, default_height: 444, show_title: false, deeplinking: false});  
  
  $('#locale').change(function() {
    $('#locale_id').submit();
  });
  
  $("input:text").eq(0).focus();
  
  $('#flash_msg_notice').delay(2000).animate({height: '0px', opacity: 0}); 
  
  $('#flash_msg_error').delay(2000).animate({height: '0px', opacity: 0});
  
});  

$(document).keyup(function(e) {
  if (e.keyCode == 27) { $.prettyPhoto.close(); return false;}   // esc
});

function callAjaxRequest(snCityId, ssUrl, ssUpdateDivId)
{
	jQuery.ajax({
		type:'GET',
		dataType:'html',
		data:{id: snCityId},
		url:ssUrl,
		success:function(result){
		    $("#div_update_area").html(result);
		}
	})
}