package cn.smgbb
{
	/*暂停广告，已弃用*/
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

	public class advPause extends Sprite{
		private var is_available:Boolean = false;
		private var ad_start:int = 0;
		private var ad_dur:int = 0;
		private var ad_repeat:int = 1;
		private var ad_image:String = "";
		private var ad_link:String = "http://www.smgbb.cn";
		private var ad_ld:Loader;
		private var pop_timer:Timer;
		private var unpop_timer:Timer;
		
		public static var is_shown:Boolean = false;
		
		public function advPause(_obj:Object) {
			if (_obj.starttime) {
				ad_start = int(_obj.starttime);//starting time in secs.
			}
			if (_obj.duration) {
				ad_dur = int(_obj.duration);//duration time in secs.
			}
			if (_obj.playcount) {
				ad_repeat = int(_obj.playcount);//times of repeat
			}
			if (_obj.onclick) {
				ad_link = String(_obj.onclick);//url of link
			}			
			if (_obj.content) {
				ad_image = String(_obj.content);//direction of image
			}else {
				trace("Error: need image url.")
				return;
			}
			
			init();
		}
		private function init() {
			pop_timer = new Timer(ad_start * 1000, ad_repeat);
			pop_timer.addEventListener(TimerEvent.TIMER, popAdv);
			pop_timer.start();
			
			unpop_timer = new Timer((ad_start + ad_dur) * 1000, 1);
			unpop_timer.addEventListener(TimerEvent.TIMER, unpopAdv);
			
			
			ad_ld = new Loader();
			ad_ld.contentLoaderInfo.addEventListener(Event.COMPLETE,imgComplete);
			ad_ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imgError);
			ad_ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,imgError);
			ad_ld.load(new URLRequest(ad_image));
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
		
		public function popAdv(e:TimerEvent) {
			if (is_available && !advPause.is_shown) {
				advPause.is_shown = true;
				addChild(ad_ld);
				unpop_timer.reset();
				unpop_timer.start();
				trace("pop up adv_pause");
			}else {
				trace("image is not ready yet.");
			}			
		}
		public function unpopAdv(e:TimerEvent) {
			if (advPause.is_shown) {
				advPause.is_shown = false;
				removeChild(ad_ld);
				unpop_timer.reset();
				trace("unpop up adv_pause");
			}
		}
	}
}