﻿package cn.smgbb
{
	/*视频类*/
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.PluginInfoResource;
	import org.osmf.media.URLResource;
	import org.osmf.net.httpstreaming.hls.HLSPluginInfo;

	public class aVideo extends Sprite
	{
		private var is_first_time:Boolean=true;
		private var is_vid_ready:Boolean = false;
		private var _prog_name:String="";//节目名称
		private var _chanl_name:String = "";//频道
		private var _date_name:String;//日期
		private var _time_name:String;//时间
		private var _category_name:String;//category类型？
		private var _property_name:String;//属性？
		private var _id_name:int;//频道号
		private var _tstamp_name:int;//时间戳
		private var check_out_timer_dur:int = 2;//check加载[check_out_timer_dur]s超时
		private var check_url:String = "http://epg.bbtv.cn/interface/getepgprogram.aspx";//ld地址
		private var check_ld:URLLoader;//节目详细信息Loader
		private var check_out_timer:Timer;//超时
		//////////////////////////////视频参数/////////////////
		private var vid_url:String = "smgbb.swf";
		private var vid_mode:String = aVideo.MODE_LIVE;
		//private var vid_ui:String = "ui.swf";
		private var vid_cid:uint = 210;
		private var vid_timestamp:Number = 0;
		private var vid_endtimestamp:Number = 0;
		private var vid_end:Number;
		private var live_url:String="";
		//private var vid_site:String = "api.smgbb.tv";
		private var vid_site:String = "api.smgbb.tv";
		//private var vid_datarate:String = "64";
		private var vid_ld:Loader;
		private var tviecore;
		private var mps:MediaPlayerSprite;
		private var factory:MediaFactory;
		
		public var playing_status:String;
		public static const MODE_LIVE:String = "LIVE";
		public static const MODE_VOD:String = "VOD";
		public static const PROG_CHANGED:String = "program_changed";
		public static const STATUS_CHANGED:String = "status_changed";
		public static const AUTHOR_CHECK:String = "author_check";
		
		public function aVideo(_obj:Object) {
			//vid_timestamp = 1242612000;
			//vid_endtimestamp = 1242613500;
			if (_obj.cid) {
				vid_cid = uint(_obj.cid);
			}
			if (_obj.timestamp) {
				vid_timestamp = Number(_obj.timestamp);
			}
			if (_obj.endtimestamp) {
				vid_endtimestamp = Number(_obj.endtimestamp);
			}
			if (_obj.mode) {
				vid_mode = _obj.mode;
			}
			if (_obj.liveurl) {
				live_url = _obj.liveurl;
			}
			init();
		}
		private function init() {
//			check_ld = new URLLoader();//check当前时间戳对应的节目，获取节目时长
//			check_ld.addEventListener(Event.COMPLETE, checkComplete);
//			check_ld.addEventListener(SecurityErrorEvent.SECURITY_ERROR, checkError);
//			check_ld.addEventListener(IOErrorEvent.IO_ERROR, checkError);
//			check_out_timer = new Timer(check_out_timer_dur * 1000, 1);
//			check_out_timer.addEventListener(TimerEvent.TIMER, checkError);
//			
//			loadCheck();
			
			if(is_first_time){
				is_first_time=false;
				factory = new MediaFactory();
				factory.loadPlugin(new PluginInfoResource(new HLSPluginInfo()));
				mps=new MediaPlayerSprite();
				mps.width=544;
				mps.height=423;
				addChildAt(mps,0);
				is_vid_ready = true;
				newPlay2();
			}
			
		}
		//加载详细信息
		private function loadCheck() {
			check_out_timer.reset();
			check_out_timer.start();	
			trace("+++++++" + check_url + "?c=" + vid_cid + "&t=" + int(vid_timestamp));
			check_ld.load(new URLRequest(check_url+"?c="+vid_cid+"&t="+int(vid_timestamp)));
		}
		//加载完毕 
		private function checkComplete(e:Event) {
			check_out_timer.reset();
			
			var my_str:String = e.target.data.toString();
			var my_index1:int=my_str.lastIndexOf("<root");
			var my_index2:int=my_str.lastIndexOf("</root>");
			if ((my_index2!=-1)&&(my_index1!=-1)&&(my_index1<my_index2)) {
				my_str=my_str.substring(my_index1,my_index2+7);
			} else {//data format Error!
				trace("failed to parseCheckEpg");
				return;
			}
			//trace(my_str);
			var _xml:XML = new XML(my_str);
			//var _id:int = vidConst.CID_ARR.indexOf(vid_cid);
			//if(_id>=0){
//				_chanl_name = vidConst.CN_ARR[_id];
//			}
			_chanl_name = _xml.channel.attribute("name");
			trace(_chanl_name);
			vid_end = Number(_xml.channel.program.endtimestamp.toString());			
			_prog_name = _xml.channel.program.title.toString();
			_date_name = _xml.channel.attribute("date");
			_time_name = _xml.channel.program.starttime.toString();
			
			//////五星体育等节目没有版权时的解决方案，问migo////////////
			try {
				var _tmp_cid:String = _xml.channel.program.extension.property.attribute("id");
				//trace(_tmp_cid);
				if(_tmp_cid!=null && _tmp_cid!="0") {
					vid_cid = _tmp_cid;
				}
				
			}			
			catch(e)
			{
				trace("EEERERERERERERER");
			}
			/////////////////////////////////////////////////////////
			_id_name = vid_cid;
			_tstamp_name = int(_xml.channel.program.timestamp.toString());	
			_category_name = _xml.channel.program.extension.category;
			_property_name = _xml.channel.program.extension.property;
			dispatchEvent(new Event(aVideo.PROG_CHANGED));
			var _is24ago:String = _xml.channel.attribute("is24ago");
			
			if(_is24ago == "True")
			{
				//ExternalInterface.call("userauth");
			}
			
			if (is_first_time) {//未初始化
				is_first_time = false;
				vid_ld=new Loader();
				vid_ld.contentLoaderInfo.addEventListener(Event.COMPLETE,vidComplete);
				vid_ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,vidError);
				vid_ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,vidError);
				vid_ld.load(new URLRequest(vidConst.UI_DIR+vid_url + "?mode=" + vid_mode + "&site=" + vid_site+"&autostart=false&days=30&cdnurlsuffixenable=true"));
			}else {//已完成初始化
				newPlay(vid_cid, vid_timestamp);
				//tviecore.externalPlay(vid_cid, vid_timestamp, vid_end, false);
				//tviecore.externalPlay(vid_cid, new Date().getTime() / 1000 + tviecore.timeOffSet()-1, vid_end,true);
			}
		}
		//装载视频swf完毕
		private function vidComplete(e:Event) {//loading video completed
			is_vid_ready = true;
			vid_ld.contentLoaderInfo.removeEventListener(Event.COMPLETE,vidComplete);
			vid_ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,vidError);
			vid_ld.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,vidError);
			tviecore=vid_ld.contentLoaderInfo.content as Sprite;
			addChildAt(tviecore, 0);
			tviecore.start();
			tviecore.sendUICommand("UI_COMMAND_REGISTER_PLAYER_STATE", onPlayerStateHandler);
			//tviecore.width = VIDEO_WIDTH;
			//tviecore.height = VIDEO_HEIGHT;
			tviecore.x = 0;
			tviecore.y = 0;
			tviecore.width = 544;
			tviecore.height = 423;
			var _is_live:Boolean = false;
			//(vid_mode == aVideo.MODE_LIVE)?(_is_live = true):(_is_live = false);
			/////////////////////////isLive always equals false?//////////////////////////
			var maxtimestamp:Number = new Date().getTime() / 1000;
			if(vid_timestamp > maxtimestamp) 
			{
				vid_timestamp = maxtimestamp;
				vid_end = 0;
			}
			newPlay(vid_cid, vid_timestamp);
			//tviecore.externalPlay(vid_cid, vid_timestamp, vid_end, false);
			//returnToLive();
			//this.addEventListener(Event.ENTER_FRAME, onThisEnterFrame);
			setFSListener();
		}
		//视频状态改变
		private function onPlayerStateHandler(e:Object):void {
			playing_status = e.Info;
			dispatchEvent(new Event(aVideo.STATUS_CHANGED));
		}
		//全屏
		private function fsHandler(e:FullScreenEvent):void {
			if (!e.fullScreen) {
				tviecore.x = 0;
				tviecore.y = 0;
				tviecore.width = 544;
				tviecore.height = 423;
				//trace(tviecore.width);
			}
		}
		//装载swf 失败
		private function vidError(e:Event) {
			trace("fail to load vid.");
			/////////播放本地视频////////////
		}
		//装载详细信息失败
		private function checkError(e:Event):void {
			//error_class.error = "Failed to Load Channel Data.";
			trace("++++Failed to load check_epg:"+e.toString());
			
			check_out_timer.reset();	
			_prog_name = "直播节目";
			_date_name = "2000-01-01";
			_time_name = "00:00:00";
			_id_name = vid_cid;
			_tstamp_name = int(new Date().getTime()/1000);
			dispatchEvent(new Event(aVideo.PROG_CHANGED));
			
			if (is_first_time) {//初始化
				is_first_time = false;
				vid_ld=new Loader();
				vid_ld.contentLoaderInfo.addEventListener(Event.COMPLETE,vidComplete);
				vid_ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,vidError);
				vid_ld.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,vidError);
				vid_ld.load(new URLRequest(vidConst.UI_DIR+vid_url + "?mode=" + vid_mode + "&site=" + vid_site+"&autostart=false&days=30&cdnurlsuffixenable=true"));
			}else {//已完成初始化
				newPlay(vid_cid, vid_timestamp);
				//tviecore.externalPlay(vid_cid, vid_timestamp, vid_end, false);
				//tviecore.externalPlay(vid_cid, new Date().getTime() / 1000 + tviecore.timeOffSet()-1, vid_end,true);
			}
		}
		//换频道
		public function changeChanl(_cid:uint, _timestamp:Number) {
			if (is_vid_ready) {
				vid_cid = _cid;
				vid_timestamp = _timestamp;
				trace(vid_cid);
				live_url="http://segment.livehls.kksmg.com/m3u8/"+_cid+"_"+_timestamp+".m3u8";
				trace("live_url:"+live_url);
				newPlay2();
//				loadCheck();
				//tviecore.externalPlay(_cid,_timestamp,_end,_is_live);
			}
		}
		//返回直播
		public function returnToLive() {
			newPlay(vid_cid, 0);
		}
		//暂停恢复
		public function setResume() {
			if (!is_vid_ready) {
				return;
			}
			tviecore.sendUICommand("UI_COMMAND_RESUME",null);
		}
		//暂停
		public function setPause() {
			if (!is_vid_ready) {
				return;
			}
			tviecore.sendUICommand("UI_COMMAND_PAUSE",null);
		}
		//get 音量
		public function getVol():Number {
			if (!is_vid_ready) {
				return 0;
			}
			return tviecore.sendUICommand("UI_COMMAND_GET_SOUND",null);
		}
		//set 音量
		public function setVol(_num:Number = 0) {
			if (!is_vid_ready) {
				return;
			}
			if (_num < 0) {
				_num = 0;
			}else if(_num>1){
				_num = 1;
			}
			tviecore.sendUICommand("UI_COMMAND_SET_SOUND",_num);
		}
		//播放
		public function newPlay(_cid:int = 210, _timestamp:uint = 0) {
			//if (!_timestamp) {//if(_timestamp==0)
				//_timestamp = int(new Date().getTime() / 1000);
			//}
//			mps.media=factory.createMediaElement(new URLResource("http://segment.livehls.kksmg.com/hls/dfws/index.m3u8"));
			tviecore.sendUICommand("UI_COMMAND_PLAY",{cid:_cid,timeStamp:_timestamp});
		}
		public function newPlay2():void{
			mps.media=factory.createMediaElement(new URLResource(live_url));
		}
		//设置全屏事件侦听
		public function setFSListener() {
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, fsHandler);
		}
		//get
		public function get chanl_name():String {return _chanl_name;}
		public function get prog_name():String {return _prog_name;}
		public function get date_name():String {return _date_name;}
		public function get time_name():String {return _time_name;}
		public function get id_name():int {return _id_name;}		
		public function get tstamp_name():int {return _tstamp_name;}		
		public function get property_name():String {return _property_name;}		
		public function get category_name():String { return _category_name; }
	}	
}