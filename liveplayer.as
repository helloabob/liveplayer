package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import cn.smgbb.vidPlayer;
	
	public class liveplayer extends Sprite
	{
		private function init (e:Event=null):void
		{   
			removeEventListener (Event.ADDED_TO_STAGE,init);
			var _obj:Object={};
			_obj.cid=this.loaderInfo.parameters.bbtv_channelid;
			_obj.starttimestamp=this.loaderInfo.parameters.bbtv_starttime;
			_obj.endtimestamp=this.loaderInfo.parameters.bbtv_endtime;
			_obj.bbtv_title=this.loaderInfo.parameters.bbtv_title;
			_obj.bbtv_channel=this.loaderInfo.parameters.bbtv_channel;
			_obj.bbtv_program=this.loaderInfo.parameters.bbtv_program;
			_obj.bbtv_type=this.loaderInfo.parameters.bbtv_type;
			_obj.bbtv_time=this.loaderInfo.parameters.bbtv_time;
			_obj.bbtv_key=this.loaderInfo.parameters.bbtv_key;
			_obj.bbtv_detail=this.loaderInfo.parameters.bbtv_detail;
			_obj.bbtv_recom_title=this.loaderInfo.parameters.bbtv_recom_title;
			_obj.bbtv_recom_channel=this.loaderInfo.parameters.bbtv_recom_channel;
			_obj.bbtv_recom_image=this.loaderInfo.parameters.bbtv_recom_image;
			_obj.bbtv_recom_link=this.loaderInfo.parameters.bbtv_recom_link;
			_obj.bbtv_recom_time=this.loaderInfo.parameters.bbtv_recom_time;
			_obj.video_type=this.loaderInfo.parameters.type;
//			_obj.video_type="1";
			var vid_player:vidPlayer=new vidPlayer(_obj);
			addChild(vid_player);
		}
		public function liveplayer()
		{
			
			this.addEventListener (Event.ADDED_TO_STAGE,init);//侦听类是否被添加到了舞台
			
			
		}
	}
}