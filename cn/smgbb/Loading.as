package cn.smgbb
{
	/*加载时显示的loading*/
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.Sprite;
	import flash.utils.Timer;
	
	public class Loading extends Sprite
	{
		private var ld_x:int = 16;//
		private var ld_height:int = 1;//线条高度
		private var ld_timer_dur:int = 40;//40ms刷新间隔
		private var ld_timer_total:int = 0;//总消耗时间
		private var ld_timer_fix:int = 1000;//修正系数，越大增长越慢
		private var txt_color:uint;
		private var ld_len:Number;
		private var txt_val:String;
		private var ld_spt:Sprite;
		private var ld_txt:TextField;
		private var ld_timer:Timer;
		
		public function Loading(_len:Number = 100, _txt:String = "正在装载...", _color:uint=0xFFFFFF) {
			ld_len = Math.abs(_len - 2 * ld_x);//loading 形状的长度
			txt_val = _txt;//显示文本
			txt_color = _color;//颜色
			init();
		}
		
		private function init() {
			initText();
			initSpt();
			
			ld_timer = new Timer(ld_timer_dur);
			ld_timer.addEventListener(TimerEvent.TIMER, ldTimer);
			ld_timer.start();
		}
		private function initText() {
			var txt_fmt:TextFormat = new TextFormat();
			txt_fmt.align = TextFormatAlign.LEFT;
			txt_fmt.color = txt_color;
			
			ld_txt = new TextField();
			ld_txt.x = ld_x;
			ld_txt.y = 4;
			ld_txt.text = txt_val;
			ld_txt.autoSize = TextFieldAutoSize.LEFT;
			ld_txt.setTextFormat(txt_fmt);
			
			addChild(ld_txt);
		}
		private function initSpt() {
			ld_spt = new Sprite();
			ld_spt.graphics.beginFill(txt_color);
			ld_spt.graphics.drawRect(0, 0, 1, ld_height);
			ld_spt.graphics.endFill();
			ld_spt.x = ld_x;
			ld_spt.y =ld_txt.y+ ld_txt.height+1;
			
			addChild(ld_spt);
		}
		private function ldTimer(e:TimerEvent) {
			ld_timer_total += ld_timer_dur;
			ld_spt.width= Math.atan(ld_timer_total/ld_timer_fix) * 2 * ld_len / Math.PI;
			e.updateAfterEvent();
		}
		public function resetLoading() {
			ld_timer.reset();
			ld_timer_total = 0;
			ld_spt.width = 1;
			ld_timer.start();
		}
	}
	
}