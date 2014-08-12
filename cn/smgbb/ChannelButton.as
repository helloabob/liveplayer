package cn.smgbb
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class ChannelButton extends Sprite
	{
		//border :  ffcd00  
		//textColor:   ffcd00
		
		private var w:int = 100;
		private var h:int = 20;
		public var id:int = -1;
		private var cid:int = 0;
		
		public var over:Sprite=new Sprite();
		private var hover:Sprite = new Sprite();
		private var titleText:TextField;
		public function ChannelButton(title:String="东方卫视",channelID:int=216)
		{
			cid = channelID;
			graphics.clear();
			graphics.beginFill(0x000000,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			
			titleText = new TextField();
			titleText.text = title;
			titleText.textColor = 0xffffff;
			titleText.width = w;
			titleText.y = 2;
			titleText.autoSize = TextFieldAutoSize.CENTER;
			addChild(titleText);
			
			hover.graphics.clear();
			hover.graphics.beginFill(0x000000,0);
			hover.graphics.drawRect(0,0,w,h);
			hover.graphics.endFill();
			addChild(hover);
		}
		public function set selected(value:Boolean):void{
			drawBorder(value);
		}
		private function drawBorder(value:Boolean):void{
			var color:uint = value?0xffcd00:0x333333;
			graphics.clear();
//			graphics.beginFill(color,1);
			graphics.lineStyle(1, color, 1);
			graphics.moveTo(0,0);
			graphics.lineTo(w,0);
			graphics.lineTo(w,h);
			graphics.lineTo(0,h);
			graphics.lineTo(0,0);
			graphics.endFill();
		}
	}
}