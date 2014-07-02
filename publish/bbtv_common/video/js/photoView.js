// JavaScript Document
//////////////////////////////////////////////////////////////////
///////////////////////copy by Nicho XiaoYi 09/01/12//////////////
//////////////////////////////////////////////////////////////////
var PhotoView = function(boxId,smallArr,bigArr,introArr,imgIdArr,theTimeArr,theTickArr)
{
	
	var smImgArr = new Array();
	var biImgArr = new Array();
	var inArr = new Array();
	var idArr = new Array();
	var tiArr = new Array();
	
	var box = 0;
	var numFrame = 0;
	var photoFrame = 0;
	var introFrame = 0;
	var timeFrame = 0;
	var listFrame = 0;
	var listImgFrame = 0;
	var nextBtn = 0;
	var prevBtn = 0;
	var leftBtn = 0;
	var rightBtn = 0;
	var phImg = 0;
	var tickFrame = 0;
	
	var listBox = 0;
	var imgArr = new Array();
	var cutArr = new Array();
	
	var imgFrameArr = new Array();
	
	var nowPlayNum = 0;//Now Play ID
	var playNum = 0;//Old Play ID
	var nowDisNum = 0;//Now Display ID
	
	var theLength = 0;
	var numAddHander = 0;
	
	var pageUrlHash = window.location.hash;
	var pageUrlHref = window.location.href;
	/*************************Get Data start*****************************************/
	
	theLength = smallArr.length;
	theLength = Math.min(theLength,bigArr.length);
	theLength = Math.min(theLength,introArr.length);
	theLength = Math.min(theLength,imgIdArr.length);
	theLength = Math.min(theLength,theTimeArr.length);
	theLength = Math.min(theLength,theTickArr.length);
	//document num box
	//if(document.getElementById("numBox").innerHTML != theLength) document.getElementById("numBox").innerHTML = theLength;
	
	for(var a = 0; a < theLength;a ++){
		smImgArr.push(smallArr[a]);
		biImgArr.push(bigArr[a]);
		inArr.push(introArr[a]);
		idArr.push(imgIdArr[a]);
		tiArr.push(theTimeArr[a]);
	}
	if(pageUrlHash.match(/#IMG=/)){
		for(var i = 0; i < theLength; i ++){
			if(idArr[i] == pageUrlHref.substr(pageUrlHref.search(/#IMG=/) + 5,pageUrlHref.length)){
				nowPlayNum = i;
				playNum = nowPlayNum;
			}
		}
	}
	/*************************Get Data end*****************************************/
	
	/*************************Create UI start****************************************/
	var createUi = function(){
		box = document.getElementById(boxId);
		box.style.position = "relative";
		
		numFrame = document.createElement("div");
		box.appendChild(numFrame);
		with(numFrame){
			style.height = 30 + "px";
			style.width = 530 + "px";
			style.margin = "0 auto";
			style.clear = "both";
			style.lineHeight = 30 + "px";
			style.color = "#999";
			style.fontSize = 14 + "px";
			style.textAlign = "center";
		}
		
		photoFrame = document.createElement("div");
		box.appendChild(photoFrame);
		with(photoFrame){
			style.clear = "both";
			style.width = 515 + "px";
			style.height = 400 + "px";
			style.lineHeight = 400 + "px";
			style.color = "#666";
			style.fontSize = 12 + "px";
			style.border = "solid 1px #ccc";
			style.padding = 3 + "px";
			style.overflow = "hidden";
			style.margin = "0 auto";
			style.zoom = 1;
			style.fontSize = 0 + "px";
			style.textAlign = "center";
			style.background = "url(/bbtv_common/video/img/loading.gif) no-repeat 264px 197px";
		}
		
		introFrame = document.createElement("div");
		box.appendChild(introFrame);
		with(introFrame){
			style.clear = "both";
			style.width = 530 + "px";
			style.height = 20 + "px";
			style.lineHeight = 20 + "px";
			style.textAlign = "center";
			style.fontSize = 12 + "px";
			style.margin = "0 auto";
			style.color = "#333";
			style.overflow = "hidden";
			style.zoom = 1;
			style.paddingTop = 5 + "px";
		}
		
		timeFrame = document.createElement("div");
		box.appendChild(timeFrame);
		with(timeFrame){
			style.clear = "both";
			style.width = 530 + "px";
			style.height = 15 + "px";
			style.lineHeight = 15 + "px";
			style.textAlign = "center";
			style.fontSize = 12 + "px";
			style.margin = "0 auto";
			style.color = "#888";
			style.overflow = "hidden";
			style.zoom = 1;
			style.paddingBottom = 3 + "px";
		}
		
		tickFrame = document.createElement('div');
		box.appendChild(tickFrame);
		with(tickFrame){
			style.clear = "both";
			style.width = 530 + "px";
			style.height = 15 + "px";
			style.lineHeight = 15 + "px";
			style.textAlign = "center";
			style.fontSize = 12 + "px";
			style.margin = "0 auto";
			style.color = "#666";
			style.overflow = "hidden";
			style.zoom = 1;
			style.paddingBottom = 15 + "px";
		}
		
		listFrame = document.createElement("div");
		box.appendChild(listFrame);
		with(listFrame){
			style.clear = "both";
			style.width = 540 + "px";
			style.height = 120 + "px";
			style.margin = "-50px auto 0px auto";
			style.overflow = "hidden";
			style.zoom = 1;
			style.fontSize = 0 + "px";
		}
		
		leftBtn = document.createElement("em");
		listFrame.appendChild(leftBtn);
		with(leftBtn){
			style.width = 25 + "px";
			style.height = 120 + "px";
			style.styleFloat = "left";
			style.cssFloat = "left";
			style.display = "block";
			style.background = "url(/bbtv_common/video/img/lrListBtn.gif) no-repeat";
			style.cursor = "pointer";
			style.fontSize = 0 + "px";
		}
		
		var cutBox = document.createElement("i");
		listFrame.appendChild(cutBox);
		with(cutBox){
			style.width = 3 + "px";
			style.height = 120 + "px";
			style.styleFloat = "left";
			style.cssFloat = "left";
			style.display = "block";
			style.fontSize = 0 + "px";
			style.lineHeight = 0 + "px";
		}
		
		listImgFrame = document.createElement("div");
		listFrame.appendChild(listImgFrame);
		with(listImgFrame){
			style.width = 485 + "px";
			style.height = 120 + "px";
			style.overflow = "hidden";
			style.zoom = 1;
			style.cssFloat = "left";
			style.styleFloat = "left";
		}
		
		rightBtn = document.createElement("em");
		listFrame.appendChild(rightBtn);
		with(rightBtn){
			style.width = 25 + "px";
			style.height = 120 + "px";
			style.styleFloat = "right";
			style.cssFloat = "right";
			style.display = "block";
			style.background = "url(/bbtv_common/video/img/lrListBtn.gif) no-repeat -54px 0";
			style.cursor = "pointer";
			style.fontSize = 0 + "px";
		}
		
		prevBtn = document.createElement("button");
		if(theLength > 1) box.appendChild(prevBtn);
		with(prevBtn){
			style.display = "block";
			style.width = 30 + "px";
			style.height = 31 + "px";
			style.position = "absolute";
			style.top = 225 + "px";
			//if(!(Sys.ie == "6.0")) style.left = "0px";
			//else style.left = -75 + "px";
			style.left =  0 + "px";
			style.background = "url(/bbtv_common/video/img/lrBtn.gif) no-repeat 0px 0px";
			if(nowPlayNum == 0) style.backgroundPosition = "-30px 0px";
			style.cursor = "pointer";
			style.fontSize = 0 + "px";
			style.lineHeight = 0 + "px";
			style.zIndex = 1;
			style.border = 0 + "px";
		}
		
		nextBtn = document.createElement("button");
		if(theLength > 1) box.appendChild(nextBtn);
		with(nextBtn){
			style.display = "block";
			style.width = 30 + "px";
			style.height = 31 + "px";
			style.position = "absolute";
			style.top = 225 + "px";
			style.right = 0 + "px";
			style.background = "url(/bbtv_common/video/img/lrBtn.gif) no-repeat 0 -31px";
			if(nowPlayNum == theLength - 1) style.backgroundPosition = "-30px -31px";
			style.cursor = "pointer";
			style.fontSize = 0 + "px";
			style.lineHeight = 0 + "px";
			style.zIndex = 2;
			style.border = 0 + "px";
		}
		
	}
	createUi();
	/*************************Create UI end****************************************/
	
	/*************************Create List Frame start************************************/
	var createList = function(){
		listBox = document.createElement("div");
		listImgFrame.appendChild(listBox);
		with(listBox){
			style.height = 118 + "px";
			style.width = 122 * theLength + "px";
			style.overflow = "hidden";
			style.zoom = 1;
			style.paddingTop = 1 + "px";
		}
		
		for(var b = 0; b < theLength; b ++){
			var newFrame = document.createElement("div");
			listBox.appendChild(newFrame);
			with(newFrame){
				style.width = 114 + "px";
				style.height = 114 + "px";
				style.cssFloat = "left";
				style.styleFloat = "left";
				if(b != nowPlayNum)style.border = "dashed 1px #ccc";
				else style.border = "solid 1px #e385a4";
				style.padding = 1 + "px";
				style.fontSize = 0 + "px";
				style.lineHeight = 0 + "px";
				style.cursor = "pointer";
				style.background = "url(/bbtv_common/video/img/loading.gif) no-repeat 49px 49px";
				style.textAlign = "center";
				style.overflow = "hidden";
				style.zoom = 1;
			}
			imgFrameArr.push(newFrame);
			
			var newCut = document.createElement("i");
			listBox.appendChild(newCut);
			with(newCut){
				style.display = "block";
				style.width = 4 + "px";
				style.height = 116 + "px";
				style.cssFloat = "left";
				style.styleFloat = "left";
				style.fontSize = 0 + "px";
				style.lineHeight = 0 + "px";
			}
			cutArr.push(newCut);
		}
	}
	createList();
	/*************************Create List Frame end************************************/
	
	/*************************Check Size start***********************************/
	var checkSize = function(_width,_height,_imgWidth,_imgHeight){
		var imgObj = new Object();
		imgObj.width = 0;
		imgObj.height = 0;
		imgObj.marginTop = 0;
		if(_imgWidth / _imgHeight >= _width / _height){
			if(_imgWidth > _width){
				imgObj.width = _width;
				imgObj.height = _width * _imgHeight / _imgWidth;
			}else{
				imgObj.width = _imgWidth;
				imgObj.height = _imgHeight;
			}
		}else{
			if(_imgHeight > _height){
				imgObj.height = _height;
				imgObj.width = _height * _imgWidth / _imgHeight;
			}else{
				imgObj.width = _imgWidth;
				imgObj.height = _imgHeight;
			}
		}
		imgObj.marginTop = (_height - imgObj.height) / 2;
		return imgObj;
	}
	/*************************Check Size end***********************************/
	
	/*************************Load small img start*****************************************/
	if(Sys.ie){
		var checkSmImgHander = new Array();
		var checkSmImgNum = new Array();
	}
	var checkImgSize = function(num){
		return function(){
			if(imgArr[num].complete){
				if(Sys.ie) clearInterval(checkSmImgHander[num]);
				imgArr[num].onload = null;
				var newObj = checkSize(114,114,imgArr[num].clientWidth,imgArr[num].clientHeight);
				imgArr[num].style.width = newObj.width + "px";
				imgArr[num].style.height = newObj.height + "px";
				imgArr[num].style.marginTop = newObj.marginTop + "px";
				imgArr[num].style.filter = "alpha(opacity = 100)";
				imgArr[num].style.opacity = 1;
				imgFrameArr[num].style.background = "none";
			}else{
				if(Sys.ie){
					checkSmImgNum[num] ++;
					if(checkSmImgNum[num] >= 5000){
						clearInterval(checkSmImgHander[num]);
						imgFrameArr[num].removeChild(imgArr[num]);
						imgArr[num].onload = null;
						imgFrameArr[num].style.background = "url(/bbtv_common/video/img/noLoad.gif) no-repeat 1px 1px";
					}
				}
			}
		}
	}
	var loadSmallImg = function(num){
		imgArr[num] = document.createElement("img");
		imgFrameArr[num].appendChild(imgArr[num]);
		with(imgArr[num]){
			src = smImgArr[num];
			style.filter = "alpha(opacity = 0)";
			style.opacity = 0;
		}
		if(!Sys.ie){
			imgArr[num].onload = checkImgSize(num);
		}else{
			checkSmImgNum[num] = 0;
			checkSmImgHander[num] = setInterval(checkImgSize(num),100);
		}
	}
	for(var c = 0; c < theLength; c ++){
		loadSmallImg(c);
	}
	/*************************Load small img end*****************************************/
	
	/*************************Mouse out and over Event start**********************************************/
	var prevBtnOverHander = function(){
		if(nowPlayNum != 0){
			prevBtn.style.backgroundPosition = "-60px 0";
		}
	}
	var prevBtnOutHander = function(){
		if(nowPlayNum != 0){
			prevBtn.style.backgroundPosition = "0 0";
		}
	}
	var nextBtnOverHander = function(){
		if(nowPlayNum != theLength - 1){
			nextBtn.style.backgroundPosition = "-60px -31px";
		}
	}
	var nextBtnOutHander = function(){
		if(nowPlayNum != theLength - 1){
			nextBtn.style.backgroundPosition = "0 -31px";
		}
	}
	prevBtn.onmouseover = function(){prevBtnOverHander()};
	prevBtn.onmouseout = function(){prevBtnOutHander()};
	nextBtn.onmouseover = function(){nextBtnOverHander()};
	nextBtn.onmouseout = function(){nextBtnOutHander()};
	
	var leftBtnOverHander = function(){
		leftBtn.style.backgroundPosition = "-27px 0";
	}
	var leftBtnOutHander = function(){
		leftBtn.style.backgroundPosition = "0 0";
	}
	var rightBtnOverHander = function(){
		rightBtn.style.backgroundPosition = "-81px 0";
	}
	var rightBtnOutHander = function(){
		rightBtn.style.backgroundPosition = "-54px 0";
	}
	leftBtn.onmouseover = function(){leftBtnOverHander()};
	leftBtn.onmouseout = function(){leftBtnOutHander()};
	rightBtn.onmouseover = function(){rightBtnOverHander()};
	rightBtn.onmouseout = function(){rightBtnOutHander()};
	
	var imgFrameOverHander = function(num){
		return function(){
			if(num != nowPlayNum) imgFrameArr[num].style.borderColor = "#666";
		}
	}
	var imgFrameOutHander = function(num){
		return function(){
			if(num != nowPlayNum) imgFrameArr[num].style.borderColor = "#ccc";
		}
	}
	for(var d = 0; d < theLength; d ++){
		imgFrameArr[d].onmouseover = imgFrameOverHander(d);
		imgFrameArr[d].onmouseout = imgFrameOutHander(d);
	}
	/*************************Mouse out and over Event end**********************************************/
	
	/*************************Big Img Show start******************************************/
	if(Sys.ie){
		var checkImgHander = 0;
		var checkImgNum = 0;
	}
	
	var bigImgCheckLoad = function(){
		if(phImg.complete){
			if(Sys.ie) clearInterval(checkImgHander);
			phImg.onload = null;
			photoFrame.style.background = "none";
			var newObj = checkSize(535,400,phImg.clientWidth,phImg.clientHeight);
			phImg.style.width = newObj.width + "px";
			phImg.style.height = newObj.height + "px";
			phImg.style.marginTop = newObj.marginTop + "px";
			phImg.style.filter = "alpha(opacity = 100)";
			phImg.style.opacity = 1;
		}else{
			if(Sys.ie){
				checkImgNum ++;
				if(checkImgNum >= 10000){
					clearInterval(checkImgHander);
					phImg.onload = null;
					photoFrame.style.background = "none";
					photoFrame.innerHTML = "对不起，图片加载失败！";
				}
			}
		}
	}
	
	/*******************PV******************************/
	var pageReload = function(){
		pageUrlHash = "#IMG=" + idArr[nowPlayNum];
		window.location.hash = pageUrlHash;
		window.open(window.location.href,"_top");
	}
	/*******************PV*******************************/
	
	var bigImgShow = function(){
		pageUrlHash = "#IMG=" + idArr[nowPlayNum];
		window.location.hash = pageUrlHash;
		
		photoFrame.innerHTML = "";
		photoFrame.style.background = "url(/bbtv_common/video/img/loading.gif) no-repeat 264px 197px";
		
		phImg = document.createElement("img");
		photoFrame.appendChild(phImg);
		with(phImg){
			if(nowPlayNum < theLength - 1){
				alt = "点击进入下一张";
				onclick = function(){nextBtnClickHander()};
				style.cursor = "pointer";
			}
			src = biImgArr[nowPlayNum];
			style.filter = "alpha(opacity = 0)";
			style.opacity = 0;
			
		}
		
		numFrame.innerHTML = (nowPlayNum + 1) + " " + "/" + " " + theLength;
		var newStr = new String();
		if(inArr[nowPlayNum].length <= 40) newStr = inArr[nowPlayNum];
		else newStr = inArr[nowPlayNum].substr(0,40) + "...";
//		timeFrame.innerHTML = "参与活动：" + tiArr[nowPlayNum];
//		introFrame.innerHTML = '<span style="color:red">标题：</span>' + newStr;
//		newStr = theTickArr[nowPlayNum];
//		tickFrame.innerHTML = '<span style="color:red">已获得票数：</span>' + newStr + ' <input type="button" id="tick_' + idArr[nowPlayNum] + '" value="投它一票" />';
		
		if(nowPlayNum >= nowDisNum + 4 && nowPlayNum != theLength - 1) nowDisNum = nowPlayNum - 3;
		if(nowPlayNum == theLength - 1) nowDisNum = theLength - 4;
		if(nowPlayNum <= nowDisNum && nowPlayNum != 0) nowDisNum = nowPlayNum - 1;
		if(nowPlayNum == 0) nowDisNum = 0;
		
		if(Sys.ie){
			checkImgNum = 0;
			checkImgHander = setInterval(bigImgCheckLoad,100);
		}else{
			phImg.onload = function(){bigImgCheckLoad()};
		}
		
	}
	if(theLength > 0) bigImgShow();
	/*************************Big Img Show end******************************************/
	
	/*************************Scroll Img start***************************************/
	var scrollImgHander = function(){
		var toScroll = 122 * nowDisNum;
		var nowScroll = listImgFrame.scrollLeft;
		scrollSpeed = (toScroll - nowScroll) / 5;
		if(Math.abs(scrollSpeed) >= 1) listImgFrame.scrollLeft += scrollSpeed;
		else listImgFrame.scrollLeft = toScroll;
		
		setTimeout(scrollImgHander,30);
	}
	var scrollSpeed = 0;
	scrollImgHander();
	/*************************Scroll Img end***************************************/
	
	/*************************leftBtn and rightBtn click Event start****************************************/
	var leftBtnDownHander = function(){
		if(nowDisNum > 0) nowDisNum --;
	}
	var rightBtnDownHander = function(){
		if(nowDisNum < theLength - 4) nowDisNum ++;
	}
	var leftBtnDown = function(){
		leftBtnDownHander();
		numAddHander = setInterval(leftBtnDownHander,100);
	}
	var rightBtnDown = function(){
		rightBtnDownHander();
		numAddHander = setInterval(rightBtnDownHander,100);
	}
	var LRBtnUp = function(){
		clearInterval(numAddHander);
	}
	leftBtn.onmousedown = function(){leftBtnDown();};
	rightBtn.onmousedown = function(){rightBtnDown();};
	leftBtn.onmouseup = function(){LRBtnUp();};
	rightBtn.onmouseup = function(){LRBtnUp();};
	/*************************leftBtn and rightBtn click Event end****************************************/
	
	/*************************Change Img Display start*******************************************************/
	var changeImgPlay = function(){
		if(playNum != nowPlayNum){
			if(nowPlayNum == 0 && playNum != 0) prevBtn.style.backgroundPosition = "0px 0";
			if(nowPlayNum == theLength - 1 && playNum != theLength - 1) nextBtn.style.backgroundPosition = "-30px -31px";
			if(nowPlayNum != 0 && playNum == 0) prevBtn.style.backgroundPosition = "0px 0";
			if(nowPlayNum != theLength - 1 && playNum == theLength - 1) nextBtn.style.backgroundPosition = "0px -31px";
			
			imgFrameArr[playNum].style.border = "dashed 1px #ccc";
			playNum = nowPlayNum;
			imgFrameArr[playNum].style.border = "solid 1px #e385a4";
			if(!phImg.complete){
				phImg.onload = null;
				if(Sys.ie) clearInterval(checkImgHander);
			}
			photoFrame.removeChild(phImg);
			
			bigImgShow();
			
			PVIframe();
		}
	}
	/*************************Change Img Display end*******************************************************/
	
	/*************************Click Event start********************************************/
	var prevBtnClickHander = function(){
		if(nowPlayNum > 0){
			nowPlayNum --;
			changeImgPlay();
			
		}
	}
	var nextBtnClickHander = function(){
		if(nowPlayNum < theLength - 1){
			nowPlayNum ++;
			changeImgPlay();
		}
	}
	prevBtn.onclick = function(){prevBtnClickHander();};
	nextBtn.onclick = function(){nextBtnClickHander();};
	
	var listImgClickHander = function(num){
		return function(){
			if(nowPlayNum != num){
				nowPlayNum = num;
				changeImgPlay();
			}
		}
	}
	for(var e = 0; e < theLength; e ++){
		imgFrameArr[e].onclick = listImgClickHander(e);
	}
	/*************************Click Event end********************************************/
}
































































