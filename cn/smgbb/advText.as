package cn.smgbb
{
	/*文字广告，已弃用*/
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.display.Sprite;
	import flash.utils.Timer;
	
	import gs.TweenLite;

	public class advText extends Sprite {	
		private var is_available:Boolean = false;
		private var ad_repeat:int = 1;
		private var cur_ad:int = 0;//当前播放的广告序列
		private var total_ad:int = 0; //广告总数
		private var scroll_dur:int = 20;
		private var inter_timer_dur:int=2*1000;
		private var round_timer_dur:int=30*1000;
		private var scroll_step:Number = 1;
		private var ad_content:String="";
		private var ad_link:String = "http://www.smgbb.cn";
		private var adv_obj_arr:Array;
		private var ad_hit:Sprite;
		private var ad_txt:TextField;
		private var ad_fmt:TextFormat;
		private var pop_timer:Timer;
		private var start_timer:Timer;
		private var scroll_timer:Timer;	
		private var round_timer:Timer;//每大回合定时，如30分钟
		private var inter_timer:Timer;//广告之间的时间定时，如2分钟
		
		private const VIDEO_WIDTH:int = 544;
		private const VIDEO_HEIGHT:int = 408;

		
		public static var is_shown:Boolean = false;
		
		public function advText(_xml:XML) {
			if (_xml.attribute("roundinter").toString()) {
				round_timer_dur = int(_xml.attribute("roundinter")) * 60 * 1000;
			}
			if (_xml.attribute("playcount").toString()) {
				ad_repeat =int(_xml.attribute("playcount").toString());
			}
			if (_xml.attribute("iteminter").toString()) {
				inter_timer_dur = int(_xml.attribute("iteminter").toString())*60*1000;
			}
			if (ad_repeat > 1) {
				round_timer = new Timer(round_timer_dur, ad_repeat - 1);
				round_timer.addEventListener(TimerEvent.TIMER, roundTimer);
				round_timer.start();
			}
			inter_timer = new Timer(inter_timer_dur,1);
			inter_timer.addEventListener(TimerEvent.TIMER, interTimer);
			
			var sub_node:XMLList = _xml.item;		
			adv_obj_arr = [];
			total_ad = 0;
			for each(var sub_item in sub_node) {
				var sub_obj:Object = { };
				sub_obj["id"]=sub_item.attribute("id");
				sub_obj["content"]=sub_item.attribute("content");
				sub_obj["onclick"]=sub_item.attribute("onclick");
				adv_obj_arr.push(sub_obj);
			}
			total_ad = adv_obj_arr.length;//
			
			init();
		}
		private function init() {
			ad_fmt = new TextFormat();
			ad_fmt.size = 14;
			ad_fmt.bold = true;
			ad_fmt.color = 0xFFFFFF;
			
			ad_txt = new TextField();	
			ad_txt.mouseEnabled = false;
			ad_txt.wordWrap = false;
			ad_txt.autoSize = TextFieldAutoSize.LEFT;
			
			ad_hit = new Sprite();
			ad_hit.graphics.beginFill(0x000000, 0.4);
			ad_hit.graphics.drawRect(0, 0, VIDEO_WIDTH,20);
			ad_hit.graphics.endFill();
			ad_hit.addEventListener(MouseEvent.MOUSE_DOWN, txtDown);
			ad_hit.addEventListener(MouseEvent.MOUSE_OVER, txtOver);
			ad_hit.addEventListener(MouseEvent.MOUSE_OUT, txtOut);
			ad_hit.mouseEnabled = false;
			ad_hit.buttonMode = true;
			addChild(ad_hit);
		
			is_available = true;
			interTimer(new TimerEvent(TimerEvent.TIMER));
		}
		private function roundTimer(e:TimerEvent) {
			interTimer(new TimerEvent(TimerEvent.TIMER));
		}
		private function interTimer(e:TimerEvent) {
			initText();
			advText.is_shown = true;
			ad_hit.mouseEnabled = true;

			scroll_timer = new Timer(scroll_dur);
			scroll_timer.addEventListener(TimerEvent.TIMER, scrollAdv);
			scroll_timer.start();
		}
		private function initText() {
			ad_txt.x = VIDEO_WIDTH;
			ad_txt.text = adv_obj_arr[cur_ad].content;
			ad_txt.autoSize = TextFieldAutoSize.LEFT;
			ad_txt.setTextFormat(ad_fmt);
			addChild(ad_txt);
		}
		private function startAdv(e:TimerEvent) {
			popAdv(new TimerEvent(TimerEvent.TIMER));
			pop_timer.reset();
			pop_timer.start();
		}
		private function scrollAdv(e:TimerEvent) {
			if (ad_txt.x < -ad_txt.width) {
				unpopAdv();
				return;
			}
			ad_txt.x -= scroll_step;
			//ad_hit.x -= scroll_step;
			e.updateAfterEvent();
		}
		private function txtDown(e:MouseEvent) {
			navigateToURL(new URLRequest(adv_obj_arr[cur_ad].onclick));
		}
		private function txtOver(e:MouseEvent) {
			scroll_timer.stop();
		}
		private function txtOut(e:MouseEvent) {
			scroll_timer.start();
		}
		
		public function popAdv(e:TimerEvent) {
			if (is_available && !advText.is_shown) {
				advText.is_shown = true;
				ad_txt.x = VIDEO_WIDTH;
				ad_hit.mouseEnabled = true;
				addChild(ad_txt);
				scroll_timer.reset();
				scroll_timer.start();
			}else {
				trace("is not available now.");
			}			
		}
		public function unpopAdv() {
			if (advText.is_shown) {
				scroll_timer.reset();
				removeChild(ad_txt);
				ad_hit.mouseEnabled = false;
				advText.is_shown = false;
				inter_timer.reset();
				inter_timer.start();
				cur_ad++;
				if (cur_ad >= total_ad) {
					cur_ad = 0;
					inter_timer.reset();
				}
			}
		}
	}
}