var ddd_date,ddd_time,ddd_now,ddd_pre_stop,ddd_nxt_stop,ddd_now_ready,ddd_cid,ddd_chid,mousePos;
var ddd_arr=new Array(1620,1625,1621,1624,1626,1628,1623,1629,1630,1627,1622);
var ddd_url_arr=new Array('/radio/live/2009-07-07/651.shtml','/radio/live/2009-07-07/644.shtml','/radio/live/2009-07-07/645.shtml','/radio/live/2009-07-07/646.shtml','/radio/live/2009-07-07/647.shtml', '/radio/live/2009-07-24/1140.shtml', '/radio/live/2009-07-07/649.shtml','/radio/live/2009-07-29/1252.shtml','/radio/live/2009-07-29/1254.shtml','/radio/live/2009-07-07/648.shtml', '/radio/live/2009-07-07/650.shtml');
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
function gettodayselect(){
   /* var days = new Array("日","一","二","三","四","五","六");            
    for(var i=0;i<15;i++)
    {
        var tmpTime=new Date();
        tmpTime.setDate(tmpTime.getDate()+i-7);
        var tmpDatevalue=tmpTime.getFullYear()+"-"+(tmpTime.getMonth()+1)+"-"+tmpTime.getDate();
        var tmpDatetxt=(tmpTime.getMonth()+1)+"月"+tmpTime.getDate()+"日 星期"+days[tmpTime.getDay()]; 
        var tmpDatetxtNoxq=(tmpTime.getMonth()+1)+"月"+tmpTime.getDate()+"日"       
        if(i==6){tmpDatetxtNoxq="【昨天】"+tmpDatetxtNoxq;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"'>"+tmpDatetxtNoxq+"</option>"); }
        else if(i==7) {
        tmpDatetxtNoxq="【今天】"+tmpDatetxtNoxq;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"' selected>"+tmpDatetxtNoxq+"</option>"); 
        $('.date-dd').html(tmpTime.getDate());
	    $('.date-mon').html((tmpTime.getMonth()+1)+"月");
	    $('.date-year').html(tmpTime.getFullYear());
	    }
        else if(i==8) {tmpDatetxtNoxq="【明天】"+tmpDatetxtNoxq;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"'>"+tmpDatetxtNoxq+"</option>"); }
        else $("select[name=sel-date]").append("<option value='"+tmpDatevalue+"'>"+tmpDatetxt+"</option>"); 
    } */
    
    var nowTime = new Date();
    nowTime.setHours(nowTime.getHours()-1);
    var nowHour=nowTime.getHours();    
    var nowMonth=(nowTime.getMonth()+1);
    var nowDate=nowTime.getDate();    
    $("input#dateinput").val(nowTime.getFullYear()+"-"+(nowMonth>9?nowMonth:"0"+nowMonth)+"-"+(nowDate>9?nowDate:"0"+nowDate));     
    $('.date-dd').html(nowTime.getDate());
    $('.date-mon').html((nowTime.getMonth()+1));
    $('.date-year').html(nowTime.getFullYear());  
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

function ChangeSelectItemByValue() {     
    $("#"+ddd_chid+" .dateinput").val(ddd_date);  
    var date = ddd_date.split('-');
    var nowMonth=parseInt(date[1],10);
    var nowDate=parseInt(date[2],10); 
    $('.date-dd').html(nowDate>9?nowDate:"0"+nowDate);
	$('.date-mon').html(nowMonth>9?nowMonth:"0"+nowMonth);
	$('.date-year').html(date[0]);          
}

function WriteIndexPlayer(mydiv,myid,mytp,myendtp,linkurl)
{
    if (!getObject("smgbbFlashID01")) {
        var smgbbFlash2 = new smgFlash("/bbtv_common/index_flash/radio_com.swf", "smgbbFlashID01", "255", "190", "7", "#ffffff");
        smgbbFlash2.addParam("quality", "high");
        smgbbFlash2.addParam("wmode", "opaque");
        smgbbFlash2.addParam("salign", "t");
        smgbbFlash2.addVariable("cid", myid);
        smgbbFlash2.addVariable("linkurl", linkurl);
        smgbbFlash2.addVariable("timestamp", mytp);
        smgbbFlash2.addVariable("endtimestamp", myendtp);
        smgbbFlash2.addVariable("ui", "/bbtv_common/index_flash/video_set.swf");
        smgbbFlash2.write("playerdiv");
        //getObject("playerdiv").style.left += document.documentElement.scrollLeft;
        //getObject("playerdiv").top = getObject("air0").top;
    }
    else
    {
        try
        {
            getObject("smgbbFlashID01").playVideo(myid, mytp, myendtp,linkurl);
        }
        catch (e)
        {}
    }
}


function ddd_index(id){
    hide_float();
    ddd_cid=ddd_arr[id];
    ddd_chid=(id > 8 ? "ch0"+(id+1) : "ch00" + (id+1));
    var ddd_player=(id > 8 ? "player"+(id+1) : "player0" + (id+1));
    ddd_now_ready=1;ddd_pre_stop=1;ddd_nxt_stop=1;ddd_now="";       
    var tmpTime=new Date();    
    tmpTime.setHours(tmpTime.getHours()-1);
    ddd_time=tmpTime.getHours();  
    ddd_date=tmpTime.getFullYear()+"-"+(tmpTime.getMonth()+1)+"-"+tmpTime.getDate();    
    ChangeSelectItemByValue();
    loadXML();       
    //WriteIndexPlayer(ddd_player,ddd_cid,eval("st"+id),eval("ed"+id),ddd_url_arr[id]); 
    WriteIndexPlayer(ddd_player,ddd_cid,"","",ddd_url_arr[id])
}
function WritePreDOM(){
    if(ddd_pre_stop==1 && ddd_nxt_stop==1)
    {        
        var line=552,speed=2000;
        ddd_pre_stop=0;
        $("#"+ddd_chid+" div.channel-list").html(ddd_now);
        var _this=$("#"+ddd_chid+" div.channel-list");
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
    if(ddd_pre_stop==1 && ddd_nxt_stop==1)
    {       
        var line=552,speed=2000;
        $("#"+ddd_chid+" div.channel-list").html(ddd_now);
        ddd_nxt_stop=0;
        var _this=$("#"+ddd_chid+" div.channel-list");
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
function loadXMLData() {
    ddd_now_ready=0;
	$.ajax({
    type: "post",
    url: "/app_xml/epgcidajax_r.ashx",
    dataType:"text",
    data: "date="+ddd_date+"&time="+ddd_time+"&cid="+ddd_cid,
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
$(document).ready(function(){
    window.setTimeout("Getairdom_settime();",60000);   
    
    $("div.scroll-time-prev").click(function(){ 
        if(ddd_now_ready==1 && ddd_pre_stop==1 && ddd_nxt_stop==1)
        {
            hide_float();
            ChangeTimeByHour(-3);
            WritePreDOM();
            loadXMLData();
        }
    });
    $("div.scroll-time-next").click(function(){ 
        if(ddd_now_ready==1 && ddd_pre_stop==1 && ddd_nxt_stop==1)
        {
            hide_float();
            ChangeTimeByHour(3);
            WriteNxtDOM();
            loadXMLData();
        }
    }); 
    $("div.scroll-prev").click(function(){ 
        if(ddd_now_ready==1 && ddd_pre_stop==1 && ddd_nxt_stop==1)
        {
            hide_float();
            ChangeTimeByHour(-3);
            WritePreDOM();
            loadXMLData();
        }
    });
    $("div.scroll-next").click(function(){ 
        if(ddd_now_ready==1 && ddd_pre_stop==1 && ddd_nxt_stop==1)
        {
            hide_float();
            ChangeTimeByHour(3);            
            WriteNxtDOM();
            loadXMLData();
        }       
    });	
	$(".dateinput").change(function(){
	       hide_float();
	       ddd_date=$("#"+ddd_chid+" .dateinput").val();
	       loadXML();
           var dateValue=ddd_date.split('-');
           $('.date-dd').html(dateValue[2]);
           $('.date-year').html(dateValue[0]);
           $('.date-mon').html(dateValue[1]);
		
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

function loadXML() {
    ddd_now_ready=0;
	$.ajax({
    type: "post",
    url: "/app_xml/epgcidajax_r.ashx",
    dataType:"text",
    data: "date="+ddd_date+"&time="+ddd_time+"&cid="+ddd_cid,
    beforeSend: function(XMLHttpRequest){
    },
    success: function(data){
       $("#"+ddd_chid+" div.channel-list").html(data);        
       ddd_now=data;
       ddd_now_ready=1;
    },
    complete: function(XMLHttpRequest, textStatus){
    },
    error: function(){
        ddd_now_ready=1;
    }  
	});   
	$("#"+ddd_chid+" div.scroll-hor div.handle").css("left",300);
	$("#"+ddd_chid+" div.scroll-hor div.scroll-arrows").css("left",325)
	GetTimeLine();
	Getairdom(); 
}
function Getairdom()
{
    var date = ddd_date.split('-');
    var nextTimetmp = new Date(date[0],parseInt(date[1],10)-1,date[2],parseInt(ddd_time,10),0,0,0);
    var nextTime=Date.parse(nextTimetmp);    
    nextTimetmp.setHours(nextTimetmp.getHours()+4);    
    var nextTime2=Date.parse(nextTimetmp);
    var nowTime = new Date();
    nowTime=Date.parse(nowTime);
    var speed=2000;    
    if(nowTime>=  nextTime && nowTime<nextTime2)
    {
       var airleft=nowTime-nextTime;
       airleft=111.5+(184*(airleft/3600000));       
       $("#"+ddd_chid+" div.onair").css("left",111.5);
       $("#"+ddd_chid+" div.onair").css("display",'block'); 
       $("#"+ddd_chid+" div.onair").animate({left:airleft}, speed);
    }
    else
    {
        $("#"+ddd_chid+" div.onair").css("display",'none'); 
    }    
}
function Getairdom_settime()
{
    var date = ddd_date.split('-');
    var nextTimetmp = new Date(date[0],parseInt(date[1],10)-1,date[2],parseInt(ddd_time,10),0,0,0);
    var nextTime=Date.parse(nextTimetmp);     
    nextTimetmp.setHours(nextTimetmp.getHours()+4);    
    var nextTime2=Date.parse(nextTimetmp);
    var nowTime = new Date();
    nowTime=Date.parse(nowTime);
    var speed=500;
    if(nowTime>=  nextTime && nowTime<nextTime2)
    {
       var airleft=nowTime-nextTime;
       airleft=111.5+(184*(airleft/3600000));     
       $("#"+ddd_chid+" div.onair").css("display",'block'); 
       $("#"+ddd_chid+" div.onair").animate({left:airleft}, speed);
    }
    else
    {
        $("#"+ddd_chid+" div.onair").css("display",'none'); 
    } 
window.setTimeout("Getairdom_settime();",60000);   
}
function GetTimeLine()
{
    for (var i = 0; i < 4; i++)
    {
        var date = ddd_date.split('-');
        var tmpTime = new Date(date[0],parseInt(date[1],10)-1,date[2],parseInt(ddd_time,10),0,0,0);
        tmpTime.setHours(tmpTime.getHours()+i);        
        var timetp=tmpTime.getHours() > 9 ? tmpTime.getHours()  : "0" + tmpTime.getHours() ;
        var timetp1=timetp+":"+"00";
        var timetp2=timetp+":"+"30";
        $("li",$("#"+ddd_chid+" ul.times")).eq(2*i).text(timetp1);
        $("li",$("#"+ddd_chid+" ul.times")).eq(2*i+1).text(timetp2);
    }
    GetHorPos();
}

function GetHorPos()
{
    var speed=500;
    var horleft=(ddd_time*590/23)+137;
    $("#"+ddd_chid+" div.scroll-hor div.handle").animate({left:horleft}, speed);  
    $("#"+ddd_chid+" div.scroll-hor div.scroll-arrows").animate({left:horleft+25}, speed);      
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
        url: "/app_xml/epgitemajax_r.ashx",
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
        url: "/app_xml/epgitemajax_r.ashx",
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
function hide_float()
{
    $('div#float_r').hide();
    $('div#float_l').hide();
}