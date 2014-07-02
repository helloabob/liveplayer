package cn.smgbb
{
	/*推荐的子项，已弃用*/
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.filters.BevelFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.external.ExternalInterface;
	public class recomItem extends Sprite
	{
		private var _item_id:int;
		private var title_str:String;
		private var chanl_str:String;
		private var img_url:String;
		private var link_url:String;//超链接
		private var time_str:String;
		private var des_txt:TextField;
		private var def_txt:TextField;
		private var def_fmt:TextFormat;
		private var bg_spt:Sprite;
		private var bg1_spt:Sprite;
		private var bg2_spt:Sprite;
		private var bg3_spt:Sprite;
		private var img_spt:Sprite;
		private var img_ld:Loader;
		
		private const IMG_WIDTH:int=80;//图片尺寸
		private const IMG_HEIGHT:int=60;
		private const IMG_MARGIN:int = 2;//图片边缘宽度
		private const ITEM_WIDTH:int = 326;
		private const ITEM_HEIGHT:int = 65;
		private const ITEM_COUND:int = 8;//圆角
		private const ITEM_MARGIN:int = 8;//补丁
	
		public var is_down:Boolean = false;
		public var ITEM_DOWN:String = "item_down";
		
		public function recomItem(_id:int, _title:String, _chanl:String, _img:String, _link:String, _timestamp:String) {
			_item_id = _id;
			title_str = _title;
			chanl_str = _chanl;
			
			img_url = _img.replace(/\$/g,"&");
			link_url = _link;
			time_str = _timestamp;
			init();
		}
		private function init() {			
			var _filter1:BevelFilter = new BevelFilter(1, 90, 0x000000, 1, 0xFFFFFF, 1, 1, 1, .3); 
			var _filter_arr:Array = new Array();
            _filter_arr.push(_filter1);
			
			bg1_spt = new Sprite();
			bg1_spt.graphics.beginFill(0x3F3F3F,1);//out
			bg1_spt.graphics.drawRoundRect(0, 0, ITEM_WIDTH, ITEM_HEIGHT, ITEM_COUND, ITEM_COUND);
			bg1_spt.graphics.endFill();
			
			bg2_spt = new Sprite();
			bg2_spt.graphics.beginFill(0x323232,1);//over
			bg2_spt.graphics.drawRoundRect(0, 0, ITEM_WIDTH, ITEM_HEIGHT, ITEM_COUND, ITEM_COUND);
			bg2_spt.graphics.endFill();
			
			bg3_spt = new Sprite();
			bg3_spt.graphics.beginFill(0x2C2C2C,1);//downs
			bg3_spt.graphics.drawRoundRect(0, 0, ITEM_WIDTH, ITEM_HEIGHT, ITEM_COUND, ITEM_COUND);
			bg3_spt.graphics.endFill();
			bg3_spt.filters = _filter_arr;
			
			bg_spt = new Sprite();
			bg_spt.addChild(bg1_spt);
			//bg_spt.addEventListener(MouseEvent.CLICK, itemClick);			
			addChild(bg_spt);
			
			img_spt = new Sprite();
			img_spt.x = ITEM_WIDTH - ITEM_MARGIN - IMG_WIDTH;
			img_spt.y = (ITEM_HEIGHT - IMG_HEIGHT) / 2;
			img_spt.graphics.beginFill(0xFFFFFF);
			img_spt.graphics.drawRect(0, 0, IMG_WIDTH, IMG_HEIGHT);
			img_spt.graphics.endFill();
			img_spt.graphics.beginFill(0x666666);
			img_spt.graphics.drawRect(IMG_MARGIN, IMG_MARGIN, IMG_WIDTH - IMG_MARGIN * 2, IMG_HEIGHT - IMG_MARGIN * 2);
			img_spt.graphics.endFill();
			addChild(img_spt);
			
			initText();			
			addEventListener(MouseEvent.MOUSE_OVER, itemOver);
			addEventListener(MouseEvent.MOUSE_OUT, itemOut);
			addEventListener(MouseEvent.CLICK, itemClick);
			
			if(img_url.indexOf("http://")>=0){
				img_ld=new Loader();
				img_ld.load(new URLRequest(img_url));
				img_ld.contentLoaderInfo.addEventListener(Event.COMPLETE, imgComplete);
			}
		}
		
		private function itemOver(e:MouseEvent):void{
			if (is_down) {
				return;
			}
			bg_spt.addChild(bg2_spt);
		}
		private function itemOut(e:MouseEvent):void{
			if (is_down) {
				return;
			}
			bg_spt.addChild(bg1_spt);
		}
		private function itemClick(e:MouseEvent):void{
			//is_down = true;
			//bg_spt.addChild(bg3_spt);
			//dispatchEvent(new Event(ITEM_DOWN));
			if (ExternalInterface.available) {
				ExternalInterface.call("open",link_url);
			}
		}
		private function initText() {
			def_fmt = new TextFormat();
			def_fmt.font = "Verdana";
			def_fmt.align = TextFormatAlign.CENTER;
			def_fmt.size = 12;
			def_fmt.bold = true;
			def_fmt.color = 0xFFFFFF;
			
			def_txt = new TextField();
			def_txt.mouseEnabled = false;
			def_txt.x = IMG_MARGIN;			
			def_txt.width = IMG_WIDTH - IMG_MARGIN * 2;
			def_txt.height = IMG_HEIGHT - IMG_MARGIN * 2;
			def_txt.autoSize = TextFieldAutoSize.CENTER;
			def_txt.text = "loading";
			def_txt.setTextFormat(def_fmt);
			def_txt.y = (IMG_HEIGHT-def_txt.height)/2+2;
			img_spt.addChild(def_txt);
			
			des_txt = new TextField();
			des_txt.x = 6;
			des_txt.y = 2;
			des_txt.width = 230;
			des_txt.mouseEnabled = false;
			des_txt.multiline = true;
			des_txt.wordWrap = true;
			
			var datestring: String;
			var d:Date = new Date(new Number(time_str+"000"));
			datestring = d.getMonth()+"月"+d.getDate()+"日 "+d.getHours()+":"+parseDateFormat(d.getMinutes());
			
			des_txt.htmlText = "<FONT COLOR='#CCCCCC'><b>" + title_str + "</b></FONT><br/>"
						+ "<FONT COLOR='#666666'>频道：</FONT><FONT COLOR='#999999'>" + chanl_str + "</FONT>"
						+ "<br /><FONT COLOR='#666666'>播出时间：</FONT><FONT COLOR='#999999'>" + datestring + "</FONT>";
			addChild(des_txt);
		}
		private function parseDateFormat(d:Number):String
		{
			return d>9?d+"":"0"+d;
		}
		private function imgComplete(e:Event) {
			img_ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgComplete);
			img_ld.x = IMG_MARGIN;
			img_ld.y = IMG_MARGIN;
			img_spt.removeChild(def_txt);
			img_ld.scaleX = IMG_WIDTH / img_ld.width;
			img_ld.scaleY = img_ld.scaleX;
			var _mask:Sprite = new Sprite();
			_mask.graphics.beginFill(0xFF0000,0.2);
			_mask.graphics.drawRect(IMG_MARGIN, IMG_MARGIN, IMG_WIDTH-IMG_MARGIN*2, IMG_HEIGHT-IMG_MARGIN*2);
			_mask.graphics.endFill();			
			img_spt.addChild(img_ld);
			img_spt.addChild(_mask);
			img_ld.mask = _mask;
		}
		public function setOut() {
			is_down = false;
			bg_spt.addChild(bg1_spt);
		}
		public function get item_id():int {
			return _item_id;
		}
	}
	
}