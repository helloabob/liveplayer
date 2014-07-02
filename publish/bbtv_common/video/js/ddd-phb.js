var aphb = $("ul.topnews");
if(aphb.length>0)
{
    $.ajax({
        type: "get",
        url: "http://www1.bbtv.cn/d/phb.ashx?callback=?",
        dataType: "json",
        data: "t="+xg_type,
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
					var id = this.id; 
					var title = this.title; 
					var titleurl="/"+classpath+"/"+newspath+"/"+id+".shtml";                
					lasthtml+="<li><a target=\"bbtvbfq\" title=\""+title+"\" class=\"rk"+(i+1)+"\" href=\""+titleurl+"\">"+title+"</a> </li>";       
			   }); 
		   }
           
           $("ul.topnews").html(lasthtml);
                
        },
        complete: function(XMLHttpRequest, textStatus) {
        },
        error: function() {            
        }
    });    
}
