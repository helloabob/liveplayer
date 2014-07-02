function get_liebiao(classid,start)
{
    $.ajax({
        type: "get",
        url: "http://www1.bbtv.cn/d/clickph.ashx?callback=?",
        dataType: "json",
        data: "c="+classid+"&s="+start,
        beforeSend: function(XMLHttpRequest) {
        },
        success: function(data) {
           var lasthtml="";
		   if(data.DocumentElement!=undefined){
           $(data.DocumentElement.fitctable).each(function(i){           
                var classpath = this.classpath;  
                classpath=classpath.replace(/&amp;lt;br&amp;gt;/g, "<br />").replace(/\\u000a/g, "<br />").replace(/\\/g, "");            
                var newspath = this.newspath;
                var id = this.id; 
                var title = this.title; 
                var titleurl="/"+classpath+"/"+newspath+"/"+id+".shtml"; 
                var bbtv_channelname=this.bbtv_channelname;
                var bbtv_type=this.bbtv_type;
                var titlepic=this.titlepic.replace(/\\/g, ""); 
                lasthtml+="<li><div class=\"pic\"><div> <a href=\""+titleurl+"\"><img alt=\""+title+"\" src=\""+titlepic+"\" /></a></div></div><div class=\"txt\"><p class=\"tit\"><a target=\"_blank\" href=\""+titleurl+"\">"+title+"</a><em>时间：<span class=\"gray6\">"+newspath+"</span></em></p><p>频道：<a target=\"_blank\" href=\""+titleurl+"\">"+bbtv_channelname+"</a></p><p>类型：<a target=\"_blank\" href=\""+titleurl+"\">"+bbtv_type+"</a></p></div></li>";      
           }); 
		   }
           
           $("ul#liebiao").html(lasthtml);
                
        },
        complete: function(XMLHttpRequest, textStatus) {
        },
        error: function() {            
        }
    });
}
function get_class_info(classid,type)
{
    $.getJSON("http://www1.bbtv.cn/d/classinfo.ashx?callback=?", {c:classid,t:type}, function(s) {
        var classname=s.Root.classname;
        var classpath=s.Root.classpath.replace(/\\/g, "");
        var count=s.Root.count;
        count=parseInt(count);
        if(count==0) count=1;
        classpath="/"+classpath;
        MAXINDEX=count;
        document.title=classname+"-视频";
        if(type==1)
        {
            var bclassnme=s.Root.bclass.replace(/\\/g, "");
            var bclasspath="/"+s.Root.bclasspath.replace(/\\/g, "");
            $("#d_title1").append("<li><a href=\""+bclasspath+"\">"+bclassnme+"</a></li><li>"+classname+"</li>");
            $("#d_title2").html(classname+"列表");
        }
        else
        {
            $("#d_title1").append("<li>"+classname+"</li>");
            $("#d_title2").html(classname+"视频列表");
        }
        
        
        $("ul.filter-list li:eq(0)").html("<a href=\""+classpath+"\">最近更新</a>");
        $("ul.pages li.total").html(count);        
    });
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

 
