$(document).ready(function(){
		$(".ch-nav").pngFix({
				sizingMethod: "crop"
		});
		$("div#float_r").pngFix({
				sizingMethod: "crop"
		});	
		$("div#float_l").pngFix({
				sizingMethod: "crop"
		});		
		$('#ch-tabs').tabs({
            select: function(event, ui) {
                ddd_index(ui.index);
                return true;
            }
            });
            
		_$("chnBar").style.height = _$("slider").clientHeight * Math.min(_$("chnContent").clientHeight / _$("chnContent").scrollHeight, 1) + "px";
        
        var chnsld = new Slider("slider", "chnBar","barup","bardown","mask", { Horizontal: false,
            MaxValue: _$("chnContent").scrollHeight - _$("chnContent").clientHeight,
            onMove: function(){ _$("chnContent").scrollTop = this.GetValue(); }
        });
        
        chnsld.WheelBind(_$("chnContent"));
        chnsld.KeyBind(_$("chnContent"));
		
		//重置tab内容display:block
		for(var i=2;i<19;i++)
		{
			$(((i>9)?"#ch0":"#ch00")+i).css({display:"inline"});	
		}
				//点击关闭
		$(".close").each(
			function(){
			$(this).bind("click", function(){
				$(this).parent().css({display:"none"});
			});
		} );
		
		
		//日历
         $('.dateinput').datepicker({
                   dateFormat: 'yy-mm-dd',  
                   prevText:'前一月',
                   nextText:'后一月',
                   currentText:' ',
                   monthNames:['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
         });
//日历容器3态
$(".date").mouseover(function(){ 
                   $(this).css({"background-position":"-1px -51px" });
                   }).mouseout(function(){
                   $(this).css({"background-position":"-1px 2px" });
                   }).click(function(){
                   $(this).css({"background-position":"-1px -102px" });
                   });              

		

			
	}
);


