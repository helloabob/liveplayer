$(document).ready(
	function(){
		inputTipText();    //直接调用就OK了
	}
);

function inputTipText(){ 
$("input[class*=grayTips]") //所有样式名中含有grayTips的input
.each(function(){
   var oldVal=$(this).val();     //默认的提示性文本
   $(this)
   .css({"color":"#888"})     //灰色
   .focus(function(){
    if($(this).val()!=oldVal){$(this).css({"color":"#000"})}else{$(this).val("").css({"color":"#878787"})}
   })
   .blur(function(){
    if($(this).val()==""){$(this).val(oldVal).css({"color":"#878787"})}
   })
   .keydown(function(){$(this).css({"color":"#000"})})
  
})
}

