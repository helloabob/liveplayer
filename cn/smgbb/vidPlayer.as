package cn.smgbb
{
	/* 主类(入口） */
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	import gs.TweenLite;
	
	public class vidPlayer extends Sprite
	{
		private var is_mute:Boolean = false;//是否静音
		private var is_playing:Boolean = true;//是否正在播放
		private var is_ad_ready:Boolean = false;//广告是否准备好
		private var is_first_time:Boolean = true;//是否第一次运行
		private var is_open:Boolean = true;//面板是否打开
		private var def_btn:int = 0;//默认按钮序列,0:epg,1:聊天
		private var cur_btn:int = -1;//当前按钮序列
		private var next_btn:int = -1;//下个按钮（面板）序列
		private var cur_index:int = 0;//当前总序列
		private var btn_index:int=0;//按钮序列
		private var ad_out_timer_dur:int = 2;//广告加载10s超时
		private var vol_bar_length:int = 75;//音量条长度
		private var video_vol:Number;//音量
		private var hint_timer_dur:Number = 0.4;//提示显示
		private var unhint_timer_dur:Number = 2;//提示消失	
		private var first_timer_dur:int = 15;//[first_timer_dur]秒后面板隐藏
		private var arrow_timer_dur:Number = 4;//4s秒后隐藏箭头按钮
		private var video_mc_x:Number;//视频mc初始位置
		//各UI文件名，路径在vidConst.UI_DIR
		private var ui_url:String = "ui_main.swf";//?t=" + Math.random();
		private var ui_info:String = "ui_info.swf";//?t=" + Math.random();
		private var ui_recom:String = "ui_recom.swf";//?t=" + Math.random();
		private var ui_epg:String = "ui_epg.swf";//?t=" + Math.random();
//		private var ui_epg:String = "ui_epg_radio.swf";//?t=" + Math.random();
		private var ui_chat:String = "ui_chat.swf";//?t=" + Math.random();
		private var ad_url:String = "http://172.26.43.167:2317/publish.ashx?platid=4&rd="+Math.random();//广告配置地址
		private var is_init_arr:Array;//控制各面板是否初始化的数组
		private var btn_arr:Array;//按钮数组
		private var panel_spt_arr:Array;//各面板Sprite数组
		private var panel_ld_arr:Array;//显示各面板函数数组
		private var btn_des_arr:Array = ["epg", "chat", "play", "air", "vol","fls"];
		private var btn_hint_arr:Array = ["节目单","聊天","播放/暂停","返回直播","调整音量","全屏"];
		private var ad_ld:URLLoader;//广告loader
		private var ui_ld:Loader;//主界面loader
		private var info_ld:Loader;//节目详细信息面板loader，已作废
		private var recom_ld:Loader;//相关推荐面板loader，同上已废
		private var epg_ld:Loader;//epg面板loader
		private var chat_ld:Loader;//聊天面板loader
		private var ad_spt:Sprite;//广告sprite
		private var ad_mask:Sprite;//广告mask
		private var panel_mask:Sprite;//面板mask
		private var ui_spt:Sprite;//主界面Sprite
		private var info_spt:Sprite;//信息面板sprite
		private var recom_spt:Sprite;//推荐面板Sprite
		private var epg_spt:*;//EPG面板Sprite
		private var chat_spt:Sprite;//聊天面板Sprite
		private var cur_spt:Sprite;//当前面板
		private var vid_spt:Sprite;//视频sprite
		private var hint_txt:TextField;//提示文本
		private var hint_fmt:TextFormat;//
		private var ad_out_timer:Timer;//广告加载超时
		private var hint_timer:Timer;//提示
		private var unhint_timer:Timer;//提示
		private var first_timer:Timer;//第一次运行一定时间后隐藏面板
		private var arrow_timer:Timer;//隐藏箭头按钮
		private var panel_loading:Loading;//面板loading组件
		private var main_loading:Loading;//主界面loading组件
		//private var ad_txt:advText;//文字广告
		//private var ad_buf:advBuffer;//缓冲广告
		private var scroll_text:scrollText;//滚动广告
		//////////////////////////////for vid,视频相关参数//////////////////////////
		private var vid_url:String = "http://www.bbtv.cn/bbtv_common/bbtv_flash/Smgbb.swf";
		private var vid_mode:String = aVideo.MODE_LIVE;
		private var vid_ui:String = "ui.swf";
		public var vid_cid:int = 217;
		public var vid_timestamp:Number = 1246233110;
		private var vid_endtimestamp:Number = 0;
		private var avideo:aVideo;//视频
		private var title_text:titleText;//控制播放器上头节目信息
		///////////////////////////////for info & recom，信息和推荐面板具体信息//////////////////////
		private var info_obj:Object;
		private var recom_obj:Object;
		
		private const STAGE_WIDTH:int = 960;//舞台
		private const STAGE_HEIGHT:int = 528;
		private const VIDEO_WIDTH:int = 544;//视频
		private const VIDEO_HEIGHT:int = 408;
		private const panel_WIDTH:int = 354;//面板
		public static const PANEL_WIDTH:int = 352;
		private var video_type:String = "0";
		//public static const CID_ARR:Array = [212, 215, 218, 214, 220, 217, 211, 216, 219, 210,225,242,253,226,241,240];//array of cid	
		//public static const CN_ARR:Array = ["财经频道", "纪实频道", "艺术人文","五星体育","外语频道","娱乐频道", "生活时尚","东方卫视","戏剧频道","新闻综合","电影频道","浙江卫视","湖南卫视","凤凰卫视","江苏卫视","北京卫视"];//array of channel
		//public static const UI_DIR:String = "/bbtv_common/bbtv_flash/flash/v4/";//ui文件根目录
		//public static const UI_DIR:String = "file:///E:/Work Source/web IPTV/Flash/新版bbtv播放器/2009-6-23/";//ui文件根目录
		//public static const UI_DIR:String = "http://localhost/v3/";//ui文件根目录

		private var channel_list_dir:String=Constants.channelListUrl;
		private var channel_list:Array=[];
		
		private var apiHost:String = "";
		
		public function vidPlayer(_obj:Object) {
			if (_obj.cid) {
				vid_cid = int(_obj.cid);
			}
			if (_obj.ui) {
				vid_ui = _obj.ui;
			}
			if (_obj.starttimestamp) {
				vid_timestamp = Number(_obj.starttimestamp);
				//vid_mode = aVideo.MODE_VOD;
			}
			if (_obj.endtimestamp) {
				vid_endtimestamp = Number(_obj.endtimestamp);
				//vid_mode = aVideo.MODE_VOD;
			}
			if (vid_endtimestamp == 0) {
				vid_endtimestamp = new Date().getTime() / 1000;
			}
			if (_obj.video_type) {
				video_type = _obj.video_type;
			}
			if (_obj.apiHost) {
				apiHost = _obj.apiHost;
			}
			
			channel_list_dir = channel_list_dir.replace("{0}",video_type);
			/////////////////param for info///////////////////
			info_obj = { };
			////////////////////////param for recom/////////////////
			recom_obj = { };
//			initVidPlayer();
			loadChannelInfo();
		}
		private function loadChannelInfo():void{
			var channel_list_ld:URLLoader = new URLLoader();
			channel_list_ld.addEventListener(Event.COMPLETE, channelXMLComplete);
			channel_list_ld.addEventListener(SecurityErrorEvent.SECURITY_ERROR, configError);
			channel_list_ld.addEventListener(IOErrorEvent.IO_ERROR, configError);
			channel_list_ld.load(new URLRequest(channel_list_dir));
		}
		private function channelXMLComplete(e:Event):void{
			var ld:URLLoader = e.target as URLLoader;
			ld.removeEventListener(Event.COMPLETE, channelXMLComplete);
			ld.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, configError);
			ld.removeEventListener(IOErrorEvent.IO_ERROR, configError);
			var list_str:String = e.target.data.toString();
			var _xml:XML = new XML(list_str);
			var i:int = 0;
			var canfind:Boolean = false;
			for each(var node:* in _xml.channel){
				channel_list[i] = {name:node.@name,id:node.@id,live:node.@live};
//				channel_list[i] = {name:node.@name,id:node.@id,live:"http://lms.xun-ao.com/Live/104/live/livestream.m3u8"};
				if(int(node.@id)==vid_cid)canfind=true;
				i++;
			}
			if(canfind==false)vid_cid=int(_xml.channel[0].@id);
			initVidPlayer();
		}
		private function configError(e:Event) {
			var ld:URLLoader = e.target as URLLoader;
			ld.removeEventListener(Event.COMPLETE, channelXMLComplete);
			ld.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, configError);
			ld.removeEventListener(IOErrorEvent.IO_ERROR, configError);
		}
		//初始化
		private function initVidPlayer():void {//init
			Security.allowDomain("*");
			hint_fmt = new TextFormat();
			hint_fmt.color = 0xFFFFFF;
			hint_fmt.align = TextFormatAlign.CENTER;
			hint_txt = new TextField();
			hint_txt.width = 80;
			hint_txt.height = 25;
			hint_txt.mouseEnabled = false;
			hint_txt.autoSize = TextFieldAutoSize.CENTER;
			hint_txt.background = true;
			hint_txt.backgroundColor = 0x000000;
			
			hint_timer = new Timer(hint_timer_dur * 1000, 1);
			hint_timer.addEventListener(TimerEvent.TIMER, hintTimer);
			unhint_timer = new Timer(unhint_timer_dur * 1000, 1);
			unhint_timer.addEventListener(TimerEvent.TIMER, unhintTimer);
			
			//显示loading
			main_loading = new Loading(STAGE_WIDTH);
			main_loading.y = STAGE_HEIGHT * 3 / 5;
			addChild(main_loading);
			
			//加载主界面
			ui_ld = new Loader();
			ui_ld.contentLoaderInfo.addEventListener(Event.COMPLETE, uiComplete);
			ui_ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, uiError);
			ui_ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uiError);
			ui_ld.load(new URLRequest(vidConst.UI_DIR+ui_url));
			//ui_ld.load(new URLRequest("./ui_main.swf"));
//			ExternalInterface.addCallback("pauseVideo", pauseVideo);
		}
		//隐藏提示
		private function unhintTimer(e:TimerEvent) {
			if (ui_spt.video_mc.contains(hint_txt)) {
				ui_spt.video_mc.removeChild(hint_txt);
			}
		}
		//显示提示
		private function hintTimer(e:TimerEvent) {
			hint_txt.text = btn_hint_arr[btn_index];
			hint_txt.setTextFormat(hint_fmt);
			trace(btn_des_arr[btn_index]);
			var _btn:DisplayObject = ui_spt.video_mc.getChildByName(btn_des_arr[btn_index]+"_btn") as DisplayObject;

			hint_txt.x = _btn.x + _btn.width/2-hint_txt.width/2;
			//hint_txt.y = ui_spt.video_mc.mouseY-hint_txt.height;
			hint_txt.y = _btn.y - hint_txt.height-3;
			ui_spt.video_mc.addChild(hint_txt);
			unhint_timer.reset();
			unhint_timer.start();
		}
		private function stageFullScreen(e:FullScreenEvent):void {
			is_first_time = false;//修复全屏后bug
		}
		//主界面装载完毕
		private function uiComplete(e:Event):void {
			ui_ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, uiComplete);
			ui_ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, uiError);
			ui_ld.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, uiError);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,stageFullScreen);
			removeChild(main_loading);
			main_loading = null;
			ui_spt = e.target.content as Sprite;
			video_mc_x = ui_spt.video_mc.x;
			ui_spt.panel_cov.mouseEnabled = false;
			addChild(ui_spt);
			initUI();

			stage.fullScreenSourceRect=new Rectangle(ui_spt.video_mc.x+1,ui_spt.video_mc.y+1,VIDEO_WIDTH,VIDEO_HEIGHT);
			
			panel_mask = new Sprite();
			panel_mask.graphics.beginFill(0xFF0000,.4);
			panel_mask.graphics.drawRect(0, 0, ui_spt.panel_mc.width+2, ui_spt.panel_mc.height+2);
			panel_mask.x = ui_spt.panel_mc.x-1;
			panel_mask.y = ui_spt.panel_mc.y-1;
			ui_spt.addChild(panel_mask);
			ui_spt.panel_mc.mask = panel_mask;
			
			panel_loading = new Loading(panel_WIDTH);
			panel_loading.x = 595;
			panel_loading.y = 68;
			ui_spt.panel_mc.addChild(panel_loading);
			
			title_text = new titleText();
			//ui_spt.title_mc.det_btn.buttonMode = true;
			//ui_spt.title_mc.help_btn.buttonMode = true;
			//ui_spt.title_mc.det_btn.addEventListener(MouseEvent.MOUSE_OVER, detOver);
			//ui_spt.title_mc.det_btn.addEventListener(MouseEvent.MOUSE_OUT, detOut);
			ui_spt.title_mc.det_btn.addEventListener(MouseEvent.CLICK, detClick);
			ui_spt.title_mc.help_btn.addEventListener(MouseEvent.CLICK, helpClick);
			ui_spt.title_mc.addChild(title_text);
			
			//ad_ld = new URLLoader();
			//ad_ld.addEventListener(Event.COMPLETE, adComplete);
			//ad_ld.addEventListener(IOErrorEvent.IO_ERROR, adError);
			//ad_ld.addEventListener(SecurityErrorEvent.SECURITY_ERROR, adError);
			//ad_ld.load(new URLRequest(ad_url));
			
			//ad_out_timer = new Timer(ad_out_timer_dur * 1000, 1);
			//ad_out_timer.addEventListener(TimerEvent.TIMER, adError);
			//ad_out_timer.start();
			
			is_first_time = true;
			first_timer = new Timer(first_timer_dur * 1000, 1);
			first_timer.addEventListener(TimerEvent.TIMER, firstTimer);
			arrow_timer = new Timer(arrow_timer_dur * 1000, 1);
			arrow_timer.addEventListener(TimerEvent.TIMER, arrowTimer);
			first_timer.start();
			arrow_timer.start();
			
			initVideo();
		}
		//箭头计时器
		private function arrowTimer(e:TimerEvent):void {
			hideArrow();
		}
		//显示、隐藏箭头（视频和面板中间）
		private function showArrow() {
			TweenLite.killTweensOf(ui_spt.video_mc.arrow_btn);
			TweenLite.to(ui_spt.video_mc.arrow_btn, 1, { alpha:1 } );
		}
		private function hideArrow() {
			TweenLite.killTweensOf(ui_spt.video_mc.arrow_btn);
			TweenLite.to(ui_spt.video_mc.arrow_btn, 1, { alpha:0 } );
		}
		//第一次运行时，一定时间后视频居中
		private function firstTimer(e:TimerEvent):void {
			if(is_first_time){
				arrowClick(new MouseEvent(MouseEvent.CLICK));
			}else {
				first_timer.reset();
			}
		}
		//右上角部分的鼠标事件，
		private function detOver(e:MouseEvent):void{
			title_text.setOver();
		}
		private function detOut(e:MouseEvent):void{
			title_text.setOut();
		}
		//
		private function detClick(e:MouseEvent):void{
			showPanel(0);
		}
		//帮助
		private function helpClick(e:MouseEvent) {
			trace("ShowPlayerHelp");
			try {
				ExternalInterface.call("ShowPlayerHelp");
			}
			catch (e:Error) {
				
			}
		}
		//广告配置加载完成
		private function adComplete(e:Event) {
			//remove listerner
			ad_ld.removeEventListener(Event.COMPLETE, adComplete);
			ad_ld.removeEventListener(IOErrorEvent.IO_ERROR, adError);
			ad_ld.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, adError);
			
			//trace("is_ad_ready");
			is_ad_ready = true;
			ad_out_timer.reset();
			ad_out_timer.removeEventListener(TimerEvent.TIMER, adError);
			
			ad_spt = new Sprite();
			ad_mask = new Sprite();			
			ad_mask.graphics.beginFill(0x00FF00);
			ad_mask.graphics.drawRect(0, 0, VIDEO_WIDTH, VIDEO_HEIGHT);
			ad_mask.graphics.endFill();
			ui_spt.video_mc.addChild(ad_mask);
			ui_spt.video_mc.addChild(ad_spt);
			ad_spt.mask = ad_mask;
			//parse ad_xml
			var xml_str:String = e.target.data.toString();
			var my_index1=xml_str.lastIndexOf("<root");
			var my_index2=xml_str.lastIndexOf("</root>");
			if ((my_index2!=-1)&&(my_index1!=-1)&&(my_index1<my_index2)) {
				xml_str=xml_str.substring(my_index1,my_index2+7);
			} else {
				initVideo();
				trace("Failed to parse adv_configuration.");
				return;
			}
			var _xml:XML=new XML(xml_str);
			var _node:XMLList = _xml.position;
			//ad_buf = new advBuffer();
			ad_spt.addChild(ad_buf);
			//trace("_node length: " + _node.length());
			for each(var _item:* in _node) {
				var tmp_xml=_item.config;
				var _obj:Object = { };
				switch(String(_item.attribute("id")).substr(0,3)) {
					case "100"://文字广告
						//ad_txt= new advText(tmp_xml[0]);
						//ad_spt.addChild(ad_txt);
						break;
					case "101"://片头广告						
						//ad_buf.addAdv(_item);
						//_obj["starttime"] = int(_item.position.config.item.attribute("starttime"));
						//_obj["duration"] = int(_item.position.config.item.attribute("duration"));
						//_obj["content"] = String(_item.position.config.item.attribute("content"));
						//_obj["onclick"] = String(_item.position.config.item.attribute("onclick"));
						//adv_buffer = new advBuffer(_obj);
						//ui_spt.video_mc.addChild(adv_buffer);
						break;
					case "102"://暂停广告
						//_obj["starttime"] = int(_item.position.config.item.attribute("starttime"));
						//_obj["duration"] = int(_item.position.config.item.attribute("duration"));
						//_obj["content"] = String(_item.position.config.item.attribute("content"));
						//_obj["onclick"] = String(_item.position.config.item.attribute("onclick"));
						//adv_pause = new advPause(_obj);
						//ad_sprite.addChild(adv_pause);
						break;
					case "103"://1/4浮动广告
						//_obj["starttime"] = int(_item.position.config.item.attribute("starttime"));
						//_obj["duration"] = int(_item.position.config.item.attribute("duration"));
						//_obj["content"] = String(_item.position.config.item.attribute("content"));
						//_obj["onclick"] = String(_item.position.config.item.attribute("onclick"));
						//_obj["playcount"] = String(_item.position.config.item.attribute("playcount"));
						//adv_float = new advFloat(_obj);
						//ad_sprite.addChild(adv_float);
						break;
					default:
						break;
				}
			}
			initVideo();
		}
		//初始化界面
		private function initUI() {
			info_spt = new Sprite();
			recom_spt = new Sprite();
			epg_spt = new Sprite();
			chat_spt = new Sprite();
			//loadInfoUI();
			//loadRecomUI();
			//loadEpgUI();
			//loadChatUI();			
			cur_btn = def_btn;
			cur_spt = chat_spt;
			is_init_arr = [];
			panel_spt_arr = [epg_spt,chat_spt];
			panel_ld_arr = [loadEpgUI, loadChatUI];	//显示各面板的函数
			
			//btn_fun_arr = [epgClick, chatClick, tinyClick, airClick, helpClick, arrowClick];
			panel_ld_arr[def_btn]();//显示默认面板
			
			btn_arr = [];
			ui_spt.video_mc.chat_btn.visible = false;
			btn_arr = [ui_spt.video_mc.epg_btn, ui_spt.video_mc.chat_btn];
			ui_spt.video_mc.epg_btn.id = 0;
			ui_spt.video_mc.chat_btn.id = 1;
			//ui_spt.video_mc.epg_btn.mouseChildren = false;
			ui_spt.video_mc.epg_btn.buttonMode = true;
			ui_spt.video_mc.chat_btn.buttonMode = true;
			//ui_spt.video_mc.play_btn.buttonMode = true;
			ui_spt.video_mc.play_btn.mouseChildren = true;
			//ui_spt.video_mc.air_btn.buttonMode = true;
			ui_spt.video_mc.vol_btn.activate.buttonMode = true;
			ui_spt.video_mc.vol_btn.detail.buttonMode = true;
			ui_spt.video_mc.fls_btn.buttonMode = true;
			ui_spt.video_mc.arrow_btn.buttonMode = true;
			ui_spt.video_mc.arrow_btn.rotation = 180;
			ui_spt.video_mc.epg_btn.down.alpha=0; 
			ui_spt.video_mc.chat_btn.down.alpha=0; 
			if(def_btn==0){
				ui_spt.video_mc.epg_btn.down.alpha = 1; 
			}else if (def_btn == 1) {
				ui_spt.video_mc.chat_btn.down.alpha = 1; 
			}
			ui_spt.video_mc.play_btn.play_btn.visible = false;
			//ui_spt.video_mc.play_btn.down.visible = false;
			//ui_spt.video_mc.play_btn.over.visible = false;
			//ui_spt.video_mc.air_btn.down.visible = false;
			//ui_spt.video_mc.air_btn.over.visible = false;
			ui_spt.video_mc.fls_btn.over.visible = false;
			ui_spt.video_mc.arrow_btn.over.visible = false;
			
			addEventListener(MouseEvent.MOUSE_MOVE, showMouse);
			ui_spt.video_mc.epg_btn.addEventListener(MouseEvent.MOUSE_OVER, epgOver);
			ui_spt.video_mc.epg_btn.addEventListener(MouseEvent.MOUSE_OUT, epgOut);
			ui_spt.video_mc.epg_btn.addEventListener(MouseEvent.MOUSE_DOWN, epgClick);
			ui_spt.video_mc.chat_btn.addEventListener(MouseEvent.MOUSE_OVER, chatOver);
			ui_spt.video_mc.chat_btn.addEventListener(MouseEvent.MOUSE_OUT, chatOut);
			ui_spt.video_mc.chat_btn.addEventListener(MouseEvent.MOUSE_DOWN, chatClick);
			ui_spt.video_mc.arrow_btn.addEventListener(MouseEvent.MOUSE_OVER, arrowOver);
			ui_spt.video_mc.arrow_btn.addEventListener(MouseEvent.MOUSE_OUT,arrowOut);
			ui_spt.video_mc.arrow_btn.addEventListener(MouseEvent.CLICK, arrowClick);
			//comment @2009-06-16
			//var _num:int = ui_spt.video_mc.numChildren;
			//for (var i:int = 0; i < _num; i++) {
				//var _name:String = ui_spt.video_mc.getChildAt(i).name;
				//var _arr:Array = _name.split("_");
				//var _index:int = btn_des_arr.indexOf(_arr[0]);
				//if (_index > -1) {
					//btn_arr[_index] = ui_spt.video_mc.getChildAt(i);
					//btn_arr[_index].id = _index;
					//btn_arr[_index].buttonMode = true;
					//btn_arr[_index].down.visible = false;
					//btn_arr[_index].addEventListener(MouseEvent.MOUSE_OVER, btnOver);
					//btn_arr[_index].addEventListener(MouseEvent.MOUSE_OUT,btnOut);
					//btn_arr[_index].addEventListener(MouseEvent.CLICK,btn_fun_arr[_index]);
				//}
			//}
			//for (var j:int = 0; j < btn_arr.length; j++) {
				//if (j == cur_btn) {
					//btn_arr[j].out.visible = false;
					//btn_arr[j].down.visible = true;	
				//}
			//}
		}
		//鼠标移动事件
		private function showMouse(e:MouseEvent) {
			first_timer.reset();
			if (is_first_time) {
				first_timer.start();
			}
			Mouse.show();
			showArrow();
			arrow_timer.reset();
			arrow_timer.start();
		}
		//按钮的Mouse事件
		private function btnOver(e:MouseEvent) {
			e.currentTarget.out.visible = false;
			e.currentTarget.down.visible = true;
			btn_index = e.currentTarget.id;
			if (btn_index == -1) {
				btn_index = 0;
				return;
			}
			unhint_timer.reset();
			hint_timer.reset();
			hint_timer.start();
		}
		private function btnOut(e:MouseEvent) {
			if(e.currentTarget.id!=cur_btn || !is_open){
				e.currentTarget.out.visible = true;
				e.currentTarget.down.visible = false;
			}
			unhint_timer.reset();
			hint_timer.reset();
			unhintTimer(new TimerEvent(TimerEvent.TIMER));
		}
		//信息按钮点击
		private function infoClick(e:MouseEvent) {
			showPanel(e.currentTarget.id);
		}
		//相关推荐按钮点击
		private function recomClick(e:MouseEvent) {
			showPanel(e.currentTarget.id);
		}
		//epg按钮事件
		private function epgOver(e:MouseEvent) {
			btn_index = 0;//play_btn.index=2
			unhint_timer.reset();
			hint_timer.reset();
			hint_timer.start();
		}
		private function epgOut(e:MouseEvent) {
			unhint_timer.reset();
			hint_timer.reset();
			unhintTimer(new TimerEvent(TimerEvent.TIMER));
		}
		private function epgClick(e:MouseEvent) {
			showPanel(e.currentTarget.id);
		}
		//聊天按钮事件
		private function chatOver(e:MouseEvent) {
			btn_index = 1;//play_btn.index=2
			unhint_timer.reset();
			hint_timer.reset();
			hint_timer.start();
		}
		private function chatOut(e:MouseEvent) {
			unhint_timer.reset();
			hint_timer.reset();
			unhintTimer(new TimerEvent(TimerEvent.TIMER));
		}
		private function chatClick(e:MouseEvent) {
			showPanel(e.currentTarget.id);
		}		//箭头按钮事件
		private function arrowOver(e:MouseEvent) {
			//btn_index = 1;//play_btn.index=2
			//unhint_timer.reset();
			//hint_timer.reset();
			//hint_timer.start();
			e.currentTarget.over.visible = true;
			e.currentTarget.out.visible = false;
		}
		private function arrowOut(e:MouseEvent) {
			//unhint_timer.reset();
			//hint_timer.reset();
			//unhintTimer(new TimerEvent(TimerEvent.TIMER));
			e.currentTarget.out.visible = true;
			e.currentTarget.over.visible = false;
		}

		//最小化按钮
		private function tinyClick(e:MouseEvent) {
			if (ExternalInterface.available) {
				ExternalInterface.call("miniplayer", vid_cid, vid_timestamp);
			}
		}
		//回到直播按钮
		private function airClick(e:MouseEvent) {
			avideo.returnToLive();
		}
		//帮助按钮
		//private function helpClick(e:MouseEvent) {
			//
		//}
		//播放按钮
		private function playOver(e:MouseEvent) {
			btn_index = 2;//play_btn.index=2
			unhint_timer.reset();
			hint_timer.reset();
			hint_timer.start();
		}
		private function playOut(e:MouseEvent) {
			unhint_timer.reset();
			hint_timer.reset();
			unhintTimer(new TimerEvent(TimerEvent.TIMER));
		}
		private function playDown(e:MouseEvent):void {			
			if(!is_playing) {
				avideo.setResume();
				is_playing = true;
			}
		}
		//暂停视频
		private function pauseVideo() {
			if (is_playing) {
				avideo.setPause();
				is_playing = false;
			}
		}
		//暂停按钮按下
		private function pauseDown(e:MouseEvent) {
			if (is_playing) {
				avideo.setPause();
				is_playing = false;
			}
		}
		//回到直播按钮
		private function airOver(e:MouseEvent) {
			btn_index = 3;//air_btn.index=2
			unhint_timer.reset();
			hint_timer.reset();
			hint_timer.start();
		}
		private function airOut(e:MouseEvent) {
			unhint_timer.reset();
			hint_timer.reset();
			unhintTimer(new TimerEvent(TimerEvent.TIMER));
		}
		private function airDown(e:MouseEvent):void {
			avideo.returnToLive();
		}
		//音量
		private function volOver(e:MouseEvent) {
			btn_index = 4;//vol_btn.index=4
			unhint_timer.reset();
			hint_timer.reset();
			hint_timer.start();
		}
		private function volOut(e:MouseEvent) {
			unhint_timer.reset();
			hint_timer.reset();
			unhintTimer(new TimerEvent(TimerEvent.TIMER));
		}
		private function volActivateClick(e:MouseEvent) {
			if (is_mute) {//恢复原来声音
				avideo.setVol(video_vol);
				ui_spt.video_mc.vol_btn.activate.alpha = 1;
				ui_spt.video_mc.vol_btn.detail.slide.x = video_vol * vol_bar_length;//75为音量条长度
				is_mute = false;
			}else{//设置成静音
				video_vol = Number(avideo.getVol());	
				avideo.setVol(0);
				ui_spt.video_mc.vol_btn.activate.alpha = 0;
				ui_spt.video_mc.vol_btn.detail.slide.x = 0;
				is_mute = true;
			}			
		}
		//音量条事件
		private function volDetailDown(e:MouseEvent) {
			video_vol = Number(avideo.getVol());
			setVolume();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, volDetailMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, volDetailUp);
		}
		private function volDetailMove(e:MouseEvent) {
			setVolume();
		}
		private function volDetailUp(e:MouseEvent) {
			if (!ui_spt.video_mc.vol_btn.detail.slide.x) {
				is_mute = true;
				ui_spt.video_mc.vol_btn.activate.alpha = 0;
			}else {
				is_mute = false;
				ui_spt.video_mc.vol_btn.activate.alpha = 1;
			}
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, volDetailMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, volDetailUp);
		}
		//设置声音
		private function setVolume() {
			var _x:Number = ui_spt.video_mc.vol_btn.detail.mouseX;
			if (_x < 0) {
				_x = 0;
			}else if (_x > vol_bar_length) {
				_x = vol_bar_length;
			}
			//video_vol = _x/vol_bar_length;
			ui_spt.video_mc.vol_btn.detail.slide.x = _x;
			avideo.setVol(_x/vol_bar_length);
		}
		//全屏按钮
		private function flsOver(e:MouseEvent):void	{
			e.currentTarget.over.visible = true;
			e.currentTarget.out.visible = false;
			
			btn_index = 5;//air_btn.index=2
			unhint_timer.reset();
			hint_timer.reset();
			hint_timer.start();
		}
		private function flsOut(e:MouseEvent):void	{
			e.currentTarget.out.visible = true;
			e.currentTarget.over.visible = false;
			
			unhint_timer.reset();
			hint_timer.reset();
			unhintTimer(new TimerEvent(TimerEvent.TIMER));
		}
		private function flsClick(e:MouseEvent):void	{
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		//箭头点击
		private function arrowClick(e:MouseEvent) {
			is_first_time = false;
			first_timer.reset();
			//trace("arrowClick:"+is_open);
			
			if (is_open) {//关闭面板，视频居中
				ui_spt.video_mc.epg_btn.down.alpha = 0;
				ui_spt.panel_cov.mouseEnabled = true;
				TweenLite.to(ui_spt.panel_cov, 0.4, {alpha:1 } );
				ui_spt.video_mc.arrow_btn.rotation = 0;
				TweenLite.to(ui_spt.video_mc, 0.6, { x:(STAGE_WIDTH - VIDEO_WIDTH) / 2, delay:0.4 } );
				stage.fullScreenSourceRect=new Rectangle((STAGE_WIDTH-VIDEO_WIDTH)/2+1,ui_spt.video_mc.y+1,VIDEO_WIDTH,VIDEO_HEIGHT);
			}else {//打开面板
				ui_spt.video_mc.epg_btn.down.alpha = 1;
				ui_spt.panel_cov.mouseEnabled = false;
				TweenLite.to(ui_spt.panel_cov, 0.4, {alpha:0,delay:0.6} );
				ui_spt.video_mc.arrow_btn.rotation = 180;
				TweenLite.to(ui_spt.video_mc, 0.6, { x:video_mc_x } );
				stage.fullScreenSourceRect=new Rectangle(video_mc_x+1,ui_spt.video_mc.y+1,VIDEO_WIDTH,VIDEO_HEIGHT);
			}
			is_open = !is_open;
		}
		//加载主界面
		private function loadInfoUI() {
			info_ld = new Loader();
			info_ld.contentLoaderInfo.addEventListener(Event.COMPLETE, infoUIComplete);
			info_ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, infoUIError);
			info_ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, infoUIError);
			info_ld.load(new URLRequest(vidConst.UI_DIR+ui_info));
		}
		//加载推荐
		private function loadRecomUI() {
			recom_ld = new Loader();
			recom_ld.contentLoaderInfo.addEventListener(Event.COMPLETE, recomUIComplete);
			recom_ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, recomUIError);
			recom_ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, recomUIError);
			recom_ld.load(new URLRequest(vidConst.UI_DIR+ui_recom));
			
		}
		//加载EPG
		private function loadEpgUI() {
			epg_ld = new Loader();
			epg_ld.contentLoaderInfo.addEventListener(Event.COMPLETE, epgUIComplete);
			epg_ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, epgUIError);
			epg_ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, epgUIError);
//			epg_ld.load(new URLRequest(vidConst.UI_DIR+ui_epg+"?bbtv_channelid="+vid_cid+"&t="+Math.random()));
//			epg_ld.load(new URLRequest(vidConst.UI_DIR+ui_epg+"?apiHost="+apiHost));
			epg_ld.load(new URLRequest(vidConst.UI_DIR+ui_epg));
			trace(vidConst.UI_DIR+ui_epg+"?apiHost="+apiHost);
			//epg_ld.load(new URLRequest("http://localhost/ui_epg.swf?bbtv_channelid=220&t="+Math.random()));
		}
		//加载聊天
		private function loadChatUI() {		
			chat_ld = new Loader();
			chat_ld.contentLoaderInfo.addEventListener(Event.COMPLETE, chatUIComplete);
			chat_ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, chatUIError);
			chat_ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, chatUIError);
			chat_ld.load(new URLRequest(vidConst.UI_DIR+ui_chat));
			trace(vidConst.UI_DIR+ui_chat);
		}
		//显示某面板
		private function showPanel(_id:int) {
			hint_timer.reset();
			if (is_init_arr[_id]==null) {
				is_init_arr[_id] = 1;//已初始化
				panel_ld_arr[_id]();
			}
			if (_id < 0) {
				_id = 0;
			}
			//设置按下状态
			for (var i:int = 0; i < btn_arr.length; i++) {
				if (i != _id) {
					//btn_arr[i].out.visible = true;
					btn_arr[i].down.alpha=0;
				}else {
					//btn_arr[i].out.visible = false;
					btn_arr[i].down.alpha = 1;
				}
			}
			//
			if (is_open) {    
				if (_id == cur_btn) {
					for (var j:int = 0; j < btn_arr.length; j++) {
						//btn_arr[j].out.visible = true;
						btn_arr[j].down.alpha=0;				
					}
					arrowClick(new MouseEvent(MouseEvent.CLICK));
					return;
				}else {
					cur_btn = _id;
					switchPanel();     
				}
			}else {
				if(cur_btn != _id) {
					btn_arr[cur_btn].down.alpha=0;
					//btn_arr[cur_btn].out.visible = true;    
					cur_btn = _id;
					switchPanel();
				}
				arrowClick(new MouseEvent(MouseEvent.CLICK));
			}   
			
		}
		//面板之间的切换
		private function switchPanel() {
			//panel_spt_arr[cur_btn].x = -1000;
			//panel_spt_arr[next_btn].x = 0;
			//trace(cur_btn, next_btn);
			//if(ui_spt.panel_mc.contains(panel_spt_arr[cur_btn])){
				//ui_spt.panel_mc.removeChild(panel_spt_arr[cur_btn]);
			//}
			var _num:int = ui_spt.panel_mc.numChildren;
			//trace(ui_spt.panel_mc.getChildAt(0).name);
			for (var i:int = 1; i < _num; i++) {
				//trace(ui_spt.panel_mc.getChildAt(1).name);
				ui_spt.panel_mc.removeChildAt(1);
			}
			
			switch(cur_btn) {
				case 0:
				ui_spt.panel_mc.addChild(epg_spt);
				break;
				case 1:
				//trace(recom_spt);
				ui_spt.panel_mc.addChild(chat_spt);
				break;
				case 2:
				//trace(epg_spt);
				ui_spt.panel_mc.addChild(epg_spt);
				break;
				case 3:
				//trace(chat_spt);
				ui_spt.panel_mc.addChild(chat_spt);
				break;
				default:
				break;
			}
			
			//cur_btn = next_btn;
			//TweenLite.to(ui_spt.panel_cov, 0.4, {alpha:0} );
		}
		//信息面板加载完毕
		private function infoUIComplete(e:Event) {
			info_ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, infoUIComplete);
			info_ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, infoUIError);
			info_ld.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, infoUIError);
			
			//ui_spt.panel_mc.removeChild(panel_loading);
			info_spt = e.target.content as Sprite;
			ui_spt.panel_mc.addChild(info_spt);
			
			//info_obj = { };
			//info_obj.bbtv_title = "中国";
			info_spt.body.setInfo(info_obj);
			//info_spt.visible = false;
		}		
		//推荐面板加载完毕
		private function recomUIComplete(e:Event) {
			recom_ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, recomUIComplete);
			recom_ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, recomUIError);
			recom_ld.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, recomUIError);
			//trace("recomUI");
			//ui_spt.panel_mc.removeChild(panel_loading);
			recom_spt = e.target.content as Sprite;
			ui_spt.panel_mc.addChild(recom_spt);
			recom_spt.body.setRecom(recom_obj);
			//recom_spt.visible = false;
		}
		//EPG面板加载完成
		private function epgUIComplete(e:Event) {
			epg_ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, epgUIComplete);
			epg_ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, epgUIError);
			epg_ld.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, epgUIError);
			
			//trace("epgUI");
			//ui_spt.panel_mc.removeChild(panel_loading);
			epg_spt = e.target.content as Sprite;
			epg_spt.body.addEventListener("change_channel", epgChangeChanl);
			ui_spt.panel_mc.addChild(epg_spt);
			epg_spt.body.channelXMLInit(this.apiHost, this.video_type);
			//epg_spt.visible = false;
		}
		//聊天面板加载完成
		private function chatUIComplete(e:Event) {
			chat_ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, chatUIComplete);
			chat_ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, chatUIError);
			chat_ld.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, chatUIError);
			//trace("chatUI");
			//ui_spt.panel_mc.removeChild(panel_loading);
			chat_spt = e.target.content as Sprite;
			ui_spt.panel_mc.addChild(chat_spt);	
			//chat_spt.visible = false;
		}
		
		//侦听到EPG里切换节目的事件，通知avideo改变流
		private function epgChangeChanl(e:ChannelEvent):void {
//			avideo.changeChanl(e.currentTarget.change_url, uint(e.currentTarget.change_duration),"false",e.currentTarget.change_cid,e.currentTarget.change_stamp);
			avideo.changeChanl(e.param);
			avideo.live_url = channelInfoForChannelId(e.param.cid).live;
			var obj:* = e.currentTarget;
			title_text.resetText(obj.change_channel_name,obj.change_title,obj.change_date,obj.change_starttime);
		}
		private function channelInfoForChannelId(ccid:int):Object{
			for each(var obj:Object in channel_list){
				if(obj.id==ccid)return obj;
			}
			return {};
		}
		//初始化视频区域
		private function initVideo() {
			if(avideo!=null)return;
			var liveurl:String=channelInfoForChannelId(vid_cid).live;
			avideo = new aVideo( { cid:vid_cid, timestamp:vid_timestamp, endtimestamp:vid_endtimestamp, mode:vid_mode,liveurl:liveurl} );
			avideo.video_type = this.video_type;
			avideo.addEventListener(aVideo.PROG_CHANGED, progChange);
			avideo.addEventListener(aVideo.STATUS_CHANGED, statusChange);
			avideo.x = avideo.y = 1;
			ui_spt.video_mc.addChildAt(avideo, 1);
			var c_title:String = channelInfoForChannelId(vid_cid).name;
			title_text.resetText(c_title);
			
			scroll_text = new scrollText(537, 17);
			scroll_text.x = (VIDEO_WIDTH - 537) / 2;
			scroll_text.y = 4;
			scroll_text.addEventListener(scroll_text.CLOSE_SCROLL_TEXT, closeScrollText);
			//ui_spt.video_mc.addChild(scroll_text);
			
			//init control_btn_set
			ui_spt.video_mc.play_btn.addEventListener(MouseEvent.MOUSE_OVER, playOver);
			ui_spt.video_mc.play_btn.addEventListener(MouseEvent.MOUSE_OUT, playOut);
			ui_spt.video_mc.play_btn.play_btn.addEventListener(MouseEvent.CLICK, playDown);
			ui_spt.video_mc.play_btn.pause_btn.addEventListener(MouseEvent.CLICK, pauseDown);
			ui_spt.video_mc.air_btn.addEventListener(MouseEvent.MOUSE_OVER, airOver);
			ui_spt.video_mc.air_btn.addEventListener(MouseEvent.MOUSE_OUT, airOut);
			ui_spt.video_mc.air_btn.addEventListener(MouseEvent.MOUSE_DOWN, airDown);
			ui_spt.video_mc.vol_btn.activate.addEventListener(MouseEvent.MOUSE_DOWN, volActivateClick);
			ui_spt.video_mc.vol_btn.detail.addEventListener(MouseEvent.MOUSE_DOWN, volDetailDown);
			ui_spt.video_mc.vol_btn.addEventListener(MouseEvent.MOUSE_OVER, volOver);
			ui_spt.video_mc.vol_btn.addEventListener(MouseEvent.MOUSE_OUT, volOut);
			ui_spt.video_mc.fls_btn.addEventListener(MouseEvent.MOUSE_OVER, flsOver);
			ui_spt.video_mc.fls_btn.addEventListener(MouseEvent.MOUSE_OUT, flsOut);
			ui_spt.video_mc.fls_btn.addEventListener(MouseEvent.MOUSE_DOWN, flsClick );
		}		
		//关闭滚动文本广告
		private function closeScrollText(e:Event):void {
			if (ui_spt.video_mc.contains(scroll_text)) {
				ui_spt.video_mc.removeChild(scroll_text);
			}
		}
		//侦听到avideo里加载完当前节目的详细信息后，通知js改变相关推荐，通知head改变
		private function progChange(e:Event) {
			//通知EPG当前正在播放的节目cid和timestamp
			if(is_init_arr[0]){
				epg_spt.body.playing_timestamp=avideo.tstamp_name;
				epg_spt.body.playing_cid = avideo.id_name;
			}
			//调用js，改变相关推荐（位于flash下方）
			if (ExternalInterface.available) {
				ExternalInterface.call("getJSBuddies", avideo.chanl_name,avideo.category_name,0);
			}
			//刷新项目信息，位于视频上方的文字
			title_text.resetText(avideo.chanl_name,avideo.prog_name,avideo.date_name,avideo.time_name);
		}
		//视频状态改变
		private function statusChange(e:Event) {
			switch(avideo.playing_status) {
				case "playing":
				is_playing = true;
				ui_spt.video_mc.play_btn.play_btn.visible = false;
				ui_spt.video_mc.play_btn.pause_btn.visible = true;
				video_vol = avideo.getVol();
				ui_spt.video_mc.vol_btn.detail.slide.x = video_vol * vol_bar_length;
				break;
				default:
				is_playing = false;
				ui_spt.video_mc.play_btn.play_btn.visible = true;
				ui_spt.video_mc.play_btn.pause_btn.visible = false;
				break;
			}
		}
		//各种错误信息
		private function uiError(e:Event):void {
			trace("fail to load ui.");
		}
		private function infoUIError(e:Event):void {
			trace("fail to load info_ui");
		}
		private function recomUIError(e:Event):void {
			trace("fail to load recom_ui");
		}
		private function epgUIError(e:Event):void {
			trace("fail to load epg_ui");
		}
		private function chatUIError(e:Event):void {
			trace("fail to load chat_ui");
		}
		//广告加载失败
		private function adError(e:Event):void {
			trace("fail to load adv.xml");
			ad_ld.close();
			ad_out_timer.removeEventListener(TimerEvent.TIMER, adError);
			ad_ld.removeEventListener(Event.COMPLETE, adComplete);
			ad_ld.removeEventListener(IOErrorEvent.IO_ERROR, adError);
			ad_ld.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, adError);
			initVideo();
			/////////////////////////////////////////////
			///////////广告配置文件加载失败/////////////
			////////////////////////////////////////////
		}
	}
	
}