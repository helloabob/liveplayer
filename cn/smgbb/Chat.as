package cn.smgbb
{
	/*聊天*/
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	//import fl.managers.FocusManager;
	//import fl.motion.easing.*;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.geom.Rectangle;
	import flash.system.Security;
	
	import gs.TweenLite;
	import cn.smgbb.scrollBar;
	
	public class  Chat extends MovieClip
	{
		//private var chat_txt:TextField;//chat record
		//private var input_txt:TextField;//input
		private var txt_fmt:TextFormat;//文本格式
		private var history_spt:Sprite;//聊天记录Sprite
		private var scroll_bar:scrollBar;//滚动条
		//滤镜参数
		private var btn_filter_color:uint = 0xffffff;
		private var btn_filter_alpha:Number = 0.7;
		private var btn_filter_blur:uint = 5;
		private var btn_filter_str:Number = 1.5;
		//聊天见容加载地址
		//private var xml_url:String = "http://www.smgbb.tv/flashXML/HandlerSelectXML.ashx?startIndex=0";// & channelID = 0010 & channelObjectID = 6 & pageSize = 20";
		private var xml_url:String = "http://www.smgbb.tv/chat/service.ashx";
		private var xml_loader:URLLoader;//loader
		private var post_loader:URLLoader;//loader，发送聊天内容用
		private var xml_size:int = 30;//loader参数
		//聊天内容
		private var color_array:Array;//颜色数组，不同用户不能颜色，已弃用
		private var user_array:Array;//用户数组
		private var msg_array:Array;//信息数组
		private var time_array:Array;//时间数组
		private var color_index:int;//颜色序列
		private var chat_interv:uint;//刷新定时
		private var interv_delay:int = 10;//刷新时间间隔：10s
		//private var chat_fm:FocusManager;
		private var dragger_pace:Number = 15;//滚动一次
		private var post_url:String = "http://www.smgbb.tv/flashXML/HandlerInsertXML.ashx";//POST地址： ?channelID = 0010 & channelObjectID = 5 & username = t & content = helpMe";
		private var channelID:String = "0010";//参数
		private var channelObjectID:int = 6;//参数
		private var content:String;//内容
		private var isUsernameFilled:Boolean = false;
		private var user_name:String;//本用户名称
		private var user_guid:String;//本用户GUID
		//private var error_class:errorClass = new errorClass();
		private const COLOR_SET:Array = [0x99CCFF,0x666666,0x99CCFF,0xFFCCFF,0xCCFFFF,0xCCFF99,0x99FFCC,0xFF99CC,0xCC99FF,0xFFFFCC];
		private const COLOR_LOW:uint = 0x000000;
		private const COLOR_HIGH:uint = 0x666666;
		
		////////////////param for scroll_bar给滚动条的参数/////////////////////
		private var scroll_ui:String = vidConst.UI_DIR+"ScrollUI.swf?t="+Math.random();
		private var dragger:SimpleButton;
		private var dragger_slide:Sprite;
		private var scroll_spt:Sprite;
		private var dragger_sprite:Sprite;
		private const SCROLL_TOP:int = 0;
		private const SCROLL_X:int = 0;
		private const SCROLL_HEIGHT:int = 314;
		private const SCROLL_DRAGGER_HEIGHT:int = 64;
		
		public function Chat() {
			chatInit();
		}
		private function chatInit() {
			Security.allowDomain("*");
			//chat_fm = new FocusManager(this);
			xml_loader = new URLLoader();
			xml_loader.addEventListener(Event.COMPLETE, xmlComplete);
            xml_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, xmlError);
            xml_loader.addEventListener(IOErrorEvent.IO_ERROR, xmlError);
			
			post_loader=new URLLoader();
			post_loader.addEventListener(Event.COMPLETE, postComplete);
			post_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, xmlError);
            post_loader.addEventListener(IOErrorEvent.IO_ERROR, xmlError);

			//loadChat();
			//clearInterval(chat_interv);
			//chat_interv = setInterval(loadChat, interv_delay*1000);

			txt_fmt = new TextFormat();
			txt_fmt.color = 0xFFFFFF;
			txt_fmt.font = "Arial";
			
			//input_txt = new TextField();
			//input_txt.wordWrap = true;
			//input_txt.type = TextFieldType.INPUT;
			//input_txt.textColor = 0xFFFFFF;
			//input_txt.x = 15;
			//input_txt.y = 360;
			//input_txt.width = 320;
			//input_txt.height = 76;
			//input_txt.addEventListener(FocusEvent.FOCUS_IN, inputActivate);
			//input_txt.addEventListener(FocusEvent.FOCUS_OUT, inputDeactivate);
			//addChild(input_txt);
			
			send_btn.buttonMode = true;
			addChild(send_btn);//above input_txt
			//chat_fm.setFocus(input_txt);
			
			//聊天记录
			history_spt = new Sprite();
			history_spt.x = 6;
			//history_spt.width = 341;
			//history_spt.height = SCROLL_DRAGGER_HEIGHT;
			history_spt.graphics.beginFill(0xFF0000, 0);
			history_spt.graphics.drawRect(0, 0, 346, SCROLL_DRAGGER_HEIGHT);
			history_spt.graphics.endFill();
			//chat_txt = new TextField();
			chat_txt.wordWrap = true;
			chat_txt.multiline = true;
			//chat_txt.condenseWhite = true;
			//chat_txt.type = TextFieldType.DYNAMIC;
			//chat_txt.x = 6;
			//chat_txt.y = 4;
			chat_txt.width = 312;
			chat_txt.height = SCROLL_HEIGHT;
			chat_txt.textColor = 0xFFFFFF;
			chat_txt.text = "请先登录，输入用户名后按回车键";
			chat_txt.mouseWheelEnabled = false;
			//chat_txt.backgroundColor = 0x00FF00;
			chat_txt.setTextFormat(txt_fmt);
			history_spt.addChild(chat_txt);
			addChild(history_spt);
			
			initScroll();
			
			//用户名
			user_txt.addEventListener(MouseEvent.CLICK, userActivate);
			//user_txt.addEventListener(FocusEvent.FOCUS_IN, userActivate);
			user_txt.addEventListener(FocusEvent.FOCUS_OUT, userDeactivate);
			//输入文本框
			input_txt.addEventListener(FocusEvent.FOCUS_IN, inputActivate);
			input_txt.addEventListener(FocusEvent.FOCUS_OUT, inputDeactivate);
			
			//dragger.y = SCROLL_TOP + SCROLL_HEIGHT - SCROLL_DRAGGER_HEIGHT;
			//dragger.down.visible = false;
			//dragger_sprite = new Sprite();
			//dragger_sprite.graphics.beginFill(0xBBBBBB, 1);
			//dragger_sprite.graphics.drawRoundRect(0, 0, 16, 55, 10, 10);
			//dragger_sprite.graphics.endFill();
			//dragger.addEventListener(MouseEvent.MOUSE_OVER, draggerOver);
			//dragger.addEventListener(MouseEvent.MOUSE_OUT, draggerOut);
			//dragger.addEventListener(MouseEvent.MOUSE_DOWN, draggerDown);
			
			send_btn.addEventListener(MouseEvent.CLICK, sendClick);
			//chat_txt.addEventListener(Event.SCROLL, chatScroll);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		//加载滚动条
		private function initScroll() {
			//scroll_bar=new scrollBar();
			//scroll_bar.mc=history_spt;
			//scroll_bar.scrollWidth=history_spt.width;
			//scroll_bar.scrollHeigth=history_spt.height;
			//addChild(scroll_bar);
			scroll_spt = new Sprite();//放置整个scroll_bar
			dragger_sprite = new Sprite();//放置dragger
			var _url:URLRequest=new URLRequest(scroll_ui);
			var _loader:Loader=new Loader();
			_loader.load(_url);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,scrollComplete);
		}
		//加载滚动条完毕
		private function scrollComplete(e:Event) {
			//对滚动滑道类引用
			var _class1:Class=e.target.content.slide_mc.constructor  as  Class;
			//对滚动滑块类引用
			var _class2:Class=e.target.content.glide_btn.constructor  as  Class;
			dragger_slide=new _class1();
			dragger=new _class2();
			//滚动滑块按下
			dragger.addEventListener(MouseEvent.MOUSE_OVER, draggerOver);
			dragger.addEventListener(MouseEvent.MOUSE_OUT, draggerOut);
			dragger.addEventListener(MouseEvent.MOUSE_DOWN, draggerDown);
			//设置滚动条的位置（为被滚动对象的坐标＋滚动区域的宽度－滑道的宽度）
			scroll_spt.x=history_spt.x + history_spt.width - dragger_slide.width;
			scroll_spt.y=history_spt.y;
			//设置滑道的高
			dragger_slide.height=SCROLL_HEIGHT;
			//显示
			//由于滑块是个按扭没有拖动时间所以先将其放入MC容器glideMC
			dragger_sprite.addChild(dragger);
			scroll_spt.addChild(dragger_slide);
			scroll_spt.addChild(dragger_sprite);
			addChild(scroll_spt);
			//创建遮照
			//mask_mc.graphics.beginFill(0xFFFFFF);
			//mask_mc.graphics.drawRect(0,0,_scrollWidth,_scrollHeigth);
			//mask_mc.graphics.endFill();
			//mask_mc.width-= glide_btn.width + 3;
			//addChild(mask_mc);
			//绑定
			//_mc.mask=mask_mc;
			//鼠标滚动事件
			//parent.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
			//移动被滚动对象计时器初始化
			//moveTimer=new Timer(50,0);
			//moveTimer.addEventListener(TimerEvent.TIMER,moveMC);
		}
		//加载聊天内容
		private function loadChat() {
			//trace(xml_url + "?action=GetMsg&u=" + user_guid);
			xml_loader.load(new URLRequest(xml_url+"?action=GetMsg&u="+user_guid+"&rd="+Math.random()));
			//xml_loader.load(new URLRequest(xml_url));
		}
		//加载完毕
		private function xmlComplete(e:Event) {
			chat_txt.htmlText = "";
			user_array = new Array();
			msg_array = new Array();
			time_array = new Array();
			color_array = new Array();
			color_index = 0;
			var _str:String = decodeURIComponent(e.target.data);
			var _index1:int = _str.indexOf("<root");
			var _index2:int = _str.indexOf("</root>");
			if (_index1 == -1 || _index2 == -1 || _index1>_index2) {
				//error_class.error="incorrect xml format in chat_set";
				return;
			}
			_str = _str.substring(_index1, _index2+7);
			var _xml:XML = new XML(_str);
			var _error:int = int(_xml.error.toString());
			if (!checkError(_error)) {//_error!=0，即出错
				return;
			}
			var _node:XMLList = _xml.smgbbGuestBookMsg;
			//trace("_node length: " + _node.length());
			for each(var _item in _node) {
				var _index:int = user_array.indexOf(String(_item.userName));
				user_array.push(String(_item.userName));
				msg_array.push(String(_item.content));
				//time_array.push(String(_item.child("createTime")));
				if ( _index == -1) {
					if (String(_item.child("userName")) == "系统消息") {
						color_array.push(COLOR_SET[1]);//系统消息
					}else {
						color_array.push(COLOR_SET[0]);
					}					
					
				}else{
					color_array.push(color_array[_index]);
				}
				//trace(color_array[color_index]);
				color_index++;				
			}
			showMsg();
		}
		//显示信息
		private function showMsg() {
			chat_txt.text = "";
			var _len:int = Math.min(user_array.length, msg_array.length);
			for (var i:int = _len-1; i >=0; i--) {
				receiveSmg(msg_array[i], i);
			}
		}
		//加载错误
		private function xmlError(e:Event) {
			//error_class.error="Fail to Load Chatting XML.";
		}
		//dragger事件
		private function draggerOver(e:MouseEvent) {
			//TweenLite.to(dragger_sprite, 1.5, { alpha:0,ease:Linear.easeIn});
		}
		private function draggerOut(e:MouseEvent) {
			//TweenLite.to(dragger_sprite, 1.5, { alpha:100,ease:Linear.easeIn});
		}
		private function draggerDown(e:MouseEvent) {
			//e.target.down.visible = true;
			e.target.stage.addEventListener(MouseEvent.MOUSE_UP, draggerUp);
			e.target.stage.addEventListener(MouseEvent.MOUSE_MOVE, draggerMove);
			var _rec:Rectangle = new Rectangle(SCROLL_X, SCROLL_TOP, 0,SCROLL_HEIGHT-SCROLL_DRAGGER_HEIGHT);
			dragger_sprite.startDrag(false, _rec);
		}
		private function draggerUp(e:MouseEvent) {
			//dragger.down.visible = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, draggerMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, draggerUp);
			dragger_sprite.stopDrag();
		}
		private function draggerMove(e:MouseEvent) {
			var _scroll:int = 1 + int((chat_txt.maxScrollV-1) * (dragger_sprite.y - SCROLL_TOP) / (SCROLL_HEIGHT - SCROLL_DRAGGER_HEIGHT));
			chat_txt.scrollV = _scroll;
		}
		//聊天内容滚动，更新dragger
		private function chatScroll(e:Event) {
			updateScroller();
		}
		//滚轮事件
		private function mouseWheel(e:MouseEvent) {
			//var _offset:Number = dragger.y - dragger_pace * e.delta;
			//if (_offset<SCROLL_TOP) {
				//_offset = SCROLL_TOP;
			//} else if (_offset>SCROLL_HEIGHT - SCROLL_DRAGGER_HEIGHT+SCROLL_TOP) {
				//_offset = SCROLL_HEIGHT - SCROLL_DRAGGER_HEIGHT+SCROLL_TOP;
			//}
			//TweenLite.to(dragger,0.3,{y:_offset,onUpdate:draggerMove(new MouseEvent(MouseEvent.MOUSE_DOWN))});
		}
		//更新dragger
		private function updateScroller() {
			//dragger.y = SCROLL_TOP + (SCROLL_HEIGHT - SCROLL_DRAGGER_HEIGHT)*Math.abs((chat_txt.scrollV-1))/(chat_txt.maxScrollV-1);
		}
		//发送
		private function sendClick(e:MouseEvent) {
			if (user_txt.text == ""||!isUsernameFilled) {
				user_txt.text = "用户名不能为空";
				isUsernameFilled = false;
			}else{
				if (input_txt.text != "") {
					//error_class.error = "dsfdsafdsaf";
					clearInterval(chat_interv);
					chat_interv = setInterval(loadChat, interv_delay*1000);
					sendMsg(input_txt.text);					
					chat_txt.htmlText =chat_txt.htmlText+"<FONT COLOR='#99CCFF'><b>"+user_txt.text+": </b></FONT><FONT COLOR='#FFFFFF'>" + input_txt.text + "</FONT>";
					chat_txt.scrollV = chat_txt.maxScrollV;
					input_txt.text = "";
				}
			}
		}
		//接收到的信息
		public function receiveSmg(_str:String, _id:int) {//get msg from others
			var _color1:String = "99CCFF";
			var _color2:String = "FFFFFF";
			if (user_array[_id] == "系统消息") {
				_color1 = "999999";
				_color2 = "999999";
			}
			chat_txt.htmlText ="<FONT COLOR='#"+_color1+"'><b>"+user_array[_id] +": </b></FONT><FONT COLOR='#"+_color2+"'>" + _str + "</FONT><br>"+chat_txt.htmlText;
			//chat_txt.scrollV = chat_txt.maxScrollV;
		}
		//发送信息
		private function sendMsg(_str:String) {//send msg to others
			var _date:Date = new Date();
			content = _str;
			//trace(xml_url + "?action=Post&u=" + user_guid + "&t=" + encodeURIComponent(_str));
			post_loader.load(new URLRequest(xml_url+"?action=PostMsg&u="+user_guid+"&t="+encodeURIComponent(_str)+"&rd="+Math.random()));
		}
		//post后收到数据
		private function postComplete(e:Event):void
		{
			var _str:String = decodeURIComponent(e.target.data);
			var _index1:int = _str.indexOf("<root");
			var _index2:int = _str.indexOf("</root>");
			if (_index1 == -1 || _index2 == -1 || _index1>_index2) {
				//error_class.error="incorrect post format in chatting_set";
				return;
			}
			_str = _str.substring(_index1, _index2+7);
			var _xml:XML = new XML(_str);
			//trace(_xml);
			var _error:int = int(_xml.error.toString());
			if (!checkError(_error)) {//_error!=0，即出错
				return;
			}
			loadChat();
		}
		//输入框获得/失去焦点
		private function inputActivate(e:FocusEvent) {
			addEventListener(KeyboardEvent.KEY_DOWN, inputCheck);
		}
		private function inputDeactivate(e:FocusEvent) {
			removeEventListener(KeyboardEvent.KEY_DOWN, inputCheck);
		}
		//用户名获得/失去焦点
		private function userActivate(e:Event) {
			addEventListener(KeyboardEvent.KEY_DOWN, userCheck);
			if(!isUsernameFilled){
				user_txt.text = "";
				isUsernameFilled = true;
			}else {
				user_txt.setSelection(0, user_txt.length);
			}
		}
		private function userDeactivate(e:FocusEvent) {
			removeEventListener(KeyboardEvent.KEY_DOWN, userCheck);
			if (user_txt.text == "") {
				user_txt.text = "请输入你的用户名";
				isUsernameFilled = false;
			}else {
				if(user_name!=user_txt.text){
					showInfo("正在以" + user_txt.text + "登录...");
					user_name = user_txt.text;
					getGUID(user_name);
				}
			}
		}
		//输入框激活情况下按回车
		private function inputCheck(e:KeyboardEvent) {
			if (e.keyCode == 13) {//Press Enter_Key
				sendClick(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		//用户名激活情况下按回车
		private function userCheck(e:KeyboardEvent) {
			if (e.keyCode == 13) {//Press Enter_Key				
				//chat_fm.setFocus(input_txt);
				userDeactivate(new FocusEvent(FocusEvent.FOCUS_OUT));
			}
		}
		//得到GUID
		private function getGUID(_user:String) {
			var _guid_ld:URLLoader = new URLLoader();
			_guid_ld.addEventListener(Event.COMPLETE, guidComplete);
            _guid_ld.addEventListener(SecurityErrorEvent.SECURITY_ERROR, guidError);
            _guid_ld.addEventListener(IOErrorEvent.IO_ERROR, guidError);
			//trace(xml_url + "?action=Login&u=" + encodeURIComponent(_user));
			_guid_ld.load(new URLRequest(xml_url+"?action=Login&u="+encodeURIComponent(_user)));
		}
		//加载GUID完毕
		private function guidComplete(e:Event) {
			var _str:String = decodeURIComponent(e.target.data);
			var _index1:int = _str.indexOf("<root");
			var _index2:int = _str.indexOf("</root>");
			if (_index1 == -1 || _index2 == -1 || _index1>_index2) {
				//error_class.error="incorrect xml format in chat_set";
				showInfo("解析GUID失败，请重试");
				return;
			}
			_str = _str.substring(_index1, _index2+7);
			var _xml:XML = new XML(_str);
			var _error:int = int(_xml.error.toString());
			if (checkError(_error)) {//_error=0，即没有出错
				user_guid = _xml.guid.toString();
				showInfo("正在装载聊天内容...");
				loadChat();
			}
		}
		
		
		private function btnOver(e:MouseEvent) {
			TweenLite.to(e.currentTarget, 0.4, {glowFilter:{color:btn_filter_color, alpha:btn_filter_alpha, blurX:btn_filter_blur, blurY:btn_filter_blur,strength:btn_filter_str}});
			//TweenLite.to(e.currentTarget, 0.4, {colorMatrixFilter:{brightness:1.5}});
		}
		private function btnOut(e:MouseEvent) {
			TweenLite.to(e.currentTarget, 1, {glowFilter:{color:btn_filter_color, alpha:btn_filter_alpha, blurX:0, blurY:0,strength:1}});
			//TweenLite.to(e.currentTarget, 1, {colorMatrixFilter:{brightness:0.7}});
		}
		//加载失败
		private function guidError(e:Event) {
			trace("Fail to load guid.")
			showInfo("获取GUID失败，请重试");
		}
		private function checkError(_error:int):Boolean{
			if (_error == 0) {
				return true;
			}else {
				switch(_error) {
					case -1:
					showInfo("参数错误.请联系fluensh@126.com");
					break;
					case 1:
					showInfo("该用户已存在，请重试.");
					break;
					case 2:
					showInfo("用户不存在或者已超时退出，请重新登录.");
					break;
					default:
					break;
				}
				return false;
			}
		}
		//显示信息
		private function showInfo(_obj:Object) {
			chat_txt.text = _obj;
		}
	}
	
}