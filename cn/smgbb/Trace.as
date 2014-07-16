package cn.smgbb
{
	import flash.external.ExternalInterface;
	public class Trace
	{
		public function Trace()
		{
		}
		public static function log(str:String):void{
			trace(str);
			ExternalInterface.call("console.log",str);
		}
	}
}