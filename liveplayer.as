package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import cn.smgbb.vidPlayer;
	
	public class liveplayer extends Sprite
	{
		public function liveplayer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onStageAdded);
		}
		private function onStageAdded(evt:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,onStageAdded);
			var _obj:Object={};
			_obj.cid=216;
			var vid:vidPlayer=new vidPlayer(_obj);
			addChild(vid);
		}
	}
}