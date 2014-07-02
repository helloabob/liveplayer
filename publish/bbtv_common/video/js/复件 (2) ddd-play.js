
function getJSBuddies(chanl_name,category_name,property)
{
	$.ajax({
        type: "get",
        url: "http://www1.bbtv.cn/d/cvclick.ashx?callback=?",
        dataType: "json",
        data: "c="+chanl_name+"&t=0&p="+category_name,
        beforeSend: function(XMLHttpRequest) {
        },
        success: function(data) {
           var lasthtml="";
           if(data.DocumentElement!=undefined)
           {
               $(data.DocumentElement.fitctable).each(function(i){           
                    var classpath = this.classpath;  
                    classpath=classpath.replace(/&amp;lt;br&amp;gt;/g, "<br />").replace(/\\u000a/g, "<br />").replace(/\\/g, "");            
                    var newspath = this.newspath;
                    var titlepic = this.titlepic;  
                    titlepic=titlepic.replace(/&amp;lt;br&amp;gt;/g, "<br />").replace(/\\u000a/g, "<br />").replace(/\\/g, "");  
                    var id = this.id; 
                    var title = this.title; 
                    var titleurl="/"+classpath+"/"+newspath+"/"+id+".shtml";
                    var newstime=this.newstime;
                    newstime=newstime.split(' ');
                    newstime=newstime[0];
                                                
                    lasthtml+="<li> <p>"+title+"<em>"+newstime+"</em></p><div class=\"pic\"><div><a href=\""+titleurl+"\" title=\""+title+"\"><img src=\""+titlepic+"\"/></a>  <a href=\""+titleurl+"\" title=\"播放视频\" class=\"playIcon\"></a> </div></div> </li>";       
               }); 
           }           
           $("ul.videoList").html(lasthtml);


$(".videoList li").pngFix({
				sizingMethod: "scale"
		});	
		$(".videoList li").hover(
			 function(){$(this).animate({top: '-73px'},250);},
			function(){$(this).animate({top: '0px'},250);}
			);
		$(".videoList").css("width",131*$("#idContent li").size());
	_$("idBar").style.width = _$("idSlider").clientWidth * (Math.min(_$("idContent").clientWidth / _$("idContent").scrollWidth, 1))+ "px";
   var sld = new Slider("idSlider", "idBar", {
        MaxValue: _$("idContent").scrollWidth - _$("idContent").clientWidth,
        onMove: function(){ _$("idContent").scrollLeft = this.GetValue(); }
    });
    $('#idBar').mouseover(function(){
								   $(this).css('background-position','0px -6px');$(this).find(".lft").css('background-position','0px -6px');$(this).find(".rt").css('background-position','-3px -6px');}).mousedown(function(){
									   $(this).css('background-position','0px -12px');$(this).find(".lft").css('background-position','0px -12px');$(this).find(".rt").css('background-position','-3px -12px');}).mouseout(function(){
										   $(this).css('background-position','0px 0px');$(this).find(".lft").css('background-position','0px 0px');$(this).find(".rt").css('background-position','-3px 0px');});
  
  //滑动条
 // sld.SetPercent(.5);
    sld.Ease = true;
    
    _$("sliderLeft").onmouseover = function(){ sld.Run(false); }
    _$("sliderLeft").onmouseout = function(){ sld.Stop(); }
    
    _$("sliderRight").onmouseover = function(){ sld.Run(true); }
    _$("sliderRight").onmouseout = function(){ sld.Stop(); }

         },
        complete: function(XMLHttpRequest, textStatus) {
        },
        error: function() {            
        }
    });    
}







