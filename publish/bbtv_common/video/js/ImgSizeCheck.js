// JavaScript Document
////////////////////////////////////////////////////////////////
///////////////////code by Nicho-Yao 090512/////////////////////
////////////////////////////////////////////////////////////////

//the class for img size check and align middle
//ImgObj:{autoWidth,autoHeight}
var ImgSizeCheck = function(_imgBoxId,_imgObj){
	$('#' + _imgBoxId).find('img').css('display','none');
	var imgObj = {autoWidth:100,autoHeight:100};
	if(_imgObj.autoWidth) imgObj.autoWidth = _imgObj.autoWidth;
	if(_imgObj.autoHeight) imgObj.autoHeight = _imgObj.autoHeight;
	
	var imgArr = $.makeArray($('#' + _imgBoxId).find('img'));
	if($.browser.msie){
		var checkNumArr = new Array();
	}
	
	var checkLoadHandlerForIe = function(img,_checkNum){
		if(img.complete == true){
			checkSize(img);
			$(img).css('display','');
			$(img).css('marginTop',$(img).data('top') + 'px');
		}else{
			clearInterval(_checkNum);
			_checkNum = setTimeout(function(){checkLoadHandlerForIe(img,_checkNum);},30);
		}
	}
	
	var checkLoadHandler = function(img){
		if(img.complete == true){
			checkSize(img);
			$(img).css('display','');
			$(img).css('marginTop',$(img).data('top') + 'px');
		}
		else{
			img.onload = function(){
				checkSize(img);
				$(img).css('display','');
				$(img).css('marginTop',$(img).data('top') + 'px');
			}
		}
	}
	
	var checkSize = function(img){
		var pen;
		if(($(img).width() / $(img).height()) > (imgObj.autoWidth / imgObj.autoHeight)){
			if($(img).width() > imgObj.autoWidth){
				pen = $(img).width() / $(img).height();
				$(img).width(imgObj.autoWidth);
				$(img).height(imgObj.autoWidth / pen);
			}
		}else{
			if($(img).height() > imgObj.autoHeight){
				pen = $(img).height() / $(img).width();
				$(img).height(imgObj.autoHeight);
				$(img).width(imgObj.autoWidth / pen);
			}
		}
		$(img).data('top',(imgObj.autoHeight - $(img).height()) / 2);
	}
	for(var a = 0; a < imgArr.length; a ++){
		if($.browser.msie){
			checkLoadHandlerForIe(imgArr[a],checkNumArr[a]);
		}else{
			checkLoadHandler(imgArr[a]);
		}
	}
	
	this.checkAga = function(){
		for(var a = 0; a < imgArr.length; a ++){
			if($.browser.msie){
				checkLoadHandlerForIe(imgArr[a],checkNumArr[a]);
			}else{
				checkLoadHandler(imgArr[a]);
				
			}
		}
	}
}



















