package cn.smgbb
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class EPGUtil
	{
		public function EPGUtil()
		{
		}
		
		/**
		 * 节目单数据字典,以频道ID+日期作为key，例如: dict[104-2015-01-01]=xxx
		 */
		private static var programDict:Dictionary = new Dictionary();
		
		/**
		 * 查询指定频道，日期，某个时间戳下的点播/直播节目数据
		 * @param cid 频道ID
		 * @param func 回调函数，传递object对象，同步/异步
		 * @param date 日期 格式 2015-01-01 直播传null
		 * @param timestamp 时间戳 字符串 直播传null
		 */
		public static function getVodInfo(cid:String,func:Function, date:String=null, timestamp:String=null):void {
			trace("getVodInfo:"+cid+"-"+func);
			if(date==null)date=Constants.parseDate(new Date());
			var key:String = cid + "-" + date;
			if(programDict[key]){
				func(parseAndGetInfo(key,timestamp));
			}else{
				loadEPGInfo(cid,date,timestamp,func);
			}
		}
		
		/**
		 * 加载节目单
		 */
		private static function loadEPGInfo(cid:String, date:String,timestamp:String=null, func:Function=null):void{
			var url:String = Constants.programListUrl.replace("{0}",cid).replace("{1}",date);
			var urlloader:URLLoader = new URLLoader();
			urlloader.addEventListener(Event.COMPLETE,onComplete);
			urlloader.load(new URLRequest(url));
			function onComplete(evt:Event):void{
				var key:String = cid + "-" + date;
				programDict[key] = new XML(evt.target.data);
				if(func)func(parseAndGetInfo(key,timestamp));
			}
		}
		
		/**
		 * 解析节目单
		 */
		private static function parseAndGetInfo(key:String, timestamp:String=null):Object{
			if(programDict[key]==null)return null;
			var now_timestamp:int=new Date().getTime()/1000;
			var is_live:Boolean = timestamp==null?true:false;
			var xml:XML = programDict[key];
			var prog_node:XMLList =xml.channel;
			var len:int = prog_node.children().length();
			var obj:Object = {};
			for (var i:int=0; i<len; i++) {
				var _arr:XML= prog_node.children()[i];
				var starttime:String = _arr.child("starttime");
				var endtime:String = _arr.child("endtime");
				var ts:String = _arr.child("timestamp");
				if(is_live==false&&timestamp==ts){
					obj.starttime=starttime;
					obj.endtime=endtime;
					break;
				}else if(is_live==true&&int(ts)>now_timestamp){
					var _tmp:XML = prog_node.children()[i-1];
					obj.starttime = _tmp.child("starttime");
					obj.endtime = _tmp.child("endtime");
					break;
				}
			}
			if(obj.starttime==null&&is_live==true){
				var _tmp2:XML = prog_node.children()[len-1];
				obj.starttime = _tmp2.child("starttime");
				obj.endtime = _tmp2.child("endtime");
			}
			return obj;
		}
	}
}