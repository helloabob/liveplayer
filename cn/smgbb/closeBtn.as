package cn.smgbb
{
	/*关闭按钮*/
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	
	public class closeBtn extends Sprite
	{
		private var btn_radius:int;
		private var cross_thickness:int;
		private var bg1_color:uint;
		private var bg2_color:uint;
		private var cross_color:uint;
		private var bg1:Sprite;
		private var bg2:Sprite;
		private var cross:Sprite;
		public function closeBtn(_rad:int=100,_bg1_color:uint=0x333333,_bg2_color:uint=0xA0A0A0,_cross_color:uint=0xFFFFFF,_cross_thickness:int=1) {//radius
			btn_radius = _rad;
			bg1_color = _bg1_color;
			bg2_color = _bg2_color;
			cross_color = _cross_color;
			cross_thickness = _cross_thickness;
			init();
		}
		private function init() {
			bg1 = new Sprite();
			bg1.graphics.beginFill(bg1_color, 1);
			bg1.graphics.drawCircle(btn_radius, btn_radius, btn_radius);
			bg1.graphics.endFill();
			addChild(bg1);
			
			bg2 = new Sprite();//over
			bg2.graphics.beginFill(bg2_color, 1);
			bg2.graphics.drawCircle(btn_radius, btn_radius, btn_radius);
			bg2.graphics.endFill();
			//addChild(bg2);
			
			cross = new Sprite();
			cross.graphics.lineStyle(cross_thickness,cross_color);
			cross.graphics.moveTo(btn_radius/2,btn_radius/2);
			cross.graphics.lineTo(3 * btn_radius/2,3*btn_radius/2);
			cross.graphics.moveTo(3*btn_radius/2,btn_radius/2);
			cross.graphics.lineTo(btn_radius/2,3*btn_radius/2);
			addChild(cross);
			
			addEventListener(MouseEvent.MOUSE_OVER, thisOver);
			addEventListener(MouseEvent.MOUSE_OUT, thisOut);
		}
		
		private function thisOver(e:MouseEvent):void {
			if (contains(bg1)) {
				removeChild(bg1);
			}
			addChildAt(bg2,0);
		}
		private function thisOut(e:MouseEvent):void {
			if (contains(bg2)) {
				removeChild(bg2);
			}
			addChildAt(bg1,0);
		}
	}
	
}