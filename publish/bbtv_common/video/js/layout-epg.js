$(document).ready(function(){
		$(".epgCon").pngFix();
		$(".time-line-sd").pngFix({
				sizingMethod: "crop"
		});
		$("div#float_r").pngFix({
				sizingMethod: "crop"
		});	
		$("div#float_l").pngFix({
				sizingMethod: "crop"
		});
                $('#dateinput').datepicker({
					dateFormat: 'yy-mm-dd',  
					prevText:'前一月',
					nextText:'后一月',
					currentText:' ',
					monthNames:['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
				});
	}
);
