package cn.smgbb
{
	import flash.events.Event;
	
	public class ChannelEvent extends Event
	{
		public var param:Object = {};
		public function ChannelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}