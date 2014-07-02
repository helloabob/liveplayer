var NewsCross = function(boxId,pageTotal){
	var box = $('#' + boxId);
	var leftBtn = box.find('input#news_left_btn').eq(0);
	var rightBtn = box.find('input#news_right_btn').eq(0);
	var hiddenBox = box.find('div.hiddenBox');
	var crossBox = box.find('ul').eq(0);
	var crossWeight = box.find('li').eq(0).outerWidth() * pageTotal;
	var moveBool = new Boolean(false);
	var moveNum = 0;
	var paveWeight = 0;
	var allWeight = box.find('li').eq(0).outerWidth() * box.find('li').length;
	var step = 30;
	
	var times = 30;
	var inter = 5000;
	var autoNum = 0;
	
	/*$('#' + boxId).find('li').each(function(){
		var str = $(this).find('p').eq(0).text();
		str = str.replace(/(^\s+)|(\s+$)/g,"");   
		//alert(str.length);
		if(str.length > 30){
			str = str.substr(0,30) + '……';
			$(this).find('p').eq(0).text(str);
		}
	});*/

	
	var html = crossBox.html();
	if(crossBox.find('li').length % 2 != 0) crossBox.append(html);
	crossBox.append(html);
	for(var a = 0; a < pageTotal * 2; a ++){
		if(crossBox.find('li').length < pageTotal * 2){
			crossBox.append(html);
		}else{
			break;
		}
	}
	var _num = crossBox.find('li').length / 2;
	if(_num % 2 != 0) paveWeight = crossBox.find('li').eq(0).outerWidth() * (Math.floor((crossBox.find('li').length - pageTotal) / 2) - 1);
	else paveWeight = crossBox.find('li').eq(0).outerWidth() * (Math.floor(crossBox.find('li').length / 2));
	
	hiddenBox.scrollLeft(0);
	
	var toLeft = 0;
	
	var crossLeftHandler = function(){
		if(moveBool == true) return;
		moveBool = true;
		var scrollLeft = hiddenBox.scrollLeft();
		if(scrollLeft - crossWeight < 0){
			scrollLeft += allWeight;
			hiddenBox.scrollLeft(scrollLeft);
		}
		toLeft = scrollLeft - crossWeight;
		moveNum = setInterval(crossFun,times);
	}
	var crossRightHandler = function(){
		if(moveBool == true) return;
		moveBool = true;
		var scrollLeft = hiddenBox.scrollLeft();
		if(scrollLeft + crossWeight > paveWeight){
			scrollLeft -= allWeight;
			hiddenBox.scrollLeft(scrollLeft);
		}
		toLeft = scrollLeft + crossWeight;
		moveNum = setInterval(crossFun,times);
	}
	
	var crossFun = function(){
		var scrollLeft = hiddenBox.scrollLeft();
		if(Math.abs(toLeft - scrollLeft) > step){
			scrollLeft += Math.abs(toLeft - scrollLeft) / (toLeft - scrollLeft) * step;
			hiddenBox.scrollLeft(scrollLeft);
		}else{
			hiddenBox.scrollLeft(toLeft);
			clearInterval(moveNum);
			moveBool = false;
		}
	}
	leftBtn.click(function(){
		crossLeftHandler();
	});
	rightBtn.click(function(){
		crossRightHandler();
	});
	
	var autoPlay = function(){
		autoNum = setInterval(crossRightHandler,inter);
	}
	
	box.hover(function(){
				clearInterval(autoNum);
			},function(){
				autoPlay();
			});
	
	autoPlay();
	
}