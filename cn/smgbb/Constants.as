package cn.smgbb
{
	public class Constants
	{
		
//		public static const channelListUrl:String = "http://lms.smgtech.cn/interface/getChannelList.php?type={0}";
//		public static const serverTimeUrl:String = "http://lms.smgtech.cn/interface/getServerTime.php";
//		public static const programListUrl:String = "http://lms.smgtech.cn/interface/getProgramList.php?channelid={0}&date={1}";
//		public static const vodPrefixUrl:String = "http://lms.smgtech.cn/{0}";
		
//		public static const channelListUrl:String = "http://lms.xun-ao.com/interface/getChannelList.php?type={0}";
//		public static const serverTimeUrl:String = "http://lms.xun-ao.com/interface/getServerTime.php";
//		public static const programListUrl:String = "http://lms.xun-ao.com/interface/getProgramList.php?channelid={0}&date={1}";
//		public static const vodPrefixUrl:String = "http://lms.xun-ao.com/{0}";
		
//		public static const channelListUrl:String = "http://42.121.59.240:137/interface/getChannelList.php?type={0}";
//		public static const serverTimeUrl:String = "http://42.121.59.240:137/interface/getServerTime.php";
//		public static const programListUrl:String = "http://42.121.59.240:137/interface/getProgramList.php?channelid={0}&date={1}";
//		public static const vodPrefixUrl:String = "http://42.121.59.240:137/{0}";
		
		public static var channelListUrl:String = "http://{9}/interface/getChannelList.php?type={0}";
		public static var serverTimeUrl:String = "http://{9}/interface/getServerTime.php";
		public static var programListUrl:String = "http://{9}/interface/getProgramList.php?channelid={0}&date={1}";
		public static var vodPrefixUrl:String = "http://{9}/{0}";
		
		public static const defaultHost:String = "lms.csytv.com";
//		public static const defaultHost:String = "lms.xun-ao.com";
		
		public function Constants()
		{
		}
		
		//解析日期成yyyy-mm-dd的格式
		public static function parseDate(_date:Date):String {//e.g. 2008-12-26
			return _date.getFullYear() + "-" + addZero((_date.getMonth() + 1)) + "-" + addZero(_date.getDate());
		}
		//加个0
		private static function addZero(_int:int):String {
			if (_int <= 9) {
				return "0" + _int;
			}
			return String(_int);
		}
	}
}