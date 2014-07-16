package cn.smgbb
{
	/*EPG模块*/
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import gs.TweenLite;
	
	public class EPG extends MovieClip
	{
		private var is_config_ready:Boolean = false;//配置加载是否完成
		private var cal_indent:int = -6;//日历选择提前天数
		private var cal_total:int = 7;//日历选择总天数
		private var btn_index:int = 0;//按钮序列
		private var cur_num_pro:int = 0;//当前频道节目总数
		private var cur_id:int = 0;//当前频道序列
		private var workday1_color:uint = 0xBBBBBB;//日历颜色
		private var workday2_color:uint = 0xFFFFFF;
		private var weekend1_color:uint = 0x669933;
		private var weekend2_color:uint = 0xCBFF00;
		private var chanl_dur:Number = 1;//频道切换时间间隔
		private var hint_timer_dur:Number = 0.4;//提示显示
		private var unhint_timer_dur:Number = 2;//提示消失
		private var config_timer_dur:Number = 20;//装载超时
		private var epg_timer_dur:Number = 60;//装载超时
		private var hide_info_timer_dur:Number = 3;//装载超时显示时间
		private var update_timer_dur:Number = 60;//刷新EPG时间(s)
		private var date_des:String;//2008-02-03
		private var xml_dir:String ="http://prolist.kankanews.com/prolist";
//		private var xml_dir:String = "http://epg.bbtv.cn/interface/minixml";//EPG的路径
//		private var config_dir:String = "http://epg.bbtv.cn/interface/config.aspx";//配置文件路径
		private var config_dir:String="http://test.editor.com/getServerTime.php";
		private var hint_timer:Timer;//提示
		private var unhint_timer:Timer;//提示
		private var config_timer:Timer;//urlloader超时 
		private var epg_timer:Timer;//urlloader超时 
		private var hide_info_timer:Timer;//隐藏Info
		private var update_timer:Timer;//刷新EPG状态定时器
		private var config_ld:URLLoader;//配置
		private var epg_ld:URLLoader;//epg
		private var cont_spt:Sprite;//频道的容器，里面每个频道动态生成一个Sprite，存储该频道的epg，滚动也只针对单个频道，切换日期时先移除当前节目，但显示在同一频道的Sprite里
		private var cont_mask:Sprite;//容器的遮罩，mask用
		private var cont_cover:Sprite;//容器的遮罩，切换频道用
		private var cur_chanl:Sprite;//当前频道
		private var pre_chanl:Sprite;//之前一个频道
		private var future_txt:TextField;//未播放节目显示信息
		private var info_txt:TextField;//显示正在加载
		private var now_date:Date;//当前时间
		private var tmp_obj:Object;//临时Object
		private var id_arr:Array;//序列数组，元素为EPG.CID_ARR对应的元素在vidConst.CID_ARR中的index
		private var btn_array:Array;//按钮图标数组
		private var num_pro_arr:Array;//number of programs
		private var num_playing_arr:Array;//各频道现在播放节目序列的数组
		private var day_arr:Array = ["日", "一", "二", "三", "四", "五", "六"];
		private var month_arr:Array = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"];
		//////////////修改频道只需修改下面频道名称，全频道名称参见vidConst.as/////////////
		//EPG.fla文件里需要有全套的ICON		
		public static const CID_ARR:Array = [212, 215, 218, 220, 217, 216, 219, 210];//BBTV
		//public static const CID_ARR:Array = [212, 215, 218, 214, 220, 217, 211, 216, 219, 210,242,253,241,240,223,224,256,255,294,293,284,279,503,226,231,233,234];//.tv
		//public static const CID_ARR:Array = [1626, 1624, 1625, 1623, 1627, 1621, 1620, 1622, 1628,1629,1630];
		//public static const CN_ARR:Array = ["财经频道","纪实频道","艺术人文","五星体育","外语频道","娱乐频道","生活时尚","东方卫视","戏剧频道","新闻综合","电影频道","浙江卫视","湖南卫视",
		//"江苏卫视","北京卫视","哈哈少儿","炫动卡通","旅游卫视","广西卫视","极速汽车","游戏风云","法制天地", "娱乐前线","新闻资讯","中央二套","中央七套","中央九套","中央十套"];//array of channel

		private const NUM_PRO_SHOW:int = 14;//同时显示的节目数
		private const PRO_HEIGHT:int = 24;//单个节目高度
		private const CID_NUMBER:int = CID_ARR.length;//频道数

		public var def_cid:int = 241;//默认频道号	
		public var cur_cid:int;//当前频道CID
		
		public var change_cname:String="";
		
		public var change_cid:uint;//换频道时外部调用
		public var change_stamp:Number;	
		public var chanl_show:int = -1;//显示频道的序号
		public static const CHANGE_CHANL:String = "change_channel";//事件
		
		//for chanl_icon
		private var total_icon:int= CID_NUMBER;//总共频道图标按钮数
		private var shown_icon:int = 6;//一页显示的频道图标数
		private var cur_icon:int = 0;//当前激活图标id
		private var icon_width:Number = 48.6;//频道图标按钮间间隔
		private var icon_x:Number = 0;//第一个频道按钮坐标
		//for scroll_bar
		private const CHANL_TOP:int = 0;//top of channels
		private const SCROLL_TOP:int = -160;//dragger坐标y
		private const SCROLL_X:Number = -6.3;//dragger坐标x
		private const SCROLL_HEIGHT:int = 296;//可拖动范围
		private const SCROLL_DRAGGER_HEIGHT:int = 32;//dragger高度
		
		public function EPG(_cid:int=216) {
			def_cid = _cid;
			if (this.loaderInfo.parameters.bbtv_channelid != null) {//如果有loaderInfo信息
				def_cid=int(this.loaderInfo.parameters.bbtv_channelid);
			}
			if (vidConst.CID_ARR.indexOf(def_cid) <0) {//如果默认频道号不在列表中,取列表第一个
				def_cid =vidConst.CID_ARR[0];
			}else if (CID_ARR.indexOf(def_cid)< 0) {//不在CID_ARR列表中				
				def_cid = CID_ARR[0];//取第一个
			}
			cur_id = CID_ARR.indexOf(def_cid);
			epgInit();
		}
		//初始化
		private function epgInit():void {
			
			Security.allowDomain("*");	
			change_cid = def_cid;
			change_stamp = int(new Date().getTime() / 1000);
			btn_array = new Array();
			id_arr = new Array();
			num_pro_arr = new Array(total_icon);
			num_playing_arr = new Array(total_icon);
			
			var _num:int = chanl_set.numChildren;
			var j:int;
			var _id:int;
			for (j = 1; j < _num; j++) {//最底层是选中的状态，其它为频道按钮
				chanl_set.getChildAt(j).visible = false;
			}
			for (j = 0; j < total_icon; j++) {//根据CN_ARR的序列push对应的图标到btn_array中
				_id = Math.max(0, vidConst.CID_ARR.indexOf(CID_ARR[j]));
				id_arr.push(_id);
				chanl_set.getChildByName(vidConst.CHANL_ARR[_id]+"_btn").visible = true;
				chanl_set.getChildByName(vidConst.CHANL_ARR[_id] + "_btn").x = icon_x + j * icon_width;
				chanl_set.getChildByName(vidConst.CHANL_ARR[_id] + "_btn").y = 0;
				btn_array.push(chanl_set.getChildByName(vidConst.CHANL_ARR[_id] + "_btn") as MovieClip);				
			}
			//vidConst.setIndex(btn_array);
			
			//初始化提示信息
			hint.visible = false;
			hint_timer = new Timer(hint_timer_dur * 1000, 1);
			hint_timer.addEventListener(TimerEvent.TIMER, hintTimer);
			unhint_timer = new Timer(unhint_timer_dur * 1000, 1);
			unhint_timer.addEventListener(TimerEvent.TIMER, unhintTimer);
			
			//定时器
			config_timer = new Timer(config_timer_dur * 1000, 1);
			config_timer.addEventListener(TimerEvent.TIMER, configTimer);
			epg_timer = new Timer(epg_timer_dur * 1000, 1);
			epg_timer.addEventListener(TimerEvent.TIMER, epgTimer);
			hide_info_timer = new Timer(hide_info_timer_dur * 1000, 1);
			hide_info_timer.addEventListener(TimerEvent.TIMER, hideInfoTimer);
			
			update_timer = new Timer(update_timer_dur * 1000);
			update_timer.addEventListener(TimerEvent.TIMER, updateTimer);
			
			future_txt = new TextField();
			future_txt.mouseEnabled = false;
			future_txt.background = true;
			future_txt.backgroundColor = 0xFFFFFF;
			future_txt.text = "即将播出";
			future_txt.autoSize = TextFieldAutoSize.LEFT;
			
			info_txt = new TextField();
			info_txt.x = 1;
			info_txt.width = 335;
			info_txt.height = 20;
			info_txt.y = 337 - info_txt.height;
			info_txt.mouseEnabled = false;
			info_txt.background = true;
			info_txt.backgroundColor = 0x999999;
			info_txt.text = "正在加载数据...";
			info_txt.alpha = 0;
			
			// 加载配置文件
			now_date = new Date();
			date_des=parseDate(now_date);//2008-02-03
			config_ld = new URLLoader();
			config_ld.addEventListener(Event.COMPLETE, configComplete);
			config_ld.addEventListener(SecurityErrorEvent.SECURITY_ERROR, configError);
			config_ld.addEventListener(IOErrorEvent.IO_ERROR, configError);
			config_ld.load(new URLRequest(config_dir));
			config_timer.start();
			
			epg_ld= new URLLoader();			
		}		
		//更新EPG状态
		private function updateTimer(e:TimerEvent):void{
			updateProStatus();
		}
		//隐藏提示
		private function unhintTimer(e:TimerEvent) {
			hint.visible = false;
		}
		//提示
		private function hintTimer(e:TimerEvent) {
			hint.txt.text = vidConst.CN_ARR[vidConst.CID_ARR.indexOf(CID_ARR[btn_index])];
			hint.x = btn_array[btn_index].x + btn_array[btn_index].width/2+btn_array[btn_index].parent.x;
			hint.visible = true;
			unhint_timer.reset();
			unhint_timer.start();
		}
		//配置超时
		private function configTimer(E:TimerEvent) {
			config_timer.reset();
			hide_info_timer.reset();
			hide_info_timer.start();
			
			configError(new Event("Failed to Load CONFIG."));
		}
		//EPG超时
		private function epgTimer(E:TimerEvent) {
			ldError(new Event("Failed to Load EPG"));
			epg_timer.reset();
			hide_info_timer.reset();
			hide_info_timer.start();
		}
		//隐藏信息
		private function hideInfoTimer(e:TimerEvent) {
			hideInfo();
		}
		//配置文件装载完毕
		private function configComplete(e:Event) {
			config_timer.reset();
			config_ld.removeEventListener(Event.COMPLETE, configComplete);
			config_ld.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, configError);
			config_ld.removeEventListener(IOErrorEvent.IO_ERROR, configError);
			var cfg_str:String = e.target.data.toString();
			var my_index1=cfg_str.lastIndexOf("<config>");
			var my_index2=cfg_str.lastIndexOf("</config>");
			if ((my_index2!=-1)&&(my_index1!=-1)&&(my_index1<my_index2)) {
				cfg_str=cfg_str.substring(my_index1,my_index2+9);
			} else {
				trace("Failed to parse configuration.");
				return;
			}
			var _xml:XML=new XML(cfg_str);
			//date_des = _xml.child("systemdate");
			var time_str:String=_xml.child("systemtime");
			trace("time:"+time_str);
//			now_date.setFullYear(int(time_str.substr(0,4)));
//			now_date.setMonth(int(time_str.substr(5,2)-1));
//			now_date.setDate(int(time_str.substr(8,2)));
//			now_date.setHours(int(time_str.substr(11,2)));
//			now_date.setMinutes(int(time_str.substr(14,2)));
//			now_date.setSeconds(int(time_str.substr(17,2)));
			now_date.setFullYear(int(time_str.substr(0,4)));
			now_date.setMonth(int(time_str.substr(4,2))-1);
			now_date.setDate(int(time_str.substr(6,2)));
			now_date.setHours(int(time_str.substr(8,2)));
			now_date.setMinutes(int(time_str.substr(10,2)));
			now_date.setSeconds(int(time_str.substr(12,2)));
			date_des=parseDate(now_date);//2008-02-03

			initCont();
			initScroll();
			initCalendar();
			initChanlBtn();
			is_config_ready = true;
			loadDate(date_des, def_cid);
		}
		//初始化频道按钮
		private function initChanlBtn() {
			left_btn.addEventListener(MouseEvent.CLICK, leftClick);
			right_btn.addEventListener(MouseEvent.CLICK, rightClick);
			refreshSet();
			for (var i = 0; i < CID_NUMBER; i++) {
				btn_array[i].id = i;
				btn_array[i].over.visible = false;
				btn_array[i].buttonMode = true;
				btn_array[i].addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				btn_array[i].addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				btn_array[i].addEventListener(MouseEvent.CLICK, btnClick);
			}
		}
		//初始化EPG Sprite
		private function initCont() {
			cur_chanl = new Sprite();
			pre_chanl = new Sprite();
			cont_spt = new Sprite();
			cont_spt.y = 87;
			for (var i:int = 0; i < total_icon; i++) {
				var _spt:Sprite = new Sprite();
				_spt.name = "chanl" + i;
				cont_spt.addChild(_spt);
			}
			
			//遮罩
			cont_mask = new Sprite();
			cont_mask.graphics.beginFill(0x00FF00);
			cont_mask.graphics.drawRect(0, 0, 337, 337);
			cont_mask.graphics.endFill();
			cont_mask.y = cont_spt.y;
			
			//cover覆盖层
			cont_cover = new Sprite();
			cont_cover.graphics.beginFill(0x252525);
			cont_cover.graphics.drawRect(1, 0, 335, 337);
			cont_cover.graphics.endFill();
			cont_cover.y = cont_spt.y;
			cont_cover.alpha = 0;
			cont_cover.mouseEnabled = false;
			
			addChild(cont_spt);
			addChild(cont_mask);
			addChild(cont_cover);
			addChild(hint);
			cont_spt.mask = cont_mask;
		}
		
		//初始化日历
		private function initCalendar() {
			var _spt:Sprite;
			var _date:Date = cloneDate(now_date);
			_date.setTime(_date.valueOf() + 24 * 60 * 60 * 1000*(cal_total+cal_indent-1));//
			for (var i:int = cal_total; i >= 1; i--) {
				_spt = cal_spt.getChildByName("cal" + i) as MovieClip;
				_spt.date_des = parseDate(_date);//2008-02-03
				if (_date.getDay() == 0 || _date.getDay() == 6) {
					_spt.is_weekend = true;
					_spt.day_txt.textColor = weekend1_color;
				}else {
					_spt.is_weekend = false;
					_spt.day_txt.textColor = workday1_color;
				}
				_spt.day_txt.text = "星期" + day_arr[_date.getDay()];
				_spt.date_txt.text = addZero(_date.getDate());
				_spt.month_txt.text = month_arr[_date.getMonth()];
				_spt.mouseChildren = false;
				_spt.buttonMode = true;
				_spt.addEventListener(MouseEvent.MOUSE_OVER, calOver);
				_spt.addEventListener(MouseEvent.MOUSE_OUT, calOut);
				_spt.addEventListener(MouseEvent.MOUSE_DOWN, calDown);
				_date.setTime(_date.valueOf() - 24*60*60*1000);//一天后
			}
		}
		//日历事件
		private function calOver(e:MouseEvent) {
			if(e.currentTarget.is_weekend){
				e.currentTarget.day_txt.textColor = weekend2_color;
			}else {
				e.currentTarget.day_txt.textColor = workday2_color;
			}
		}
		private function calOut(e:MouseEvent) {
			if(e.currentTarget.is_weekend){
				e.currentTarget.day_txt.textColor = weekend1_color;
			}else {
				e.currentTarget.day_txt.textColor = workday1_color;
			}
		}
		private function calDown(e:MouseEvent) {
			if(e.currentTarget.is_weekend){
				e.currentTarget.day_txt.textColor = weekend2_color;
			}else {
				e.currentTarget.day_txt.textColor = workday2_color;
			}
			loadDate(e.currentTarget.date_des,cur_cid);
		}
		//左右箭头，移动频道图标
		private function rightClick(e:MouseEvent) {
			if (cur_icon >=total_icon - shown_icon) {
				return;
			}
			if (cur_icon + shown_icon - 1 <=total_icon - shown_icon) {
				cur_icon = cur_icon+shown_icon - 1;
			}else{
				cur_icon = total_icon - shown_icon;
			}
			
			refreshSet();
		}
		private function leftClick(e:MouseEvent) {
			if (cur_icon <=0) {
				return;
			}
			if (cur_icon - shown_icon - 1 >= 0) {
				cur_icon = cur_icon-shown_icon + 1;
			}else{
				cur_icon = 0;
			}
			refreshSet();
		}
		//移动图标
		private function refreshSet() {//刷新频道按钮栏
			if (cur_icon >= total_icon - shown_icon) {
				right_btn.enabled = false;
				right_btn_off.visible = true;
			}else {
				right_btn.enabled = true;
				right_btn_off.visible = false;
			}
			if (!cur_icon) {
				left_btn.enabled = false;
				left_btn_off.visible = true;
			}else {
				left_btn.enabled = true;
				left_btn_off.visible = false;
			}
			TweenLite.to(chanl_set,.8,{x:-(icon_width*cur_icon)+33.3});
		}
		//显示某频道EPG，cover覆盖层渐显，全显后调用switchChanl
		private function showChanl(_id:int) {
			hideInfo();
			hint_timer.reset();
			if (_id < 0) {
				_id = 0;
			}
			for (var i:int = 0; i < CID_NUMBER; i++) {//当前频道icon定位
				var _tmp_mc:Sprite = new Sprite();
				_tmp_mc = btn_array[i] as Sprite;
				if (i == cur_id) {
					_tmp_mc.parent.bg.x = _tmp_mc.x;
					break;
				}
			}
			pre_chanl = cur_chanl;
			cur_chanl = cont_spt.getChildByName("chanl" + _id) as Sprite;	
			cur_chanl.visible = false;
			TweenLite.killTweensOf(cont_cover);
			TweenLite.to(cont_cover, chanl_dur / 2, { alpha:1,onComplete:switchChanl} );
			chanl_show = _id;
			cur_cid = vidConst.CID_ARR[_id];
			cur_num_pro = num_pro_arr[_id];		
			updateScroll();		
		}
		//切换频道，显示新的频道，cover覆盖层渐隐
		private function switchChanl() {
			var _num:int = cont_spt.numChildren;
			for (var i:int = 0; i < _num; i++) {
				cont_spt.getChildAt(i).visible = false;
			}
			cont_spt.addChild(cur_chanl);
			cont_spt.addChild(info_txt);
			cur_chanl.visible = true;
			info_txt.visible = true;
			TweenLite.killTweensOf(cont_cover);			
			TweenLite.to(cont_cover, chanl_dur, { alpha:0 } );					
		}
		//更新滚动
		private function updateScroll() {
			//trace(num_playing_arr);
			if (cur_chanl.y < -(cur_num_pro - NUM_PRO_SHOW) * PRO_HEIGHT) {//太上面了，往下移
				chanlMove( -(cur_num_pro - NUM_PRO_SHOW) * PRO_HEIGHT, false);
				scroll_spt.dragger_sprite.y = SCROLL_HEIGHT - SCROLL_DRAGGER_HEIGHT + SCROLL_TOP;
				if (cur_num_pro <= NUM_PRO_SHOW) {	//当前节目总数少于显示节目数，移到顶，隐藏dragger
					chanlMove(0);
					scroll_spt.dragger_sprite.dragger.enabled = false;
					fadeDragger(false);
				}
				return;
			}
			if (cur_num_pro <= NUM_PRO_SHOW) {	//当前节目总数少于显示节目数，移到顶，隐藏dragger
				chanlMove(0);
				scroll_spt.dragger_sprite.dragger.enabled = false;
				fadeDragger(false);
			}else{	//滚动dragger
				//trace("@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
				scroll_spt.dragger_sprite.dragger.enabled = true;
				fadeDragger(true);
				var _offset:Number = SCROLL_TOP + (SCROLL_HEIGHT - SCROLL_DRAGGER_HEIGHT) * (CHANL_TOP - cur_chanl.y) / PRO_HEIGHT / (cur_num_pro - NUM_PRO_SHOW);
				//trace("_offset: "+_offset);
				TweenLite.to(scroll_spt.dragger_sprite, 2, { y:_offset} );
			}
		}
		//显示或隐藏dragger
		private function fadeDragger(_isFadeIn:Boolean) {
			if(!_isFadeIn){//
				TweenLite.to(scroll_spt.dragger_sprite.dragger, 1, {alpha:0} );
			}else {
				scroll_spt.dragger_sprite.dragger.alpha = 1;		
			}
		}
		//频道按钮事件
		private function btnOver(e:MouseEvent) {
			btn_index = e.currentTarget.id;
			if (btn_index == -1) {
				btn_index = 0;
				return;
			}
			unhint_timer.reset();
			hint_timer.reset();
			hint_timer.start();
			if (btn_array[chanl_show] == e.currentTarget) {
				return;
			}
			e.currentTarget.over.visible = true;
			//e.currentTarget.hl.alpha = btn_alpha2;
		}
		private function btnOut(e:MouseEvent) {
			if (btn_array[chanl_show] == e.currentTarget) {
				return;
			}
			e.currentTarget.over.visible = false;
			unhint_timer.reset();
			hint_timer.reset();
			unhintTimer(new TimerEvent(TimerEvent.TIMER));
			//e.currentTarget.hl.alpha = btn_alpha1;
		}
		private function btnClick(e:MouseEvent) {
			cur_id = e.currentTarget.id;
			//trace("cur_id: "+cur_id);
			unhint_timer.reset();
			hint_timer.reset();
			e.currentTarget.over.visible = false;
			unhintTimer(new TimerEvent(TimerEvent.TIMER));
			//trace(vidConst.CID_ARR[_index]);
			loadDate("", vidConst.CID_ARR[id_arr[cur_id]]);
			change_cname=vidConst.CN_ARR[id_arr[cur_id]];
		}
		
		//向上滚一轮
		private function scrollUpDown(e:MouseEvent) {
			var _offset:Number = Math.max(-(cur_num_pro-NUM_PRO_SHOW)*PRO_HEIGHT,cur_chanl.y-(NUM_PRO_SHOW-1)*PRO_HEIGHT);
			chanlMove(_offset, true);
		}
		//向下滚一轮
		private function scrollDownDown(e:MouseEvent) {
			var _offset:Number = Math.min(0, cur_chanl.y + (NUM_PRO_SHOW) * PRO_HEIGHT);
			chanlMove(_offset, true);
		}
		//点击滚动条事件
		private function scrollSlideDown(e:MouseEvent) {
			if (cur_num_pro <= NUM_PRO_SHOW) {
				return;
			}
			if (scroll_spt.dragger_sprite.y<scroll_spt.dragger_slide.mouseY+scroll_spt.dragger_slide.y) {//上部
				scrollUpDown(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}else {				
				scrollDownDown(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}
		}
		//dragger事件
		private function draggerDown(e:MouseEvent) {
			//e.target.down.visible = true;
			e.target.stage.addEventListener(MouseEvent.MOUSE_UP, draggerUp);
			e.target.stage.addEventListener(MouseEvent.MOUSE_MOVE, draggerMove);
			var _rec:Rectangle = new Rectangle(SCROLL_X, SCROLL_TOP, 0,SCROLL_HEIGHT-SCROLL_DRAGGER_HEIGHT);
			scroll_spt.dragger_sprite.startDrag(false, _rec);
		}
		private function draggerUp(e:MouseEvent) {
			//dragger.down.visible = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, draggerMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, draggerUp);
			scroll_spt.dragger_sprite.stopDrag();
		}
		private function draggerMove(e:MouseEvent) {
			chanlMove(CHANL_TOP - PRO_HEIGHT*(cur_num_pro-NUM_PRO_SHOW)* (scroll_spt.dragger_sprite.y - SCROLL_TOP) / (SCROLL_HEIGHT - SCROLL_DRAGGER_HEIGHT));
		}
		//上下移动当前频道
		private function chanlMove(_offset:Number, _is_dragger_following:Boolean = false) {	
			TweenLite.killTweensOf(cur_chanl);
			if (_is_dragger_following) {
				TweenLite.to(cur_chanl, 2, { y:_offset,onUpdate:setScroll} );
			}else {
				TweenLite.to(cur_chanl, 0.1, { y:_offset} );
			}
		}
		
		//克隆一个日期
		private function cloneDate(_dt:Date):Date {
			var _date:Date = new Date(_dt.toString());
			return _date;
		}
		//epg加载完毕
		private function ldComplete(e:Event) {
			epg_timer.reset();
			update_timer.reset();
			update_timer.start();
			epg_ld.removeEventListener(Event.COMPLETE, ldComplete);
			epg_ld.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, ldError);
			epg_ld.removeEventListener(IOErrorEvent.IO_ERROR, ldError);
			var my_str:String = e.target.data.toString();
			var _xml:XML=new XML(my_str);
			var prog_node:XMLList =_xml.channel;
			
			var cid_des:String = prog_node[0].attribute("name");
			//trace(cid_des);
			var my_cid:String = prog_node[0].attribute("id");
			//trace(my_cid);
			var _date_des:String=prog_node[0].attribute("date");
			//trace(_date_des);
			//var cid_des:String = my_str.substring(cid_index + 6, cid_index + 10);//e.g. 财经频道
			
			//var my_cid:int=vidConst.CID_ARR[chanl_show];
			
			//var _date_des:String=my_str.substring(date_index+6,date_index+16);//e.g. 2008-12-07
			//var my_index1:int=my_str.lastIndexOf("<root>");
			//var my_index2:int=my_str.lastIndexOf("</root>");
			/*if ((my_index2!=-1)&&(my_index1!=-1)&&(my_index1<my_index2)) {
				my_str=my_str.substring(my_index1,my_index2+7);
			} else {//data format Error!
				trace("failed to load");
				return;
			}*/
			
			
			var _len1:int = prog_node.children().length();
			var _len2:int = prog_node.children()[0].children().length();
			
			//解析EPG
			tmp_obj = new Object();
			tmp_obj.detail_arr = new Array();
			tmp_obj.major_arr = new Array();
			for (var i=0; i<_len1; i++) {
				var _arr:XML= prog_node.children()[i];
				var _obj1:Object = {};
				
				_obj1.date=_date_des;
				_obj1.cid = my_cid;
				_obj1.title=_arr.child("title");
				_obj1.type = _arr.child("type");
				_obj1.starttime = _arr.child("starttime");
				_obj1.endtime = _arr.child("endtime");
				_obj1.timestamp = _arr.child("timestamp");
				_obj1.duration = int(_arr.child("length").toString());

				tmp_obj.detail_arr.push(_obj1);
				var start_arr:Array = _obj1.starttime.split(":");
				var end_arr:Array = _obj1.endtime.split(":");
				_obj1.dura = 60*(parseInt(end_arr[0])-parseInt(start_arr[0]))+parseInt(end_arr[1])-parseInt(start_arr[1]);//duration in minutes
				if (_obj1.dura<0) {
					_obj1.dura+=24*60;
				}
				if (_obj1.type != "广") {
					_obj1.id = tmp_obj.major_arr.length;
					tmp_obj.major_arr.push(_obj1);
				}
				
			}
			
			drawChanl(tmp_obj.major_arr, cur_id);		
			showChanl(cur_id);	
			updateProStatus();
		}
		//画EPG
		private function drawChanl(_arr:Array, _id:int) {
			unloadChanl(_id);
			var _len = _arr.length;			
			num_pro_arr[_id] = _arr.length;			
			var _now:String=now_date.getHours()+":"+now_date.getMinutes()+":00";
			
			var i:int;
			var _cont:Program;
			for (i=0; i<_len; i++) {
				_cont=new Program(_arr[i]);
				_cont.name="cont"+i;
				_cont.y = i * PRO_HEIGHT;				
				_cont.getChildByName("cover").alpha = 0;				
				_cont.addEventListener(Program.CLICK_PROGRAM,changeChanl);				
				cont_spt.getChildByName("chanl"+_id).addChild(_cont);
				//trace(_arr[i].title);
			}
			//trace("ok");
		}
		//初始化scroll
		private function initScroll() {
			scroll_spt.dragger_sprite.dragger.addEventListener(MouseEvent.MOUSE_DOWN, draggerDown);
			scroll_spt.up.addEventListener(MouseEvent.MOUSE_DOWN, scrollUpDown);
			scroll_spt.down.addEventListener(MouseEvent.MOUSE_DOWN, scrollDownDown);
			scroll_spt.dragger_slide.addEventListener(MouseEvent.MOUSE_DOWN, scrollSlideDown);
		}
		//设置dragger的位置
		private function setScroll() {
			TweenLite.killTweensOf(scroll_spt.dragger_sprite);
			scroll_spt.dragger_sprite.y = (CHANL_TOP - cur_chanl.y) * (SCROLL_HEIGHT - SCROLL_DRAGGER_HEIGHT) / PRO_HEIGHT / (cur_num_pro - NUM_PRO_SHOW) + SCROLL_TOP;
		}
		//滚动到当前播放位置
		private function moveToPlaying() {//移到当前播放的节目
			if (date_des != parseDate(now_date)) {//如果不是当天，返回
				return;
			}
			var _offset:Number;
			//trace("num_pro_arr[chanl_show]: " + num_pro_arr[chanl_show]);
			if (num_playing_arr[chanl_show] <= NUM_PRO_SHOW / 2) {
				//chanlMove(0, true);
				return;
			}else if (num_playing_arr[chanl_show] >= num_pro_arr[chanl_show] - NUM_PRO_SHOW/2) {
				_offset = -(num_pro_arr[chanl_show]-NUM_PRO_SHOW) * PRO_HEIGHT;
				chanlMove(_offset, true);
				return;
			}
			_offset = -(num_playing_arr[chanl_show] - NUM_PRO_SHOW / 2) * PRO_HEIGHT;
			//trace("_offset: " + _offset);
			//trace("++++++++++++++moveToPlaying+++++++++++++++++");
			chanlMove(_offset, true);
		}
		//侦听到某一节目的点击事件，发送EPG.CHANGE_CHANL，更新EPG状态
		private function changeChanl(e:Event) {
			var _num:int =cur_chanl.numChildren;
			var _id:int = int(String(e.currentTarget.name).substr(4));
			num_playing_arr[chanl_show] = _id;
			change_cid = uint(e.target.progCid);
			change_stamp = Number(e.target.progStamp);
			dispatchEvent(new Event(EPG.CHANGE_CHANL));
			for (var i = 0; i < _num; i++) {
				if (i != _id) {
					cur_chanl.getChildAt(i).setOut();
				}
			}
			updateProStatus();
		}
		//卸载当前频道Sprite里的节目
		private function unloadChanl(_id) {
			if(cont_spt.getChildByName("chanl"+_id)!=null){
				var _num=cont_spt.getChildByName("chanl"+_id).numChildren;
				for (var i=0; i<_num; i++) {
					cont_spt.getChildByName("chanl" + _id).removeChildAt(0);
				}
			}
		}
		//装载失败
		private function ldError(e:Event):void {
			epg_timer.reset();
			update_timer.reset();
			showInfo("装载节目单失败.");
			trace("Failed to load epg.");
			epg_ld.removeEventListener(Event.COMPLETE, ldComplete);
			epg_ld.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, ldError);
			epg_ld.removeEventListener(IOErrorEvent.IO_ERROR, ldError);
		}
		//配置装载失败
		private function configError(e:Event) {
			config_timer.reset();
			showInfo("装载配置文件失败.");
			trace("Failed to load config");
			config_ld.removeEventListener(Event.COMPLETE, configComplete);
			config_ld.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, configError);
			config_ld.removeEventListener(IOErrorEvent.IO_ERROR, configError);
			
			initCont();
			initScroll();
			initCalendar();
			initChanlBtn();
			is_config_ready = true;
			loadDate(date_des, def_cid);
		}
		//解析日期成yyyy-mm-dd的格式
		private function parseDate(_date:Date):String {//e.g. 2008-12-26
			return _date.getFullYear() + "-" + addZero((_date.getMonth() + 1)) + "-" + addZero(_date.getDate());
		}
		//加个0
		private function addZero(_int:int):String {
			if (_int <= 9) {
				return "0" + _int;
			}
			return String(_int);
		}
		//师尊EPG状态
		private function updateProStatus() {
			var now_time:String = addZero(now_date.getHours()) + ":" + addZero(now_date.getMinutes()) + ":00";
			var _num:int = cur_chanl.numChildren;
			var _bool:Boolean = true;//现在直播
			var _bool2:Boolean = true;//现在播放
			var k:int;//直播id
			var l:int;//正在播放id
			var now_stamp:int = new Date().getTime() / 1000;
			for (var j = 0; j < _num; j++) {//
				if (cur_chanl.getChildAt(j).progStamp.valueOf() > now_stamp) {//in future time
					if (_bool) {
						if (j) {//正在直播
							cur_chanl.getChildAt(j-1).getChildByName("txt").textColor=0xFFFFFF;
							cur_chanl.getChildAt(j-1).getChildByName("time_txt").textColor = 0xFFFFFF;
							cur_chanl.getChildAt(j-1).getChildByName("air_txt").alpha = 1;
							if (!num_playing_arr[chanl_show]) {
								//cur_chanl.getChildAt(j - 1).getChildByName("playing_spt").alpha = 1;
								//cur_chanl.getChildAt(j - 1).getChildByName("hl_spt").alpha = 1;
								//cur_chanl.getChildAt(j - 1).getChildByName("time_txt").textColor = 0xFFCC00;
								//cur_chanl.getChildAt(j - 1).getChildByName("txt").textColor = 0xFFCC00;
								num_playing_arr[chanl_show] = j - 1;
								moveToPlaying();
							}							
						}
						_bool = false;
						k = j;
						for (i = k; i < _num; i++) {//即将播放
							cur_chanl.getChildAt(i).getChildByName("txt").textColor=0x666666;
							cur_chanl.getChildAt(i).getChildByName("time_txt").textColor=0x666666;
							//cur_chanl.getChildAt(i).addEventListener(MouseEvent.MOUSE_OVER, futureOver);
							//cur_chanl.getChildAt(i).addEventListener(MouseEvent.MOUSE_OUT, futureOut);
							cur_chanl.getChildAt(i).mouseChildren=false;
						}
						//break;
					}
				} else {//已经播放
					if(!cur_chanl.getChildAt(j).is_down){
						cur_chanl.getChildAt(j).getChildByName("txt").textColor=0xFFFFFF;
						cur_chanl.getChildAt(j).getChildByName("time_txt").textColor = 0xFFFFFF;
						cur_chanl.getChildAt(j).mouseChildren = true;
					}
				}
				//正在播放检测
				if (_bool2&&(cur_chanl.getChildAt(j).progStamp.valueOf() > change_stamp)&&(int(cur_chanl.getChildAt(j).progCid)==change_cid)&&j) {//j!=0
					cur_chanl.getChildAt(j - 1).getChildByName("playing_spt").alpha = 1;
					cur_chanl.getChildAt(j - 1).getChildByName("hl_spt").alpha = 1;
					cur_chanl.getChildAt(j - 1).getChildByName("time_txt").textColor = 0xFFCC00;
					cur_chanl.getChildAt(j - 1).getChildByName("txt").textColor = 0xFFCC00;	
					//trace(j);
					_bool2 = false;
					l = j;
				}else {
					cur_chanl.getChildAt(j).getChildByName("playing_spt").alpha = 0;
					cur_chanl.getChildAt(j).getChildByName("hl_spt").alpha = 0;	
					cur_chanl.getChildAt(j).getChildByName("air_txt").alpha = 0;
				}
			}
		}
		//未来节目事件
		private function futureOver(e:MouseEvent) {
			clearTimeout(future_tout);
			future_tout = setTimeout(showFutureText, hint_delay*1000);
		}
		private function futureOut(e:MouseEvent) {
			clearTimeout(future_tout);
			unshowFutureText();
		}
		//显示"即将播出"
		private function showFutureText() {
			addChild(future_txt);
			future_txt.x = mouseX-future_txt.width;
			future_txt.y = mouseY;
			clearTimeout(future_tout);
			future_tout = setTimeout(unshowFutureText, hint_delay*1000);
		}
		private function unshowFutureText() {
			if (this.contains(future_txt)) {
				removeChild(future_txt);
			}	
		}
		//显示提示信息
		private function showInfo(_str:String = "正在加载...") {//显示信息
			info_txt.text = _str;
			info_txt.alpha = 1;
			info_txt.visible = true;
			cont_spt.addChild(info_txt);
			
			hide_info_timer.reset();
			hide_info_timer.start();
		}
		//隐藏
		private function hideInfo() {
			hide_info_timer.reset();
			if (cont_spt.contains(info_txt)) {
				//trace("hideInfo");
				TweenLite.killTweensOf(info_txt);
				TweenLite.to(info_txt, 1, { alpha:0 } );
			}
		}
		//装载某频道某天的EPG
		private function loadDate(_date:String, _cid:int):void {//_date format: e.g. 2008-12-08
			if (!_date) {
				_date = date_des;
			}
			showInfo("正在加载数据...");			
			var i:int;
			var _spt:Sprite;
			for (i= cal_total; i >= 1; i--) {//更新日历
				_spt = cal_spt.getChildByName("cal" + i) as Sprite;
				if (_spt.date_txt.text == _date.substring(8)) {
					cal_spt.getChildByName("cal0").x = _spt.x;
					if (_spt.is_weekend) {
						cal_spt.getChildByName("cal0").day_txt.textColor = weekend2_color;
					}else {
						cal_spt.getChildByName("cal0").day_txt.textColor = workday2_color;
					}
					cal_spt.getChildByName("cal0").day_txt.text = _spt.day_txt.text;
					cal_spt.getChildByName("cal0").date_txt.text = _spt.date_txt.text;
					cal_spt.getChildByName("cal0").month_txt.text = _spt.month_txt.text;
					break;
				}
			}
			if (!i) {//找不到
				_spt=cal_spt.getChildByName("cal" + cal_total) as Sprite;
				cal_spt.getChildByName("cal0").x = _spt.x;
				cal_spt.getChildByName("cal0").day_txt.text = _spt.day_txt.text;
				cal_spt.getChildByName("cal0").date_txt.text = _spt.date_txt.text;
				cal_spt.getChildByName("cal0").month_txt.text = _spt.month_txt.text;
			}
			date_des = _date;	
			//trace("cur_id: " + cur_id);
			chanl_show = id_arr[cur_id];
			if (chanl_show < 0) {
				chanl_show = 0;
			}
			//trace("chanl_show: " + chanl_show);
			
			cur_cid = vidConst.CID_ARR[chanl_show];// .CID_ARR[chanl_show];
			for (var j in btn_array) {
				btn_array[j].gray.visible = true;
				btn_array[j].over.visible =false;
			}
			btn_array[cur_id].gray.visible = false;
			chanl_set.bg.x = btn_array[cur_id].x;
			//trace(btn_array[cur_id].x);
			//trace("***********");
			
			//居中显示
			cur_icon = cur_id-int(shown_icon/2);
			(cur_icon < 0)?(cur_icon = 0):(cur_icon = cur_icon);
			if (cur_icon > total_icon - shown_icon) {
				cur_icon = total_icon - shown_icon;
			}
			refreshSet();

			title_mc.chanl_txt.text = vidConst.CN_ARR[chanl_show] + "  节目单";//第一财经 节目单
			var _arr:Array = _date.split("-");
			if (_arr.length > 2) {//[2009, 07, 01]
				title_mc.date_txt.text = _arr[0] + "年" + _arr[1] + "月" + _arr[2] + "日 " + cal_spt.getChildByName("cal0").day_txt.text;
			}
			var tmp_str:String = xml_dir + "/" + cur_cid + "_" + _date + ".xml";
			epg_timer.reset();
			epg_timer.start();
			epg_ld.addEventListener(Event.COMPLETE, ldComplete);
			epg_ld.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ldError);
			epg_ld.addEventListener(IOErrorEvent.IO_ERROR, ldError);
			epg_ld.load(new URLRequest(tmp_str));
		}
		//设置
		public function set playing_timestamp(value:Number):void {
			change_stamp = value;
		}		
		public function set playing_cid(value:int):void {
			change_cid = value;
		}
	}
}