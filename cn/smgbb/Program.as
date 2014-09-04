package cn.smgbb
{
	/*具体节目的类*/
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import gs.TweenLite;

	public class Program extends MovieClip {
		//默认起止时间
		private var start_str:String="06:00:00";
		private var end_str:String = "06:30:00";
		public var currentDate:String = "2001-01-01";
		//默认CID
		private var _progCid:int = 210;//cid
		private var bg_color1:uint = 0x262626;//背景色1
		private var bg_color2:uint = 0x323232;//背景色2
		private var bg_color:uint = bg_color1;//背景色
		private var hl_color:uint = 0xFFCC00;//高亮颜色
		private var playing_color:uint = 0xCBFF00;//正在播放颜色
		public var progDate:Date;//date
		public var url:String;
		private var _progTitle:String="上海新报";//title of prog
		private var progType:String="";//type of prog
		private var _progStart:Date;//starttime of prog
		private var _progEnd:Date;//endtime of prog
		private var progDes:String;//description
		private var _progStamp:String="0";//time stamp
		private var _progDuration:int;//duration of prog in secs
		private var _progMulti:uint = 1;//multiple of scale
		private var _pixMinute:Number = 380/60;//pixes per minute	
		private var time_txt:TextField;//时间文本框
		private var time_fmt:TextFormat;//时间格式
		private var title_txt:TextField;//标题文本框
		private var title_fmt:TextFormat;//标题格式
		private var playing_fmt:TextFormat;//正在播放格式，没用到？
		private var air_txt:TextField;//看/听直播
		private var air_fmt:TextFormat;//格式

		private var interv:uint;//interval
		private var scrollSpeed:int = 1;//setoff per interval
		private var timeInterv:int = 25;//millisecends of each interval
		private var title_cover:Sprite;//标题Cover层
		private var bg_sprite:Sprite;//背景Sprite
		private var hl_spt:Sprite;//高亮外框
		private var playing_spt:Sprite;//正在播放当前节目icon
		private var air_spt:Sprite;//正在直播icon
		private var is_title_overflow:Boolean = false;//标题太长
		//private var error_class:errorClass = new errorClass();
		
		private var video_type:String = "0";
		
		public var recExtension:Object;//扩展信息
		public var is_down:Boolean = false;//是否激活，点击后被激活
		//标题和时间文本的坐标
		private const TITLE_X:int = 79;
		private const TIME_X:int = 30;
		//宽度和高度
		private const PROG_WIDTH:int = 334;
		private const PROG_HEIGHT:int = 24;
		//cover层颜色
		private const COVER_COLOR:uint = 0x000000;
		//标题最大长度
		private const TITLE_MAX_WIDTH:int = 214;
		//事件
		public static const CLICK_PROGRAM:String = "click_program";
		public static const OVER_PROGRAM:String = "over_program";

		public function Program(_obj:Object) {
			progDate = new Date();
			if (_obj.date) {
				currentDate = _obj.date;
				progDate = parseDate(_obj.date);
			}
			if (_obj.cid) {
				_progCid = _obj.cid;
			}
			if (_obj.title) {
				_progTitle = _obj.title;
			}
			if (_obj.type) {
				progType = _obj.type;
			}
			if (_obj.starttime) {
				start_str = _obj.starttime;
				_progStart = parseTime(start_str);
			}
			if (_obj.endtime) {
				end_str = _obj.endtime;				
				_progEnd = parseTime(end_str);				
			}
			if (_obj.timestamp) {
				_progStamp = _obj.timestamp;
			}
			if (_obj.url) {
				url = _obj.url;
			}
			if(_obj.video_type){
				this.video_type = _obj.video_type;
			}
			if (_obj.duration) {
//				version 1
//				_progDuration = _obj.duration*60/1000;
				
//				version 2
//				var dur:String = _obj.duration;
//				var tmp:String = dur.substr(0,2);
//				var result:int = 0;
//				if(int(tmp)>0)result = int(tmp) * 3600;
//				tmp = dur.substr(2,2);
//				if(int(tmp)>0)result = result + int(tmp) * 60;
//				tmp = dur.substr(4,2);
//				if(int(tmp)>0)result = result + int(tmp);
//				_progDuration = result;
				
//				version 3
				var dur:String = _obj.duration;
				var tmp:String = "";
				var result:int = 0;
				tmp=dur.substr(0,2);
				if(int(tmp)>0)result = int(tmp) * 3600;
				tmp = dur.substr(3,2);
				if(int(tmp)>0)result = result + int(tmp) * 60;
				tmp = dur.substr(6,2);
				if(int(tmp)>0)result = result + int(tmp);
				_progDuration = result;
				
//				trace("dur:"+_obj.duration+"     res:"+result);
			}
			if (_obj.id) {
				(_obj.id % 2)?(bg_color = bg_color2):(bg_color = bg_color1);
			}
			init();
		}
		private function init():void {
			//初始化背景
			bg_sprite = new Sprite();
			bg_sprite.name = "bg";
			bg_sprite.graphics.beginFill(bg_color, 1);
			bg_sprite.graphics.drawRect(1, 0, 28, PROG_HEIGHT);
			bg_sprite.graphics.drawRect(TIME_X, 0, 48, PROG_HEIGHT);
			bg_sprite.graphics.drawRect(TITLE_X, 0, 257, PROG_HEIGHT);
			bg_sprite.graphics.endFill();
			//bg_sprite.buttonMode = true;
			addChild(bg_sprite);
			//侦听
			bg_sprite.addEventListener(MouseEvent.MOUSE_OVER, thisOver);
			bg_sprite.addEventListener(MouseEvent.MOUSE_OUT, thisOut);
			bg_sprite.addEventListener(MouseEvent.CLICK, thisClick);
			
			//外框高亮
			hl_spt = new Sprite();
			hl_spt.name = "hl_spt";
			hl_spt.graphics.lineStyle(1, hl_color, 1);
			hl_spt.graphics.drawRect(1, 1, PROG_WIDTH, PROG_HEIGHT - 2);
			hl_spt.graphics.endFill();
			hl_spt.alpha = 0;
			addChild(hl_spt);
			
			creText();
			
			initIcon();
		}
		//小图标，矩形内一个小三角形
		private function initIcon() {
			//矩形
			playing_spt = new Sprite();
			playing_spt.name = "playing_spt";
			playing_spt.graphics.beginFill(0xFFFFFF, 0);
			playing_spt.graphics.lineStyle(1, playing_color);
			playing_spt.graphics.drawRect(0, 0, 13, 10);
			playing_spt.graphics.endFill();
			playing_spt.x = 10;
			playing_spt.y = 7;
			playing_spt.alpha = 0;
			playing_spt.mouseEnabled = false;
			addChild(playing_spt);
			
			//小三角形
			var _spt:Sprite = new Sprite();
			_spt.name = "tri";//三角形
			_spt.graphics.beginFill(playing_color, 1);
			_spt.graphics.moveTo(0, 0);
			_spt.graphics.lineTo(5, 3);
			_spt.graphics.lineTo(0,6);
			_spt.graphics.lineTo(0, 0);
			_spt.graphics.endFill();
			_spt.x = (playing_spt.width - _spt.width) / 2;
			_spt.y = (playing_spt.height - _spt.height) / 2;
			playing_spt.addChild(_spt);
			
			//看/听直播
			air_fmt = new TextFormat();
			air_fmt.underline = true;
			air_fmt.font = "Arial";
			air_fmt.color = playing_color;
			air_txt = new TextField();
			air_txt.name = "air_txt";
			air_txt.width = 40;
			air_txt.text = this.video_type=="0"?"看直播":"听直播";
			air_txt.selectable = false;
			air_txt.mouseEnabled = false;
			air_txt.setTextFormat(air_fmt);
			air_txt.autoSize = "left";	
			air_txt.x = 295;
			air_txt.y = (PROG_HEIGHT - air_txt.height) / 2;
			air_txt.alpha = 0;
			addChild(air_txt);
		}
		//格式化日期yyyy-mm-dd:mm/dd/yyyy
		private function parseDate(_str:String):Date {
			var _arr:Array = _str.split("-");
			var _date:Date = new Date(_arr[1] + "/" + _arr[2] + "/" + _arr[0]);
			return _date;
		}
		//格式化时间
		private function parseTime(_time:String):Date {
			var _date:Date = cloneDate(progDate);
			var _arr:Array = _time.split(":");
			_date.setHours(int(_arr[0]));
			_date.setMinutes(int(_arr[1]));
			return _date;//e.g. 18:05:00
		}
		//复制日期
		private function cloneDate(_dt:Date):Date {
			var _date:Date = new Date(_dt.toString());
			return _date;
		}
		//初始化文本框
		public function creText():void {
			playing_fmt = new TextFormat();
			playing_fmt.align = TextFormatAlign.LEFT;
			playing_fmt.color = 0x33CCCC;
			playing_fmt.font = "Arial";
			playing_fmt.bold = true;
			//time_fmt.italic = true;
			
			time_txt = new TextField();
			time_txt.name = "time_txt";
			time_fmt = new TextFormat();
			time_fmt.align = TextFormatAlign.CENTER;
			time_fmt.color = 0xFFFFFF;
			time_fmt.font = "Arial";
			time_fmt.bold = true;
			
			time_txt.width=48;
			time_txt.height = PROG_HEIGHT;
			time_txt.x = TIME_X;
			time_txt.y = 2;
			time_txt.text =start_str.substring(0,5);
			time_txt.setTextFormat(time_fmt);
			time_txt.selectable = false;
			time_txt.mouseEnabled = false;
			addChild(time_txt);
			
			title_txt = new TextField();
			title_txt.name = "txt";
			title_fmt = new TextFormat();
			title_fmt.align = TextFormatAlign.LEFT;		
			title_fmt.color = 0xFFFFFF;
			title_fmt.font = "Arial";
			
			title_txt.width=257;
			title_txt.height = PROG_HEIGHT;
			title_txt.x = TITLE_X+2;
			title_txt.y = 2;
			title_txt.text = _progTitle;
			title_txt.autoSize = TextFieldAutoSize.LEFT;
			while (title_txt.width > TITLE_MAX_WIDTH) {
				_progTitle = _progTitle.substring(0,_progTitle.length - 3);
				title_txt.text = _progTitle;
				title_txt.autoSize = TextFieldAutoSize.LEFT;
				is_title_overflow = true;
			}
			if (is_title_overflow) {
				title_txt.appendText("...");
			}
			title_txt.setTextFormat(title_fmt);
			title_txt.selectable = false;
			title_txt.mouseEnabled = false;
			addChild(title_txt);
			
			title_cover = new Sprite();
			title_cover.name = "cover";
			title_cover.graphics.beginFill(bg_color, 1);
			title_cover.graphics.drawRect(1, 0, 28, PROG_HEIGHT);
			title_cover.graphics.drawRect(TIME_X, 0, 48, PROG_HEIGHT);
			title_cover.graphics.drawRect(TITLE_X, 0, 257, PROG_HEIGHT);
			title_cover.graphics.endFill();
			title_cover.buttonMode = false;
			title_cover.mouseEnabled = false;
			addChild(title_cover);
			//title_txt.addEventListener(MouseEvent.MOUSE_OVER, startScroll);
			//title_txt.addEventListener(MouseEvent.MOUSE_OUT, stopScroll);
			//title_txt.autoSize=TextFieldAutoSize.CENTER;
			//while (title_txt.height>cont["chanl"+_id].getChildByName("pro"+i).getChildByName("cont_"+_id+"_"+i).height) {
			//var tmp_str = title_txt.text;
			//var tmp_index = tmp_str.indexOf(":");
			//if (tmp_index == -1) {
			//tmp_index = tmp_str.indexOf("：");
			//}
			//if (tmp_index == -1) {
			//title_txt.text="";
			//break;
			//} else {
			//tmp_str = tmp_str.substring(tmp_index+1);
			//title_txt.text = tmp_str;
			//}
			//}
		}
		//开始滚动
		private function startScroll(e:MouseEvent) {
			interv = setInterval(txtScroll, timeInterv);
		}
		//结束滚动
		private function stopScroll(e:MouseEvent) {
			clearInterval(interv);
			title_txt.scrollH=0;
		}
		//文字滚动
		private function txtScroll() {
			if (title_txt.scrollH >= title_txt.maxScrollH) {
				title_txt.scrollH = title_txt.maxScrollH;
				scrollSpeed *= -1;
			} else if (title_txt.scrollH <=0) {
				title_txt.scrollH = 0;
				scrollSpeed *= -1;
			}
			title_txt.scrollH += scrollSpeed;
		}
		//事件
		private function thisOver(e:MouseEvent) {			
			time_txt.textColor = hl_color;
			title_txt.textColor = hl_color;
		}
		private function thisOut(e:MouseEvent) {
			if(is_down){
				time_txt.textColor = hl_color;
				title_txt.textColor = hl_color;	
			}else {
				time_txt.textColor = 0xFFFFFF;
				title_txt.textColor = 0xFFFFFF;	
			}
		}
		private function thisClick(e:MouseEvent) {
			is_down = true;
			time_txt.textColor = hl_color;
			title_txt.textColor = hl_color;
			playing_spt.alpha = 1;
			hl_spt.alpha = 1;
			dispatchEvent(new Event(Program.CLICK_PROGRAM));
		}
		//get / set
		public function set progMulti(_int:int):void {
			_progMulti = _int;
		}
		public function set pixMinute(_num:Number):void {
			pixMinute = _num;
		}
		public function get progDuration():int {
			return _progDuration;
		}
		public function get progCid():int {
			return _progCid;
		}
		public function get progStamp():String {
			return _progStamp;
		}
		public function get endStamp():String {
			return _progEnd.getTime()/1000;
		}
		public function get progTitle():String {
			return _progTitle;
		}
		public function get progStart():String {
			return start_str;
		}
		//恢复成常态
		public function setOut() {
			is_down = false;
			title_txt.setTextFormat(title_fmt);
			time_txt.setTextFormat(time_fmt);
			playing_spt.alpha = 0;
			hl_spt.alpha = 0;
		}
	}
}