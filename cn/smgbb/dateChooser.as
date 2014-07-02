package cn.smgbb
{
	/*日历组件，用于老版本，已弃用*/
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import gs.TweenLite;

	public class dateChooser extends MovieClip
	{
		private var is_open:Boolean = false;
		private var dc_date:Date;
		private var dc_dent:int = 1;//以前的天数
		private var dc_total:int ;
		private var dc_frame:Sprite;
		private var dc_mask:Sprite;
		private var arrow_sprite:Sprite;
		private var old_sprite:Sprite;//
		private var new_sprite:Sprite;
		private var old_fmt:TextFormat;//没有被选择的文本格式
		private var new_fmt:TextFormat;//选中日期的文本格式
		private var choosen_fmt:TextFormat;//
		private var over_fmt:TextFormat;//
		private var arrow_len:int = 4;
		private var dc_width:int =157;
		private var dc_height:int = 25;
		private var dc_round:int = 8;
		private var item_width:int = dc_width - 2;
		private var item_height:int = dc_height;
		private var item_round:int = 10;
		private var bg_alpha1:Number = 1;
		private var bg_alpha2:Number = 1;
		//private var dc_scale:int = 6;
		private var scale_tween_dur:Number = 0.3;
		private var glow_tween_dur:Number = 0.4;
		
		public var date_choosen:String;		
		public static const CHANGE_DATE:String = "change_date";
		public static const DATE_ARR:Array = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
		
		public function dateChooser(_date:Date,_total:int=10) {
			dc_date = cloneDate(_date);
			dc_total = _total + 2;
			init();
		}
		private function init() {
			dc_frame = new Sprite();
			dc_frame.graphics.lineStyle(1, 0xCFFCCC, .8);
			dc_frame.graphics.beginFill(0xFF3333, 0);
			dc_frame.graphics.drawRoundRect(0, 0, dc_width, dc_height, dc_round, dc_round);
			dc_frame.graphics.endFill();
			dc_frame.scale9Grid = new Rectangle(dc_round, dc_round, dc_width - 2 * dc_round, dc_height - 2 * dc_round);
			//addChild(dc_frame);
			
			dc_mask = new Sprite();
			dc_mask.graphics.beginFill(0x333333, 1);
			dc_mask.graphics.drawRect(0, 0, dc_width, dc_height+1);
			dc_mask.graphics.endFill();
			addChild(dc_mask);
			mask = dc_mask;
			
			initFmt();
			
			//var _fmt:TextFormat = new TextFormat();
			//_fmt.color = 0xFFFFFF;
			//_fmt.size = 12;
			//_fmt.align = "left";
			var _day:Date;
				var _str:String
				var _sprite:Sprite;
				var txt_sprite:Sprite;
				var _txt:TextField;
			_day=cloneDate(dc_date);
					//_day.setDate(_day.getDate()-dc_dent+i);
					_str = _day.getFullYear() + "-" + addZero(_day.getMonth() + 1) + "-" + addZero(_day.getDate())+"   "+DATE_ARR[_day.getDay()];//2009-01-19
					
					_sprite = new Sprite();
					//_sprite.x = 1;
					//_sprite.y = -( dc_height * i);
					_sprite.name = "item";
					//_sprite.graphics.lineStyle(1, 0xCCCCCC,1);
					_sprite.graphics.beginFill(0x000000,1);
					_sprite.graphics.drawRect(0, 0, item_width, item_height);
					_sprite.graphics.endFill();
					_sprite.buttonMode = true;
					_sprite.alpha = bg_alpha1;
					_sprite.graphics.endFill();
									
					txt_sprite = new Sprite();
					txt_sprite.name = "txt_sprite"+i;
					txt_sprite.x = 1;
					txt_sprite.y = -( dc_height * i);
					txt_sprite.mouseEnabled = false;
					_txt = new TextField();
					_txt.name = "date_txt";
					_txt.width = item_width;
					_txt.text = _str;
					_txt.autoSize = "left";
					_txt.x = 2;
					_txt.y = (item_height - _txt.height) / 2+1;
					_txt.mouseEnabled = false;
					_txt.setTextFormat(choosen_fmt); 					
					txt_sprite.addChild(_sprite);
					txt_sprite.addChild(_txt);
					addChild(txt_sprite);
					
					_sprite.addEventListener(MouseEvent.CLICK, thisOver);
			for (var i:int = 1; i <= dc_total; i++) {
				
				if (i) {
					var j:int= dc_total - i -1;
					_day=cloneDate(dc_date);
					
					_day.setDate(_day.getDate()-dc_dent-j);
					
					trace(_day);
					_str = _day.getFullYear() + "-" + addZero(_day.getMonth() + 1) + "-" + addZero(_day.getDate())+"   "+DATE_ARR[_day.getDay()];//2009-01-19
					
					
					_sprite = new Sprite();
					//_sprite.x = 1;
					//_sprite.y = -( dc_height * i);
					_sprite.name = "item";
					//_sprite.graphics.lineStyle(1, 0xCCCCCC,1);
					_sprite.graphics.beginFill(0x000000,1);
					_sprite.graphics.drawRect(0, 0, item_width, item_height);
					_sprite.graphics.endFill();
					_sprite.buttonMode = true;
					_sprite.alpha = bg_alpha1;
					_sprite.graphics.endFill();
									
					txt_sprite = new Sprite();
					txt_sprite.name = "txt_sprite"+i;
					txt_sprite.x = 1;
					txt_sprite.y = ( dc_height * i);//-( dc_height * i);
					txt_sprite.mouseEnabled = false;
					_txt = new TextField();
					_txt.name = "date_txt";
					_txt.width = item_width;
					_txt.text = _str;
					_txt.autoSize = "left";
					_txt.x = 2;
					_txt.y = (item_height - _txt.height) / 2;
					_txt.mouseEnabled = false;
					_txt.setTextFormat(old_fmt); 
					txt_sprite.addChild(_sprite);
					txt_sprite.addChild(_txt);
					addChild(txt_sprite);
					
					_sprite.addEventListener(MouseEvent.MOUSE_OVER, thisOver);
					_sprite.addEventListener(MouseEvent.MOUSE_OUT, thisOut);				
					_sprite.addEventListener(MouseEvent.CLICK, thisClick);
				}else {//choosen one
					
					//_sprite.addEventListener(MouseEvent.MOUSE_OUT, thisOut);				
					//_sprite.addEventListener(MouseEvent.CLICK, thisClick);
				}
			}
			new_sprite = this.getChildByName("txt_sprite"+int(dc_dent+dc_total-1)).getChildByName("item");
			updateTextColor();
			
			arrow_sprite = new Sprite();
			arrow_sprite.graphics.lineStyle(2, 0xFFFFCC, 1);
			arrow_sprite.graphics.moveTo(-arrow_len/2,arrow_len)
			arrow_sprite.graphics.lineTo(arrow_len/2,0);
			arrow_sprite.graphics.lineTo(-arrow_len/2, -arrow_len);
			arrow_sprite.x = dc_width - arrow_len - 12;
			arrow_sprite.y = dc_height - arrow_len-7;
			arrow_sprite.rotation = 90;
			addChild(arrow_sprite);
			//date_cb.rowCount = 4;
			//date_cb.selectedIndex=_dent;
			//date_cb.addEventListener(Event.CHANGE, dateChange);
			
			addEventListener(MouseEvent.MOUSE_OVER, dcOver);
			addEventListener(MouseEvent.MOUSE_OUT, dcOut);
		}
		private function initFmt() {
			old_fmt = new TextFormat();
			//old_fmt.font = "Verdana";
			old_fmt.color = 0xFFFFFF;
			old_fmt.bold = false;
			old_fmt.size = 14;
			old_fmt.align = "left";
			
			new_fmt = new TextFormat();
			//new_fmt.font = "Verdana";
			new_fmt.color = 0xFF9933;
			//new_fmt.bold = true;
			new_fmt.size = 14;
			new_fmt.align = "left";
			
			choosen_fmt=new TextFormat();
			//choosen_fmt.font = "Verdana";
			choosen_fmt.color = 0xFFFF99;
			//choosen_fmt.bold = true;
			choosen_fmt.size = 14;
			choosen_fmt.align = "left";
		}
		private function dcOver(e:MouseEvent) {
			TweenLite.to(dc_frame, scale_tween_dur, { scaleY:dc_total+1} );
			TweenLite.to(dc_mask, scale_tween_dur, { scaleY:dc_total + 1 } );
			arrow_sprite.rotation = 270;
			//TweenLite.to(arrow_sprite, scale_tween_dur, { rotation: -90, y:dc_height - arrow_len - 5} );
			//is_open = !is_open;
		}
		private function dcOut(e:MouseEvent) {
			TweenLite.to(dc_frame, scale_tween_dur, { scaleY:1} );
			TweenLite.to(dc_mask, scale_tween_dur, { scaleY:1 } );
			arrow_sprite.rotation = 90;
			//TweenLite.to(arrow_sprite, scale_tween_dur, { rotation: -90, y:dc_height - arrow_len - 5} );
		}
		//加"0"
		private function addZero(_int:int):String {
			if (_int <= 9) {
				return "0" + _int;
			}
			return String(_int);
		}
		//复制日期
		private function cloneDate(_dt:Date):Date {
			var _date:Date = new Date(_dt.toString());
			return _date;
		}
		private function thisOver(e:MouseEvent) {
			if (e.target.parent.name == "txt_sprite0") {
				return;
			}
			e.target.parent.getChildByName("date_txt").setTextFormat(choosen_fmt);
		}
		private function thisOut(e:MouseEvent) {
			TweenLite.to(e.target, glow_tween_dur * 2, { alpha:bg_alpha1 } );
			if(new_sprite!=e.target){
				e.target.parent.getChildByName("date_txt").setTextFormat(old_fmt);
			}else {
				e.target.parent.getChildByName("date_txt").setTextFormat(new_fmt);
			}
		}
		private function thisClick(e:MouseEvent) {
			old_sprite = new_sprite;
			new_sprite = e.target;
			updateTextColor();
			date_choosen = String(e.target.parent.getChildByName("date_txt").text).substr(0,10);
			e.target.parent.parent.getChildByName("txt_sprite0").getChildByName("date_txt").text = String(e.target.parent.getChildByName("date_txt").text);
			e.target.parent.parent.getChildByName("txt_sprite0").getChildByName("date_txt").setTextFormat(choosen_fmt);
			dispatchEvent(new Event(dateChooser.CHANGE_DATE));
			TweenLite.to(dc_frame, scale_tween_dur, { scaleY:1} );
			TweenLite.to(dc_mask, scale_tween_dur, { scaleY:1 } );
			arrow_sprite.rotation = 90;
		}
		private function updateTextColor() {
			if (old_sprite) {
				old_sprite.parent.getChildByName("date_txt").setTextFormat(old_fmt);
			}
			new_sprite.parent.getChildByName("date_txt").setTextFormat(new_fmt);
		}
	}
	
}