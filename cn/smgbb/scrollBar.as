package cn.smgbb{
	//可视化相关类
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	//加载相关类
	import flash.display.Loader;
	import flash.net.URLRequest;
	//计时器类
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	//事件类
	import flash.events.MouseEvent;
	import flash.events.Event;
	//矩形类
	import flash.geom.Rectangle;

	//类及变量声明
	//======================================================================================//
	public class scrollBar extends MovieClip {
		//列表容器
		private var scrollMC:Sprite=new Sprite  ;
		//滚动区域宽
		private var _scrollWidth:Number=200;
		//滚动区域高
		private var _scrollHeigth:Number=100;
		//与滚动条相关联的对象（即被滚动条操作的对象）
		private var _mc:Sprite;
		//遮照MC
		private var mask_mc:Sprite=new Sprite  ;
		//滑道
		private var slide_mc:MovieClip;
		//滑块
		private var glide_btn:SimpleButton;
		//滑块容器
		private var glideMC:Sprite=new Sprite  ;
		//移动被滚动对象计时器
		private var moveTimer:Timer;

		//======================================================================================//
		//构造函数
		public function scrollBar():void {
			//init();
		}
		//初始化
		private function init() {
			//
		}
		//
		//======================================================================================//
		/**
		//提供给外部设置的属性
		**/
		//================================================》
		//与滚动条相关联的对象（即谁使用滚动条）
		//设置后才生成滚动条
		public function set mc(mc:Sprite) {
			_mc=mc;
			loadUI();
		}
		//================================================》
		//滚动区域宽
		public function set scrollWidth(scrollWidth:Number) {
			_scrollWidth=scrollWidth;
		}
		//================================================》
		//滚动区域高
		public function set scrollHeigth(scrollHeigth:Number) {
			_scrollHeigth=scrollHeigth;
		}
		// 
		//======================================================================================//
		/**
		以下为类内部函数
		**/
		//================================================》
		//加载滚动条UI
		private function loadUI() {
			//加载显示风格UI
			var url:URLRequest=new URLRequest("ScrollUI.swf");
			var UIloader:Loader=new Loader  ;
			UIloader.load(url);
			UIloader.contentLoaderInfo.addEventListener(Event.COMPLETE,drawUI);
		}
		//================================================》
		//生成滚动条
		private function drawUI(e:Event) {
			//对滚动滑道类引用
			var slide:Class=e.target.content.slide_mc.constructor  as  Class;
			//对滚动滑块类引用
			var glide:Class=e.target.content.glide_btn.constructor  as  Class;
			slide_mc=new slide  ;
			glide_btn=new glide  ;
			//滚动滑块按下
			glide_btn.addEventListener(MouseEvent.MOUSE_DOWN,glide_btnMouseDown);

			//设置滚动条的位置（为被滚动对象的坐标＋滚动区域的宽度－滑道的宽度）
			scrollMC.x=_mc.x + _scrollWidth - slide_mc.width;
			scrollMC.y=_mc.y;
			//设置滑道的高
			slide_mc.height=_scrollHeigth;
			//显示
			//由于滑块是个按扭没有拖动时间所以先将其放入MC容器glideMC
			glideMC.addChild(glide_btn);
			scrollMC.addChild(slide_mc);
			scrollMC.addChild(glideMC);
			addChild(scrollMC);
			//创建遮照
			mask_mc.graphics.beginFill(0xFFFFFF);
			mask_mc.graphics.drawRect(0,0,_scrollWidth,_scrollHeigth);
			mask_mc.graphics.endFill();
			mask_mc.width-= glide_btn.width + 3;
			addChild(mask_mc);
			//绑定
			_mc.mask=mask_mc;
			//鼠标滚动事件
			parent.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
			//移动被滚动对象计时器初始化
			moveTimer=new Timer(50,0);
			moveTimer.addEventListener(TimerEvent.TIMER,moveMC);
		}
		//================================================》
		//移动滚动对象
		private function moveMC(e:Event) {
			var bfb:Number=glideMC.y /(slide_mc.height - glide_btn.height);
			_mc.y=-bfb * (_mc.height - slide_mc.height);
		}
		//================================================》
		//鼠标滚动
		private function mouseWheel(e:MouseEvent) {
			moveTimer.start();
			var _delta:int=e.delta;
			if (glideMC.y>0&&_delta>0) {
				glideMC.y-=2;
			}
			if (glideMC.y<(slide_mc.height-glide_btn.height-0.1)&&_delta<0) {
				glideMC.y+=2;
			}
		}
		//================================================》
		//滑块按下
		private function glide_btnMouseDown(e:MouseEvent) {
			//拖动范围矩形（为在滑道上的距离）
			var Rect:Rectangle=new Rectangle(0,0,0,slide_mc.height - glide_btn.height);
			glideMC.startDrag(false,Rect);
			moveTimer.start();
			//鼠标松开停止拖动加在舞台上
			stage.addEventListener(MouseEvent.MOUSE_UP,stageMouseUp);
		}
		//================================================》
		//鼠标松开左键
		private function stageMouseUp(e:MouseEvent) {
			glideMC.stopDrag();
			moveTimer.stop();
			stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseUp);
		}
	}
}