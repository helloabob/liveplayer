package cn.smgbb
{
	/*更新节目信息，位于最上方*/
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class titleText extends Sprite
	{
		private var title_txt:TextField;
		private var title_fmt:TextFormat;
		private var time_txt:TextField;
		private var time_fmt:TextFormat;
		private var det_fmt:TextFormat;
		private var det_txt:TextField;
		private const DAY_ARR:Array = ["日","一","二","三","四","五","六"];
		public function titleText() {
			init();
		}
		private function init() {
			title_fmt = new TextFormat();
			title_fmt.color = 0x333333;
			title_fmt.size = 20;
			title_fmt.bold = true;
			
			title_txt = new TextField();
			title_txt.x = 18;
			title_txt.y = 3;
			title_txt.width = 600;
			title_txt.autoSize = "left";
			title_txt.multiline = false;
			title_txt.wordWrap = false;
			title_txt.mouseEnabled = false;
			title_txt.setTextFormat(title_fmt);
			addChild(title_txt);
			
			time_fmt = new TextFormat();
			time_fmt.color = 0x333333;
			time_fmt.size = 12;
			
			time_txt = new TextField();
			time_txt.x = 18;
			time_txt.y = 38;
			time_txt.width = 600;
			time_txt.autoSize = "left";
			time_txt.multiline = false;
			time_txt.wordWrap = false;
			time_txt.mouseEnabled = false;
			time_txt.setTextFormat(time_fmt);
			addChild(time_txt);
			
			det_fmt = new TextFormat();
			det_fmt.underline = true;
			
			det_txt = new TextField();
			det_txt.text = "详细信息";
			det_txt.x = 900;
			det_txt.y = 35;
			det_txt.autoSize = "left";			
			det_txt.setTextFormat(det_fmt);
			//addChild(det_txt);
			
			mouseChildren = false;
			mouseEnabled = false;
		}
		public function resetText(_chl:String="东方卫视", _pro:String="直播", _day:String="2009-04-28", _time:String="06:05:00") {
			title_txt.text = _chl + "  -  " + _pro;
			title_txt.setTextFormat(title_fmt);
			
			
			var _arr:Array = _day.split("-");
			var _date:Date = new Date(_arr[1]+"/"+_arr[2]+"/"+_arr[0]);
			time_txt.text = "播出时间：" + _arr[0] + "年" + _arr[1] + "月" + _arr[2] + "日 星期" + DAY_ARR[_date.getDay()] + " " + _time.substr(0, 5);
			time_txt.setTextFormat(time_fmt);
		}
		public function setOver() {
			det_fmt.underline = false;
			det_txt.setTextFormat(det_fmt);
		}
		public function setOut() {
			det_fmt.underline = true;
			det_txt.setTextFormat(det_fmt);
		}
	}
	
}