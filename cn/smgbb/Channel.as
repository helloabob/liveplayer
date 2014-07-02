package cn.smgbb
{	
	/*频道，在小播放器中使用*/
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	
	public class Channel extends MovieClip
	{
		private var id:int;
		private var cid:int;
		private var prog_num:int = 0;
		private var chanl_name:String;
		private var date_des:String;
		private var start_time:String;
		private var end_time:String;
		private var playing_title:String;
		private var xml_dir:String = "http://www.smgbb.tv/interface/epgservice.aspx?src=flash";
		private var server_date:Date;
		private var client_date:Date;
		private var prog_arr:Array;
		private var xml_ld:URLLoader;
		
		private static var date_offset:int;
		
		private const CID_ARR:Array = [211,220,212,217,];//array of cid	
		private const CN_ARR:Array = ["生活时尚","外语频道","财经频道","娱乐频道",];//array of channel		
		
		public const CHECKING_COMPLETE:String = "checking_complete";//完成检测，通知父级显示信息
		
		public function Channel(_id:int,_date:Date) {
			id = _id;
			server_date = new Date();
			server_date = cloneDate(_date);
			init();
		}
		private function init() {
			cid = CID_ARR[id];
			chanl_name = CN_ARR[id];
			date_des =server_date.getFullYear()+"-"+addZero(server_date.getMonth()+1)+"-"+addZero(server_date.getDate());//e.g. 2009-03-23
			client_date = new Date();
			if (!Channel.date_offset) {
				Channel.date_offset = server_date.valueOf() - client_date.valueOf();
			}
			//trace("***date_offset: " + Channel.date_offset);
			
			xml_ld = new URLLoader();
			xml_ld.addEventListener(Event.COMPLETE, xmlComplete);
			xml_ld.addEventListener(SecurityErrorEvent.SECURITY_ERROR, xmlError);
			xml_ld.addEventListener(IOErrorEvent.IO_ERROR, xmlError);
			xml_ld.load(new URLRequest(xml_dir+"&cid="+CID_ARR[id]+"&pdate="+date_des));
		}
		private function xmlComplete(e:Event) {
			var my_str:String = e.target.data.toString();
			var my_index1:int=my_str.lastIndexOf("<root>");
			var my_index2:int=my_str.lastIndexOf("</root>");
			if ((my_index2!=-1)&&(my_index1!=-1)&&(my_index1<my_index2)) {
				my_str=my_str.substring(my_index1,my_index2+7);
			} else {//data format Error!
				trace("failed to load");
				return;
			}
			var _xml:XML=new XML(my_str);
			var prog_node:XMLList =_xml.channel;
			prog_num = prog_node.children().length();
			//var _len2:int = prog_node.children()[0].children().length();

			prog_arr = [];
			for (var i=0; i<prog_num; i++) {
				var _arr:XML= prog_node.children()[i];
				var _cont=new Program(cid,date_des,_arr.child("title"),_arr.child("type"),_arr.child("starttime"),_arr.child("timestamp"),_arr.child("endtime"));
				prog_arr.push(_cont);
			}
			updateProStatus();
		}
		
		private function cloneDate(_dt:Date):Date {
			var _date:Date = new Date(_dt.toString());
			return _date;
		}
		private function addZero(_int:int):String {
			if (_int <= 9) {
				return "0" + _int;
			}
			return String(_int);
		}
		private function xmlError(e:Event):void {
			trace("Failed to load epg.");
		}
		private function updateProStatus() {//called from this class
			client_date = new Date();
			server_date = new Date(client_date.valueOf() + Channel.date_offset);
			//trace("***"+server_date);
			var _id:int;
			for (_id=0; _id<prog_num; _id++) {
				if (prog_arr[_id].progStart > server_date) {
					break;
				}
			}
			if (_id) {
				start_time = addZero(prog_arr[_id - 1].progStart.getHours()) + ":" + addZero(prog_arr[_id - 1].progStart.getMinutes());
				end_time = addZero(prog_arr[_id - 1].progEnd.getHours()) + ":" + addZero(prog_arr[_id - 1].progEnd.getMinutes());
				playing_title = prog_arr[_id - 1].progTitle;
			}else {
				start_time = "--:--";
				end_time = "--:--";
				playing_title = "精彩节目即将开始！";
			}
			dispatchEvent(new Event(CHECKING_COMPLETE));
		}
		public function updateProgramStatus(_time:int) {//called from parent level
			var _id:int;
			for (_id=0; _id<prog_num; _id++) {
				if (prog_arr[_id].progStamp > _time) {
					break;
				}
			}
			if (_id && _id!=prog_num) {
				start_time = addZero(prog_arr[_id - 1].progStart.getHours()) + ":" + addZero(prog_arr[_id - 1].progStart.getMinutes());
				end_time = addZero(prog_arr[_id - 1].progEnd.getHours()) + ":" + addZero(prog_arr[_id - 1].progEnd.getMinutes());
				playing_title = prog_arr[_id - 1].progTitle;
			}else {
				start_time = "--:--";
				end_time = "--:--";
				playing_title = "点击观看更多精彩节目";
			}
			//trace("++++++++DISPATCH EVENT+++++++++");
			dispatchEvent(new Event(CHECKING_COMPLETE));
		}
		public function get ID():int {
			return id;
		}
		public function get startTime():String {
			return start_time;
		}
		public function get endTime():String {
			return end_time;
		}
		public function get Title():String {
			return playing_title;
		}
	}
	
}