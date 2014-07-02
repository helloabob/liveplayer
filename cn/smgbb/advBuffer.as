package cn.smgbb
{	
	/*缓冲广告，已弃用*/
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.utils.Timer;
	
	import gs.TweenLite;

	public class advBuffer extends Sprite{
		private var is_available:Boolean = false;
		private var ad_start:int = 0;
		private var ad_dur:int = 2;
		private var ad_repeat:int = 1;
		private var ad_image:String = "";
		private var ad_link:String = "http://www.smgbb.cn";
		private var ad_ld:Loader;
		private var pop_timer:Timer;
		private var unpop_timer:Timer;
		private var ad_arr:Array;
		
		public static var is_shown:Boolean = false;
		
		public function advBuffer() {
			ad_arr = [];
			ad_ld = new Loader();
			ad_ld.contentLoaderInfo.addEventListener(Event.COMPLETE,imgComplete);
			ad_ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imgError);
			ad_ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,imgError);

			//if (_obj.starttime) {
				//ad_start = int(_obj.starttime);//starting time in secs.
			//}
			//if (_obj.duration) {
				//ad_dur = int(_obj.duration);//duration time in secs.
			//}
			//if (_obj.playcount) {
				//ad_repeat = int(_obj.playcount);//times of repeat
			//}
			//if (_obj.onclick) {
				//ad_link = String(_obj.onclick);//url of link
			//}			
			//if (_obj.content) {
				//ad_image = String(_obj.content);//direction of image
			//}else {
				//trace("Error: need image url.")
				//return;
			//}

			
			//init();
		}
		private function init() {
			pop_timer = new Timer(ad_start * 1000, ad_repeat);
			pop_timer.addEventListener(TimerEvent.TIMER, popAdv);
			pop_timer.start();
			
			unpop_timer = new Timer((ad_start + ad_dur) * 1000, 1);
			unpop_timer.addEventListener(TimerEvent.TIMER, unpopAdv);
			
			
		}
		private function imgComplete(e:Event) {
			trace("imgComplete");
			is_available = true;
			addEventListener(MouseEvent.MOUSE_DOWN, imgDown);
		}
		private function imgDown(e:MouseEvent) {
			navigateToURL(new URLRequest(ad_link));
		}
		private function imgError(e:Event) {
			trace("fail to load image.");
		}
		public function addAdv(_xml:XML) {
			var _len:int = vidPlayer.CID_ARR.length;
			for (var i:int = 0; i < _len; i++) {
				switch(vidPlayer.CID_ARR[i]) {
					case int(String(_xml.attribute("id")).substring(3)):
						ad_arr[i] = { };
						ad_arr[i].duration = 2;
						ad_arr[i].playcount = 1;
						ad_arr[i].item_arr = [];
						ad_arr[i].id_arr = [];
						ad_arr[i].click_arr = [];
						//trace(_xml.config.attribute("duration"));
						if(_xml.config.attribute("duration")){
							//ad_arr[i].duration = int(String(_xml.config.attribute("duration")));							
						}
						if(_xml.config.attribute("playcount")){
							//ad_arr[i].playcount = int(String(_xml.config.attribute("playcount")));
						}
						for each(var _item in _xml.config.item) {
							ad_arr[i].id_arr.push(int(String(_item.attribute("id"))));
							ad_arr[i].item_arr.push(String(_item.attribute("content")));
							ad_arr[i].click_arr.push(String(_item.attribute("onclick")));
							//trace(String(_item.attribute("content")));
						}
						break;
					default:
						break;
				}
			}
			is_available = true;
		}
		public function popAdv(_id:int) {
			if (ad_arr[_id] == null||!is_available) {
				trace("fail to popAdv: " + _id + "?" + ad_arr[_id]);
				return;
			}
			if (!advBuffer.is_shown) {			
				trace("++++pop up adv_buffer++++");
				//var random_item:int= Math.ceil(Math.random() * ad_arr[_id].item_arr.length);
				ad_ld.load(new URLRequest(ad_arr[_id].item_arr[0]));	
				
				addChild(ad_ld);
				unpop_timer = new Timer(1000 * ad_arr[_id].duration, 1);
				unpop_timer.addEventListener(TimerEvent.TIMER, unpopAdv);
				unpop_timer.start();
				advBuffer.is_shown = true;
			}else {
				unpopAdv(new TimerEvent(TimerEvent.TIMER));
				popAdv(_id);
			}			
		}
		public function unpopAdv(e:TimerEvent) {
			if (advBuffer.is_shown) {
				advBuffer.is_shown = false;
				removeChild(ad_ld);
				unpop_timer.reset();
				trace("unpop up adv_buffer");
			}
		}
	}
}