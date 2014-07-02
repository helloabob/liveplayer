package cn.smgbb
{
	/*文字滚动广告，已弃用*/
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.text.TextField;
	public class scrollText extends Sprite
	{
		private var bg_width:int = 537;
		private var bg_height:int = 17;
		private var bg_round:int = 6;
		private var btn_radius:int = 6;
		private var bg_spt:Sprite;
		private var static_txt:TextField;
		private var close_btn:closeBtn;
		
		public const CLOSE_SCROLL_TEXT:String = "close_scroll_text";
		public function scrollText(_width:int = 537, _height:int = 17) {
			bg_height = _width;
			bg_height = _height;
			init();
		}
		private function init() {
			bg_spt = new Sprite();
			bg_spt.graphics.beginFill(0x808080, .5);
			bg_spt.graphics.lineStyle(1, 0x666666);
			bg_spt.graphics.drawRoundRect(0, 0, bg_width, bg_height, bg_round,bg_round);
			bg_spt.graphics.endFill();
			addChild(bg_spt);
			
			close_btn = new closeBtn(btn_radius, 0x333333, 0xA0A0A0, 0xFFFFFF, 1);
			close_btn.x = close_btn.y = (bg_height - btn_radius*2) / 2;
			close_btn.addEventListener(MouseEvent.CLICK, closeClick);
			addChild(close_btn);
			
			static_txt = new TextField();
			static_txt.textColor = 0xCCCCCC;
			static_txt.text = "滚动新闻：";
			static_txt.autoSize = "left";
			static_txt.mouseEnabled = false;
			static_txt.x = close_btn.x + close_btn.width + 3;
			static_txt.y = (bg_height - static_txt.height) / 2;
			addChild(static_txt);
		}
		private function closeClick(e:MouseEvent) {
			dispatchEvent(new Event(CLOSE_SCROLL_TEXT));
		}
	}
	
}