package cn.smgbb
{
	/*相关推荐的类，已弃用*/
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.system.Security;
	import cn.smgbb.scrollBar;
	import cn.smgbb.recomItem;
	import cn.smgbb.Loading;
	
	public class Recom extends Sprite
	{	
		private var num_item:int = 0;
		private var recom_dir:String = "/bbtv_common/bbtv_flash/";
		private var recom_xml:String = "recom_test.xml";
		private var recom_ld:URLLoader;
		private var bg_spt:Sprite;
		private var recom_spt:Sprite;
		private var recom_msk:Sprite;
		private var title_arr:Array;
		private var chanl_arr:Array;
		private var image_arr:Array;
		private var link_arr:Array;
		private var time_arr:Array;
		private var recom_lding:Loading;

		private const ITEM_WIDTH:int = 326;
		private const ITEM_HEIGHT:int = 65;
		private const ITEM_PACE:int = 8;//间隔距离
		private const ITEM_SHOWN:int = 6;//可显示的item数
		private const ITEM_Y:int = 4;//初始坐标
		
		//for scroll_bar
		private var scroll_ui:String = vidPlayer.UI_DIR+"ScrollUI.swf?t="+Math.random();
		private var dragger:SimpleButton;
		private var dragger_slide:Sprite;
		private var scroll_spt:Sprite;
		private var dragger_sprite:Sprite;
		private const SCROLL_TOP:int = 0;
		private const SCROLL_X:int = 0;
		private const SCROLL_HEIGHT:int = 447;
		private const SCROLL_DRAGGER_HEIGHT:int = 64;
		
		public function Recom() {
			init();
		}
		private function init() {
			Security.allowDomain("*");
			bg_spt = new Sprite();
			bg_spt.x = 0;
			bg_spt.y = 0;
			bg_spt.graphics.beginFill(0x121212, 1);
			bg_spt.graphics.drawRect(0, 0, 352, SCROLL_HEIGHT);
			bg_spt.graphics.endFill();
			//addChild(bg_spt);
			
			recom_msk = new Sprite();
			recom_msk.x = 8;
			recom_msk.y = ITEM_Y;
			recom_msk.graphics.beginFill(0x000000, 0);
			recom_msk.graphics.drawRect(0, 0, ITEM_WIDTH, ITEM_SHOWN*(ITEM_HEIGHT+ITEM_PACE));
			recom_msk.graphics.endFill();
			addChild(recom_msk);
			
			recom_lding = new Loading(vidPlayer.PANEL_WIDTH);
			addChild(recom_lding);
			
			//recom_ld = new URLLoader();
//			recom_ld.addEventListener(Event.COMPLETE, recomComplete);
//			recom_ld.addEventListener(SecurityErrorEvent.SECURITY_ERROR, recomError);
//			recom_ld.addEventListener(IOErrorEvent.IO_ERROR, recomError);
			//recom_ld.load(new URLRequest(recom_dir+recom_xml));
		}
		private function recomComplete(e:Event) {
			var _str:String = e.target.data.toString();
			var my_index1=_str.lastIndexOf("<root>");
			var my_index2=_str.lastIndexOf("</root>");
			if ((my_index2!=-1)&&(my_index1!=-1)&&(my_index1<my_index2)) {
				_str=_str.substring(my_index1,my_index2+String("</root>").length);
			} else {
				trace("Failed to parse recom.xml.");
				return;
			}
			var _xml:XML = new XML(_str);
			
			var _node:XMLList = _xml.item;
			num_item = _node.length();			
			recom_spt = new Sprite();
			recom_spt.x = 8;
			recom_spt.y = ITEM_Y;
			recom_spt.graphics.beginFill(0xFFFFFF, 0);
			recom_spt.graphics.drawRect(0, 0, ITEM_WIDTH, num_item*(ITEM_HEIGHT+ITEM_PACE));
			recom_spt.graphics.endFill();
			addChild(recom_spt);
			recom_spt.mask = recom_msk;
			for (var i:int = 0; i < num_item; i++) {
				var _item:recomItem = new recomItem(i, _node[i].title, _node[i].channel, _node[i].image, _node[i].link, "");
				_item.name = "item" + i;
				_item.y = ITEM_PACE / 2 + i * (ITEM_PACE+ITEM_HEIGHT);
				recom_spt.addChild(_item);
			}		
			
			if(num_item>ITEM_SHOWN){
				initScroll();
			}
		}
		private function initScroll() {
			scroll_spt = new Sprite();//放置整个scroll_bar
			dragger_sprite = new Sprite();//放置dragger
			var _url:URLRequest=new URLRequest(scroll_ui);
			var _loader:Loader=new Loader();
			_loader.load(_url);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,scrollComplete);
		}
		private function scrollComplete(e:Event) {
			var _class1:Class=e.target.content.slide_mc.constructor  as  Class;
			var _class2:Class=e.target.content.glide_btn.constructor  as  Class;
			dragger_slide=new _class1();
			dragger=new _class2();
			dragger.addEventListener(MouseEvent.MOUSE_DOWN, draggerDown);
			scroll_spt.x=bg_spt.x + bg_spt.width - dragger_slide.width;
			scroll_spt.y=bg_spt.y;
			dragger_slide.height=SCROLL_HEIGHT;
			dragger_sprite.addChild(dragger);
			scroll_spt.addChild(dragger_slide);
			scroll_spt.addChild(dragger_sprite);
			addChild(scroll_spt);
		}
		private function draggerDown(e:MouseEvent) {
			e.target.stage.addEventListener(MouseEvent.MOUSE_UP, draggerUp);
			e.target.stage.addEventListener(MouseEvent.MOUSE_MOVE, draggerMove);
			var _rec:Rectangle = new Rectangle(SCROLL_X, SCROLL_TOP, 0,SCROLL_HEIGHT-SCROLL_DRAGGER_HEIGHT);
			dragger_sprite.startDrag(false, _rec);
		}
		private function draggerUp(e:MouseEvent) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, draggerMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, draggerUp);
			dragger_sprite.stopDrag();
		}
		private function draggerMove(e:MouseEvent) {
			var _offset:Number = (dragger_sprite.y - SCROLL_TOP)* (num_item - ITEM_SHOWN) * (ITEM_HEIGHT + ITEM_PACE) / (SCROLL_HEIGHT-SCROLL_DRAGGER_HEIGHT);
			recom_spt.y = ITEM_Y - _offset;
		}
		private function itemDown(e:Event) {
			var _num:int = recom_spt.numChildren;
			var _id:int = e.currentTarget.item_id;
			for (var i = 0; i < _num; i++) {
				if (i != _id) {
					recom_spt.getChildAt(i).setOut();
				}
			}
		}
		private function scrollError(e:Event) {
			trace("Failed to load scroll_ui");
		}
		private function recomError(e:Event) {
			trace("Failed to load recom.xml");
		}
		public function setRecom(_obj:Object) {
			if(contains(recom_lding)){
				removeChild(recom_lding);
			}
			var _str:String;
			title_arr = [];
			chanl_arr = [];
			image_arr = [];
			link_arr = [];
			time_arr = [];
			if (_obj.bbtv_recom_title) {
				_str = _obj.bbtv_recom_title;
				title_arr = _str.split("|");
			}
			if (_obj.bbtv_recom_channel) {
				_str = _obj.bbtv_recom_channel;
				chanl_arr = _str.split("|");
			}
			if (_obj.bbtv_recom_image) {
				_str = _obj.bbtv_recom_image;
				image_arr = _str.split("|");
			}			
			if (_obj.bbtv_recom_link) {
				_str = _obj.bbtv_recom_link;
				link_arr = _str.split("|");
			}
			if (_obj.bbtv_recom_time) {
				_str = _obj.bbtv_recom_time;
				time_arr = _str.split("|");
			}
			num_item = Math.min(title_arr.length, chanl_arr.length, image_arr.length, link_arr.length);
			recom_spt = new Sprite();
			recom_spt.x = 8;
			recom_spt.y = ITEM_Y;
			recom_spt.graphics.beginFill(0xFFFFFF, 0);
			recom_spt.graphics.drawRect(0, 0, ITEM_WIDTH, num_item*(ITEM_HEIGHT+ITEM_PACE));
			recom_spt.graphics.endFill();
			addChild(recom_spt);
			recom_spt.mask = recom_msk;
			for (var i:int = 0; i < num_item; i++) {
				var _item:recomItem = new recomItem(i, title_arr[i],chanl_arr[i],image_arr[i],link_arr[i],time_arr[i]);
				_item.name = "item" + i;
				_item.y = ITEM_PACE / 2 + i * (ITEM_PACE + ITEM_HEIGHT);
				_item.addEventListener(_item.ITEM_DOWN, itemDown);
				recom_spt.addChild(_item);
			}
			if(num_item>ITEM_SHOWN){
				initScroll();
			}
		}
	}
	
}