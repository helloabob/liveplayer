var ddd_cid=216;
function parseQuery(query) {
   var Params = new Object ();
   if ( ! query ) return Params; 
   var Pairs = query.split(/[;&]/);
   for ( var i = 0; i < Pairs.length; i++ ) {
      var KeyVal = Pairs[i].split('=');
      if ( ! KeyVal || KeyVal.length != 2 ) continue;
      var key = unescape( KeyVal[0] );
      var val = unescape( KeyVal[1] );
      val = val.replace(/\+/g, ' ');
      Params[key] = val;
   }
   return Params;
}
function getQueryStringRegExp(param)
{
 var query = location.search;
 var iLen = param.length;
 var iStart = query.indexOf(param);
 if (iStart == -1)
  return "";
 iStart += iLen + 1;
 var iEnd = query.indexOf("&", iStart);
 if (iEnd == -1)
  return query.substring(iStart);
 return query.substring(iStart, iEnd);
}
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
function ChangeSelectItemByValue(cid) { 
    getObject("sel-channel").value=cid;
    $('form.jNice').jNice();       
} 
function gettodayselect(){
    var date_re=getQueryStringRegExp('date');
    if(date_re=="")
    {var tmpTime=new Date();date_re=tmpTime.getFullYear()+"-"+(tmpTime.getMonth()+1)+"-"+(tmpTime.getDate());} 
    /* var days = new Array("日","一","二","三","四","五","六");            
    for(var i=0;i<15;i++)
    {
        var tmpTime=new Date();
        tmpTime.setDate(tmpTime.getDate()+i-7);
        var tmpDatevalue=tmpTime.getFullYear()+"-"+(tmpTime.getMonth()+1)+"-"+(tmpTime.getDate());
        var tmpDatetxt=(tmpTime.getMonth()+1)+"月"+(tmpTime.getDate())+"日 星期"+days[tmpTime.getDay()];        
        if(i==6){if(tmpDatevalue==date_re) {tmpDatetxt="【昨天】 "+tmpDatetxt;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"' selected>"+tmpDatetxt+"</option>");} else {tmpDatetxt="【昨天】 "+tmpDatetxt;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"'>"+tmpDatetxt+"</option>");}}
        else if(i==7) {if(tmpDatevalue==date_re) {tmpDatetxt="【今天】 "+tmpDatetxt;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"' selected>"+tmpDatetxt+"</option>");} else {tmpDatetxt="【今天】 "+tmpDatetxt;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"'>"+tmpDatetxt+"</option>"); }}
        else if(i==8) {if(tmpDatevalue==date_re) {tmpDatetxt="【明天】 "+tmpDatetxt;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"' selected>"+tmpDatetxt+"</option>"); }else{ tmpDatetxt="【明天】 "+tmpDatetxt;$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"'>"+tmpDatetxt+"</option>");}}
        else{ if(tmpDatevalue==date_re)$("select[name=sel-date]").append("<option value='"+tmpDatevalue+"' selected>"+tmpDatetxt+"</option>"); else $("select[name=sel-date]").append("<option value='"+tmpDatevalue+"'>"+tmpDatetxt+"</option>"); }
    }
    */
    var date = date_re.split('-');
    var nowMonth= parseInt(date[1],10);
    var nowDate=parseInt(date[2],10);
    $("input##dateinput").val(date[0]+"-"+(nowMonth>9?nowMonth:"0"+nowMonth)+"-"+(nowDate>9?nowDate:"0"+nowDate));
    
    var nowTime = new Date();
    //nowTime.setHours(nowTime.getHours()-1);
    var nowHour=nowTime.getHours();
    for (var i = 0; i < 24; i++)
    {
        if(nowHour!=i)
        $("select[name=sel-time]").append("<option value='"+i+"'>"+(i > 9 ? i : "0" + i)+":00</option>"); 
        else
        $("select[name=sel-time]").append("<option value='"+i+"' selected>"+(i > 9 ? i : "0" + i)+":00</option>"); 
    }
}
function LoadtxtXMLtime()
{
    var tmpid=getObject("sel-channel").value;
    var tmpdate=getObject("sel-date").value;
    var tmptime=getObject("sel-time").value;
    var tmplink="EPG-txt.shtml?cid="+tmpid+"&date="+tmpdate+"#"+tmptime;
    window.location.href=tmplink;
}
function LoadtxtXML()
{
    var ddd_date=getQueryStringRegExp('date');
    ddd_cid=getQueryStringRegExp('cid');
    if(ddd_date=="")
    {var tmpTime=new Date();ddd_date=tmpTime.getFullYear()+"-"+(tmpTime.getMonth()+1)+"-"+(tmpTime.getDate());} 
    if(ddd_cid=="")ddd_cid=216;
    //ChangeSelectItemByValue(ddd_cid);
    $.ajax({
    type: "post",
    url: "/app_xml/epgtxtajax.ashx",
    dataType:"xml",
    data: "date="+ddd_date+"&cid="+ddd_cid,
    beforeSend: function(XMLHttpRequest){
    },
    success: function(xml){
        var lxid=$("root", xml).attr("id");   
        $("#ddd_sx li").each(function(id){
            if(id==lxid)
                $(this).addClass("selected");
        });     
        $("#ddd_sx a").each(function(id){
            if(id==lxid)
                $(this).addClass("selected");
            var tmpid=$(this).attr("ddd");
            var tmplink="EPG-txt.shtml?cid="+tmpid+"&date="+ddd_date;
            $(this).attr("href",tmplink);
        });
        var channelname=$("root", xml).attr("name");
        var lefthtml="";
        var righthtml="";       
        $("item", xml).each(function(id) {
        var title=$(this).children("title").text(); 
        var time=$(this).children("time").text();        
        var url=$(this).children("url").text();       
        var type=$(this).children("type").text();
        var timetype=$(this).children("timetype").text(); 
        
        if(timetype=="0")
        {
            if(type=="0")
                lefthtml+="<div class=\"inner\"><h3 class=\"passed\"><em>"+time+"</em>"+title+"<span>[<a href=\""+url+"\">播放</a>]</span></h3><p></p></div>";
            else if(type=="1")
                lefthtml+="<div class=\"inner\"><h3 class=\"crt\"><em>"+time+"</em>"+title+"<span>[<a href=\""+url+"\">正在直播</a>]</span></h3><p></p></div>";
            else
                lefthtml+="<div class=\"inner\"><h3><em>"+time+"</em>"+title+"<span></span></h3><p></p></div>";              
        
        }
        else
        {
            if(type=="0")
                righthtml+="<div class=\"inner\"><h3 class=\"passed\"><em>"+time+"</em>"+title+"<span>[<a href=\""+url+"\">播放</a>]</span></h3><p></p></div>";
            else if(type=="1")
                righthtml+="<div class=\"inner\"><h3 class=\"crt\"><em>"+time+"</em>"+title+"<span>[<a href=\""+url+"\">正在直播</a>]</span></h3><p></p></div>";
            else
                righthtml+="<div class=\"inner\"><h3><em>"+time+"</em>"+title+"<span></span></h3><p></p></div>";
        
        }
        
        
       }); 
       $("#day").append(lefthtml);
       $("#night").append(righthtml);
    },
    complete: function(XMLHttpRequest, textStatus){
    },
    error: function(){
    }  
	});   
}
$(document).ready(function(){
   $("#epg_look").click(function(){ 
        LoadtxtXMLtime();
    });   
    $('#dateinput').datepicker({
					dateFormat: 'yy-mm-dd',  
					prevText:'前一月',
					nextText:'后一月',
					currentText:' ',
					monthNames:['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
				});   
});
function sel_time_change()
{
    var tmptime=getObject("sel-time").value;
    /*var strUrl = document.URL.toLowerCase();
    var slappos=strUrl.lastIndexOf('#');
    if(slappos!=-1) strUrl=strUrl.substring(0,slappos);*/
    window.location="#"+tmptime;
}
function sel_date_change()
{
    var tmpdate=$("#dateinput").val();
    //var tmptime=getObject("sel-time").value;
    var tmplink="EPG-txt.shtml?cid="+ddd_cid+"&date="+tmpdate;
    window.location.href=tmplink;    
}

