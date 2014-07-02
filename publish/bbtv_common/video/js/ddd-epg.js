var ddd_date,ddd_time,ddd_now,ddd_ifstop=1,ddd_pre_stop=1,ddd_nxt_stop=1,ddd_now_ready=1,ddd_wz=0,mousePos;
function getObject(objectId) {
    if (document.getElementById && document.getElementById(objectId)) {
        return document.getElementById(objectId);
    } else if (document.all && document.all(objectId)) {
        return document.all(objectId);
    } else if (document.layers && document.layers[objectId]) {
        return document.layers[objectId];
    } else {
        return false;
    }
}
function ChangeSelectItemByValue() { 
    getObject("sel-time").value=ddd_time;
    var date = ddd_date.split('-');
    var nowMonth=date[1];
    var nowDate=date[2];
    $("input#dateinput").val(date[0]+"-"+(nowMonth>9?nowMonth:"0"+nowMonth)+"-"+(nowDate>9?nowDate:"0"+nowDate));
    $('form.jNice').jNice();       
}  
function gettodayselect(){
    /*var days = new Array("日","一","二","三","四","五","六");            
    for(var i=0;i<15;i++)
    {
        var tmpTime=new Date();
        tmpTime.setDate(tmpTime.getDate()+i-7);
        var tmpDatevalue=tmpTime.getFullYear()+"-"+(tmpTime.getMonth()+1)+"-"+tmpTime.getDate();
        var tmpDatetxt=(tmpTime.getMonth()+1)+"月"+tmpTime.getDate()+"日 星期"+days[tmpTime.getDay()];        
        if(i==6){tmpDatetxt="【昨天】 "+tmpDatetxt;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"'>"+tmpDatetxt+"</option>"); }
        else if(i==7) {tmpDatetxt="【今天】 "+tmpDatetxt;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"' selected>"+tmpDatetxt+"</option>"); }
        else if(i==8) {tmpDatetxt="【明天】 "+tmpDatetxt;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"'>"+tmpDatetxt+"</option>"); }
        else $("select[name=sel-date]").append("<option value='"+tmpDatevalue+"'>"+tmpDatetxt+"</option>"); 
    }
    */
    var nowTime = new Date();
    nowTime.setHours(nowTime.getHours()-1);
    var nowHour=nowTime.getHours();    
    var nowMonth=(nowTime.getMonth()+1);
    var nowDate=nowTime.getDate();
    $("input#dateinput").val(nowTime.getFullYear()+"-"+(nowMonth>9?nowMonth:"0"+nowMonth)+"-"+(nowDate>9?nowDate:"0"+nowDate));    
    
    for (var i = 0; i < 24; i++)
    {
        if(nowHour!=i)
        $("select[name=sel-time]").append("<option value='"+i+"'>"+(i > 9 ? i : "0" + i)+":00</option>"); 
        else
        $("select[name=sel-time]").append("<option value='"+i+"' selected>"+(i > 9 ? i : "0" + i)+":00</option>"); 
    }
} 
function move(dheight)
{
   if(ddd_pre_stop==1 && ddd_nxt_stop==1 &&ddd_ifstop==1 && ddd_now_ready==1)
   {
        hide_float();
        ddd_ifstop=0;
        $("#ddd_epg").html(ddd_now);
        var _this=$("#ddd_epg");
        var line=49*3,line2=392,speed=600;
        if(dheight>0)
        {
            if(parseInt($("div.channel-list:first",_this).css('top'),10)<0)
            { 
                ddd_wz+=3; 
                var tmp=$(".channel-list",_this).length-1;         
                if(tmp>=0)
                {
                    $(".channel-list",_this).each(function(i){
		                    var ydtmp=parseInt($(this).css('top'),10)+line;
		                    $(this).animate({top:ydtmp}, speed,function(){
		                      if(i==tmp) {ddd_now=_this.html(); ddd_ifstop=1;}
		                    });
                    }); 
                }
                else
                {ddd_ifstop=1;}                 
                $("a#upbtn").addClass("disable_up");
                $("a#downbtn").removeClass("disable_down"); 
                $("span.btn_disabled").eq(0).css("display","");  
                $("span.btn_disabled").eq(1).css("display","none"); 
             }
            else
            {
               ddd_ifstop=1;
            }
         }
         else
         {
            if(parseInt($("div.channel-list:last",_this).css('top'),10)>=line2)
            {
                ddd_wz-=3;                 
                var tmp=$(".channel-list",_this).length-1;                 
                if(tmp>=0)
                {       
                    $(".channel-list",_this).each(function(i){
	                        var ydtmp=parseInt($(this).css('top'),10)-line;
		                    $(this).animate({top:ydtmp}, speed,function(){
		                      if(i==tmp)
		                      {ddd_now=_this.html(); ddd_ifstop=1;}
		                    });
                    }); 
                }
                else
                {ddd_ifstop=1;} 
                $("a#downbtn").addClass("disable_down"); 
                $("a#upbtn").removeClass("disable_up");
                $("span.btn_disabled").eq(0).css("display","none");  
                $("span.btn_disabled").eq(1).css("display","");                         
            }
            else
            {
               ddd_ifstop=1;
            }
         }
     }
}
function Getairdom()
{
    var date = ddd_date.split('-');
    var nextTimetmp = new Date(date[0],parseInt(date[1],10)-1,date[2],parseInt(ddd_time,10),0,0,0);
    var nextTime=Date.parse(nextTimetmp); 
    nextTimetmp.setHours(nextTimetmp.getHours()+3);    
    var nextTime2=Date.parse(nextTimetmp);    
    var nowTime = new Date();
    nowTime=Date.parse(nowTime);    
    var speed=2000;
    if(nowTime>=  nextTime && nowTime<nextTime2)
    {
       var airleft=nowTime-nextTime;
       airleft=73.5+(276*(airleft/3600000));       
       $("div.onair").css("left", 73.5);
       $("div.onair").css("display",'block'); 
       $("div.onair").animate({left:airleft}, speed);
    }
    else
    {
        $("div.onair").css("display",'none'); 
    }    
}
function Getairdom_settime()
{
    var date = ddd_date.split('-');
    var nextTimetmp = new Date(date[0],parseInt(date[1],10)-1,date[2],parseInt(ddd_time,10),0,0,0);
    var nextTime=Date.parse(nextTimetmp); 
    
    nextTimetmp.setHours(nextTimetmp.getHours()+3);
    
    var nextTime2=Date.parse(nextTimetmp);
    var nowTime = new Date();
    nowTime=Date.parse(nowTime);
    var speed=500;
    if(nowTime>=  nextTime && nowTime<nextTime2)
    {
       var airleft=nowTime-nextTime;
       airleft=73.5+(276*(airleft/3600000));       
       $("div.onair").css("display",'block'); 
       $("div.onair").animate({left:airleft}, speed);
    }
    else
    {
        $("div.onair").css("display",'none'); 
    }
    window.setTimeout("Getairdom_settime();",60000);
    
}
function GetTimeLine()
{
    for (var i = 0; i < 6; i++)
    {
        var date = ddd_date.split('-');
        var tmpTime = new Date(date[0],parseInt(date[1],10)-1,date[2],parseInt(ddd_time,10),0,0,0);
        var index=i%3;
        tmpTime.setHours(tmpTime.getHours()+index);        
        var timetp=tmpTime.getHours() > 9 ? tmpTime.getHours()  : "0" + tmpTime.getHours() ;
        var timetp1=timetp+":"+"00";
        var timetp2=timetp+":"+"30";
        $("li",$("ul.times")).eq(2*i).text(timetp1);
        $("li",$("ul.times")).eq(2*i+1).text(timetp2);
    }
    //GetHorPos();
}
function GetHorPos()
{
    var speed=500;
    var horleft=(ddd_time*724/23)+99;
    $("div.scroll-hor div.handle").animate({left:horleft}, speed);  
    $("div.scroll-hor div.scroll-arrows").animate({left:horleft+25}, speed);      
}
function ChangeTimeByHour(hour)
{
    var date = ddd_date.split('-');
    var nextTime = new Date(date[0],parseInt(date[1],10)-1,date[2],parseInt(ddd_time,10),0,0,0);
    nextTime.setHours(nextTime.getHours()+hour);
    ddd_date=nextTime.getFullYear()+"-"+(nextTime.getMonth()+1)+"-"+nextTime.getDate();
    ddd_time=nextTime.getHours();
    ChangeSelectItemByValue();
}
function loadXML() {
    ddd_now_ready=0;
    var ddd_ts="<div align=center style='padding-top:60px'><img src='/bbtv_common/video/img/gridloading.gif' border=0></div>";
	$.ajax({
    type: "post",
    url: "/app_xml/epgajax.ashx",
    dataType:"text",
    data: "date="+ddd_date+"&time="+ddd_time+"&pos="+ddd_wz,
    beforeSend: function(XMLHttpRequest){
        $("#ddd_epg").html(ddd_ts);
    },
    success: function(data){
       $("#ddd_epg").html(data);        
       ddd_now=data;
       ddd_now_ready=1;
    },
    complete: function(XMLHttpRequest, textStatus){
    },
    error: function(){
        ddd_now_ready=1;
    }  
	});   
	GetTimeLine();
	Getairdom(); 
}
function loadXMLData() {
    ddd_now_ready=0;
	$.ajax({
    type: "post",
    url: "/app_xml/epgajax.ashx",
    dataType:"text",
    data: "date="+ddd_date+"&time="+ddd_time+"&pos="+ddd_wz,
    beforeSend: function(XMLHttpRequest){
    },
    success: function(data){
       ddd_now=data;
       ddd_now_ready=1;
    },
    complete: function(XMLHttpRequest, textStatus){
    },
    error: function(){
        ddd_now_ready=1;
    }  
	});   
}
function WritePreDOM(){
    if(ddd_pre_stop==1 && ddd_nxt_stop==1 &&ddd_ifstop==1 && ddd_now_ready==1)
    {        
        var line=828,speed=2000;
        ddd_pre_stop=0;
        $("#ddd_epg").html(ddd_now);
        var _this=$("#ddd_epg");
        var tmp=$(".inner",_this).length-1;  
        if(tmp>=0)
        {       
            $(".inner",_this).each(function(i){
                var ydtmp=parseInt($(this).css('left'),10)+line;
                $(this).animate({left:ydtmp}, speed,function(){
                  if(i==tmp) ddd_pre_stop=1;
                });
            }); 
        }
        else
        {ddd_pre_stop=1;}
    }
    GetTimeLine();
	Getairdom(); 
}
function WriteNxtDOM()
{
    if(ddd_pre_stop==1 && ddd_nxt_stop==1 &&ddd_ifstop==1 && ddd_now_ready==1)
    {       
        var line=828,speed=2000;
        $("#ddd_epg").html(ddd_now);
        ddd_nxt_stop=0;
        var _this=$("#ddd_epg");
        var tmp=$(".inner",_this).length-1;  
        if(tmp>=0)
        {       
            $(".inner",_this).each(function(i){
                var ydtmp=parseInt($(this).css('left'),10)-line;
                $(this).animate({left:ydtmp}, speed,function(){
                  if(i==tmp) ddd_nxt_stop=1;
                });
            }); 
        }
        else
        {ddd_nxt_stop=1;}
    }   
    GetTimeLine();
	Getairdom();  
}
$(document).ready(function() {
    ddd_date=$("input#dateinput").val();
    ddd_time=getObject("sel-time").value;
    
	loadXML(ddd_date,ddd_time);

window.setTimeout("Getairdom_settime();",60000);
	
    $("a.btn_pre").click(function(){ 
        if(ddd_now_ready==1 && ddd_pre_stop==1 && ddd_nxt_stop==1 &&ddd_ifstop==1)
        {
            hide_float();
            ChangeTimeByHour(-3);
            WritePreDOM();
            loadXMLData();
        }
    });
    $("a.btn_next").click(function(){ 
        if(ddd_now_ready==1 && ddd_pre_stop==1 && ddd_nxt_stop==1 &&ddd_ifstop==1)
        {
            hide_float();
            ChangeTimeByHour(3);
            WriteNxtDOM();
            loadXMLData();
        }
    }); 
    /*$("div.scroll-prev").click(function(){ 
        if(ddd_now_ready==1 && ddd_pre_stop==1 && ddd_nxt_stop==1 &&ddd_ifstop==1)
        {
            ChangeTimeByHour(-3);
            WritePreDOM();
            loadXMLData();
        }
    });
    $("div.scroll-next").click(function(){ 
        if(ddd_now_ready==1 && ddd_pre_stop==1 && ddd_nxt_stop==1 &&ddd_ifstop==1)
        {
            ChangeTimeByHour(3);            
            WriteNxtDOM();
            loadXMLData();
        }       
    }); 
    $("#epg_look").click(function(){ 
        ddd_date=getObject("sel-date").value;
        ddd_time=getObject("sel-time").value;
        loadXML(ddd_date,ddd_time);
    });  */ 
    //png修复
    
	$(".pngfix").pngFix({
			sizingMethod: "crop"
	}); 	
	$(".close").each(
			function(){
			$(this).bind("click", function(){
				$(this).parent().css({display:"none"});
			});
		} );		
    $("div#float_l").draggable();
	$("div#float_r").draggable();
});
function hide_float()
{
    $('div#float_r').hide();
    $('div#float_l').hide();
}
function ddd_detail_show(myobj,cid,timestamp){
    hide_float();
	var clickElementy = mousePos.y - 30;
    var clickElementx = mousePos.x+15;    
    if(clickElementx+$('div#float_r').width()>document.body.offsetWidth)
    {
        clickElementx = mousePos.x-$('div#float_l').width()-15;
        ddd_detal_getdata(cid,timestamp,1);  
        $('div#float_l').css({left:clickElementx+"px", top: clickElementy+"px"});
	    $('div#float_l').show(); 
    }
    else
    {
       ddd_detal_getdata(cid,timestamp,0);
       $('div#float_r').css({left:clickElementx+"px", top: clickElementy+"px"});
	   $('div#float_r').show();
    }   
}
function ddd_detal_getdata(cid,timestamp,direct)
{
   if(direct==0)
   {
        $.ajax({
        type: "post",
        url: "/app_xml/epgitemajax.ashx",
        dataType:"xml",
        data: "cid="+cid+"&t="+timestamp,
        beforeSend: function(XMLHttpRequest){
            $("div#float_r .inner").html("<a style=\"cursor:pointer\" class=\"pic\"><img src=\"/bbtv_common/video/img/ddd.gif\" alt=\"数据请求中,请稍候...\" /></a> ");
        },
        success: function(xml){
            if ($("state", xml).text() == "0") {
                return;
            }
            var  title=$("title", xml).text();
            var  image=$("image", xml).text();
            var  url=$("url", xml).text();
            var  type=$("type", xml).text();
            if(type=="0")
            {
             $("div#float_r .inner").html(" <a href=\""+url+"\" class=\"pic\"><img src=\""+image+"\" alt=\""+title+"\" /></a> <div class=\"txt\">  <div class=\"boxCtner\"><a href=\""+url+"\"  class=\"tit\">"+title+"</a></div><div class=\"statues\"><a href=\""+url+"\">播放</a></div></div>");
             }
             else if(type=="1")
             {
             $("div#float_r .inner").html(" <a href=\""+url+"\" class=\"pic\"><img src=\""+image+"\" alt=\""+title+"\" /></a> <div class=\"txt\">  <div class=\"boxCtner\"><a href=\""+url+"\"  class=\"tit\">"+title+"</a></div><div class=\"statues\"><a href=\""+url+"\">正在直播</a></div></div>");
             }
             else
             {
             $("div#float_r .inner").html(" <a href=\""+url+"\" class=\"pic\"><img src=\""+image+"\" alt=\""+title+"\" /></a> <div class=\"txt\">  <div class=\"boxCtner\"><a href=\""+url+"\"  class=\"tit\">"+title+"</a></div><div class=\"statues\"><a href=\""+url+"\">即将播出</a></div></div>");
             }
        },
        complete: function(XMLHttpRequest, textStatus){
        },
        error: function(){
        }  
	    }); 
	 }
	 else
	 {
	     $.ajax({
        type: "post",
        url: "/app_xml/epgitemajax.ashx",
        dataType:"xml",
        data: "cid="+cid+"&t="+timestamp,
        beforeSend: function(XMLHttpRequest){
            $("div#float_l .inner").html("<a style=\"cursor:pointer\" class=\"pic\"><img src=\"/bbtv_common/video/img/ddd.gif\" alt=\"数据请求中,请稍候...\" /></a> ");
        },
        success: function(xml){
            if ($("state", xml).text() == "0") {
                return;
            }
            var  title=$("title", xml).text();
            var  image=$("image", xml).text();
            var  url=$("url", xml).text();
            var  type=$("type", xml).text();
            if(type=="0")
            {
             $("div#float_l .inner").html(" <a href=\""+url+"\" class=\"pic\"><img src=\""+image+"\" alt=\""+title+"\" /></a> <div class=\"txt\">  <div class=\"boxCtner\"><a href=\""+url+"\"  class=\"tit\">"+title+"</a></div><div class=\"statues\"><a href=\""+url+"\">播放</a></div></div>");
             }
             else if(type=="1")
             {
             $("div#float_l .inner").html(" <a href=\""+url+"\" class=\"pic\"><img src=\""+image+"\" alt=\""+title+"\" /></a> <div class=\"txt\">  <div class=\"boxCtner\"><a href=\""+url+"\"  class=\"tit\">"+title+"</a></div><div class=\"statues\"><a href=\""+url+"\">正在直播</a></div></div>");
             }
             else
             {
             $("div#float_l .inner").html(" <a href=\""+url+"\" class=\"pic\"><img src=\""+image+"\" alt=\""+title+"\" /></a> <div class=\"txt\">  <div class=\"boxCtner\"><a href=\""+url+"\"  class=\"tit\">"+title+"</a></div><div class=\"statues\"><a href=\""+url+"\">即将播出</a></div></div>");
             }
        },
        complete: function(XMLHttpRequest, textStatus){
        },
        error: function(){
        }  
	    }); 
	 }
}
function ddd_hide()
{
     $('.close').parent().hide();
}
document.onmousemove = mouseMove;
function mouseMove(ev){
    ev = ev || window.event; 
	mousePos = mousePosition(ev); 
}
function mousePosition(ev){
    if(ev.pageX || ev.pageY){
        return {x:ev.pageX, y:ev.pageY};
    }
    return {
        x:ev.clientX + document.documentElement.scrollLeft - document.documentElement.clientLeft,
        y:ev.clientY + document.documentElement.scrollTop - document.documentElement.clientTop   
    };
} 
function getAbsoluteLeft(objectId) {	
	o = objectId;
	oLeft = o.offsetLeft            
	while(o.offsetParent!=null) {   
		oParent = o.offsetParent   
		oLeft += oParent.offsetLeft 
		o = oParent
	}
	return oLeft
}
function getAbsoluteTop(objectId) {	
	o = objectId;
	oTop = o.offsetTop            
	while(o.offsetParent!=null) { 
		oParent = o.offsetParent 
		oTop += oParent.offsetTop 
		o = oParent
	}
	return oTop
}
function blockEvents(evt) {
              if(evt.target){
              evt.preventDefault();
              }else{
              evt.returnValue = false;
              }
}
function sel_time_change()
{
   hide_float();
   ddd_date=$("#dateinput").val();
   ddd_time=getObject("sel-time").value;
   loadXML(ddd_date,ddd_time);
}