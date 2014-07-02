function get_liebiao(key,start,type)
{
    $.ajax({
        type: "get",
        url: "http://www1.bbtv.cn/d/search.ashx?callback=?",
        dataType: "json",
        data: "k="+key+"&s="+start+"&t="+type,
        beforeSend: function(XMLHttpRequest) {
        },
        success: function(data) {
           var lasthtml="";
           var count=data.Root.Count;
           count=parseInt(count);
           var countm=Math.ceil(count/10);
            if(countm==0) countm=1;
            MAXINDEX=countm;
            if(count==0){
                $("#title1").html("找不到和您的查询\""+decodeURIComponent(key)+"\"相符的视频"); 
                 $("ul.pages").html("");
                return;             
             }
           $("ul.pages li.total").html(MAXINDEX);         
           $("#title1").html("约有 "+count+" 项符合\""+decodeURIComponent(key)+"\"的查询结果");
           lasthtml="<ul class=\"show-list clearfix\">";
	   if(data.Root.Table.DocumentElement!=undefined){
           $(data.Root.Table.DocumentElement.fitctable).each(function(i){           
                var classpath = this.classpath;  
                if(classpath!="") classpath=classpath.replace(/&amp;lt;br&amp;gt;/g, "<br />").replace(/\\u000a/g, "<br />").replace(/\\/g, "");            
                var newspath = this.newspath;
                var id = this.id; 
                var title = this.title; 
                var titleurl="/"+classpath+"/"+newspath+"/"+id+".shtml"; 
                var bbtv_channelname=this.bbtv_channelname;
                var bbtv_type=this.bbtv_type;
                var titlepic=this.titlepic;
                if(titlepic!="")titlepic=titlepic.replace(/\\/g, ""); 
                var video_type=this.video_type;
                if(video_type=="1") titleurl="http://radio.bbtv.cn"+titleurl;
                else titleurl="http://www.bbtv.cn"+titleurl;
                lasthtml+="<li><div class=\"pic\"><div> <a target=\"bbtv_bfq\" href=\""+titleurl+"\"><img alt=\""+title+"\" src=\""+titlepic+"\" /></a></div></div><div class=\"txt\"><p class=\"tit\"><a target=\"bbtv_bfq\" href=\""+titleurl+"\">"+title+"</a><em>时间：<span class=\"gray6\">"+newspath+"</span></em></p><p>频道：<a target=\"bbtv_bfq\" href=\""+titleurl+"\">"+bbtv_channelname+"</a></p><p>类型：<a target=\"bbtv_bfq\" href=\""+titleurl+"\">"+bbtv_type+"</a></p></div></li>";      
           }); 
		   }
           lasthtml+="</ul>";
                 $("#dddeeee").html(lasthtml);           
                
        },
        complete: function(XMLHttpRequest, textStatus) {
        },
        error: function() {            
        }
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

 
