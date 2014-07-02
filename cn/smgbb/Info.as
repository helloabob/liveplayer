package cn.smgbb
{
	/*节目详细信息面板，已弃用*/
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
	import cn.smgbb.scrollBar;
	import cn.smgbb.Loading;
	public class Info extends Sprite
	{		
		private var info_dir:String = "/bbtv_common/bbtv_flash/";
		private var info_xml:String = "info_test.xml";
		private var info_txt:TextField;
		private var info_fmt:TextFormat;
		private var info_ld:URLLoader;
		private var info_spt:Sprite;
		private var info_lding:Loading;
		///////////////////////////////
		private var title_str:String = "未知名称";
		private var chanl_str:String = "未知频道";
		private var prog_str:String = "未知栏目";
		private var type_str:String = "未知类型";
		private var view_str:String = String(341+Math.ceil(Math.random()*1000));
		private var time_str:String = "未知时间";
		private var key_str:String = "";
		private var det_str:String = "";
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
		
		public function Info() {
			init();
		}
		private function init() {
			info_fmt = new TextFormat();
			info_fmt.leading = 5;
			
			info_txt = new TextField();
			info_txt.y = 4;
			info_txt.width = 320;
			info_txt.height = SCROLL_HEIGHT-4;
			info_txt.multiline = true;
			info_txt.wordWrap = true;
			info_txt.text = "dsafdsafdasf";

			
			info_spt = new Sprite();
			info_spt.x = 6;
			info_spt.y = 0;
			info_spt.graphics.beginFill(0x000000, 0);
			info_spt.graphics.drawRect(0, 0, 346, SCROLL_DRAGGER_HEIGHT);
			info_spt.graphics.endFill();
			addChild(info_spt);
			
			info_lding = new Loading(vidPlayer.PANEL_WIDTH);
			addChild(info_lding);
			
			info_ld = new URLLoader();
			info_ld.addEventListener(Event.COMPLETE, infoComplete);
			info_ld.addEventListener(SecurityErrorEvent.SECURITY_ERROR, infoError);
			info_ld.addEventListener(IOErrorEvent.IO_ERROR, infoError);
			//info_ld.load(new URLRequest(info_dir+info_xml));
		}
		private function infoComplete(e:Event) {
			var _str:String = e.target.data.toString();
			var my_index1=_str.lastIndexOf("<root>");
			var my_index2=_str.lastIndexOf("</root>");
			if ((my_index2!=-1)&&(my_index1!=-1)&&(my_index1<my_index2)) {
				_str=_str.substring(my_index1,my_index2+String("</root>").length);
			} else {
				trace("Failed to parse info.xml.");
				return;
			}
			var _xml:XML=new XML(_str);

			title_str=_xml.child("title");
			chanl_str=_xml.child("channel");
			prog_str=_xml.child("program");
			type_str=_xml.child("type");
			view_str=_xml.child("view");
			time_str=_xml.child("time");
			key_str=_xml.child("key");
			det_str=_xml.child("detail");

			info_txt.htmlText = "<FONT COLOR='#CCCCCC' SIZE='14'>" + title_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>所属频道：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + chanl_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>所属栏目：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + prog_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>所属类别：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + type_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>浏览次数：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + view_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>播放时间：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + time_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>关 键 词：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + key_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>内容简介：</FONT><FONT COLOR='#666666' SIZE='12'>" + det_str + "</FONT>";
			info_txt.setTextFormat(info_fmt);
			info_spt.addChild(info_txt);
			
			initScroll();
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
			scroll_spt.x=info_spt.x + info_spt.width - dragger_slide.width;
			scroll_spt.y=info_spt.y;
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
			var _scroll:int = 1 + int((info_txt.maxScrollV - 1) * (dragger_sprite.y - SCROLL_TOP) / (SCROLL_HEIGHT - SCROLL_DRAGGER_HEIGHT));
			info_txt.scrollV = _scroll;
		}
		private function scrollError(e:Event) {
			trace("Failed to load scroll_ui");
		}
		private function infoError(e:Event) {
			trace("Failed to load info.xml");
		}
		public function setInfo(_obj:Object) {
			removeChild(info_lding);
			if (_obj.bbtv_title) {
				title_str = _obj.bbtv_title;
			}
			if (_obj.bbtv_channel) {
				chanl_str= _obj.bbtv_channel;
			}
			if (_obj.bbtv_program) {
				prog_str = _obj.bbtv_program;
			}
			if (_obj.bbtv_type) {
				type_str = _obj.bbtv_type;
			}
			if (_obj.bbtv_time) {
				time_str= _obj.bbtv_time;
			}
			if (_obj.bbtv_key) {
				key_str = _obj.bbtv_key;
			}
			if (_obj.bbtv_detail) {
				det_str = _obj.bbtv_detail;
			}
			
			info_txt.htmlText = "<FONT COLOR='#CCCCCC' SIZE='16'>" + title_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>所属频道：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + chanl_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>所属栏目：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + prog_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>所属类别：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + type_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>浏览次数：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + view_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>播放时间：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + time_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>关 键 词：</FONT><FONT COLOR='#CCCCCC' SIZE='12'>" + key_str+"</FONT>"
						+"<br/><FONT COLOR='#666666' SIZE='12'>内容简介：</FONT><FONT COLOR='#666666' SIZE='12'>" + det_str + "</FONT>";
			
			info_txt.setTextFormat(info_fmt);
			info_spt.addChild(info_txt);
			
			initScroll();

		}
	}
	
}