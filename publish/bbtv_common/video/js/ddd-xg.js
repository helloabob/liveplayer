$(document).ready(function(){
		$("ul.filter-list li").mouseover(function(){ 
					$(this).addClass("highlight");
					}).mouseout(function(){
					$(this).removeClass("highlight"); 
					}); 
	}
);
