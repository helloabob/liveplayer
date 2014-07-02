$(document).ready(function(){
		$('.pic').pngFix();
		$(".pic").find('span').hide();
		$(".pic").mouseover(function(){ 
			$(this).find('span').show();
			}).mouseout(function(){
			$(this).find('span').hide();
			});
		
	}
);


