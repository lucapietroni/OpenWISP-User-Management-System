$(document).ready(function() {
  
  $("#div_update th a, #div_update .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  
  $("#div_update_search input").keyup(function() {
    $.get($("#div_update_search").attr("action"), $("#div_update_search").serialize(), null, "script");
    return false;
  });  
  
  $("input:text").eq(0).focus();
  
  $("#user_is_company").click(function(){
    $("#company_fields").slideToggle("slow");
    $("#pg_userlabel").html()=="Dati utente"?$("#pg_userlabel").html("Dati legale rappresentante"):$("#pg_userlabel").html("Dati utente");
  });
  
  $("#user_iban_verify").click(function () {
    $("#mydiv").show(); 
    $("#frame").attr("src", "http://www.mutuissimo.it/cerca.asp?q=a&iban="+$("#user_iban").val());
  });  
  //$("#frame").attr("src", "http://www.mutuissimo.it/cerca.asp?q=a&iban="+$("#user_iban").val());
  
  $('#user_eula_acceptance').click(function() {
    var url = $("#acceptance").attr('href');
    window.open(url, '_blank');
  });
  
  $('#user_privacy_acceptance').click(function() {
    var url = $("#privacy").attr('href');
    window.open(url, '_blank');
  });  
});  
