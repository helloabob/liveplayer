package cn.smgbb
{
	public class vidConst
	{
		/**************************************
		 * 频道号CID_ARR和频道名称CN_ARR相对应
		 * 并且相应的CHANL_ARR元素和epg里的频道对应的按钮名称对应
		 * 增删频道直接修改EPG.as里的CN_ARR数组
		 *************************************/
		//所有的CID和对应的CN，以及对应的按钮名称CHANL
		public static const CID_ARR:Array = [212, 215, 218, 214, 220, 217, 211, 216, 219, 210,501,242,253,241,240,223,224,256,255,294,293,284,279,503,226,231,233,234,1626, 1624, 1625, 1623, 1627, 1621, 1620, 1622, 1628,1629,1630];//频道号，唯一
		public static const CN_ARR:Array = ["财经频道", "纪实频道", "艺术人文", "五星体育", "外语频道", "娱乐频道", "生活时尚", "东方卫视", "戏剧频道", "新闻综合", "电影频道", "浙江卫视", "湖南卫视", "江苏卫视", "北京卫视", "哈哈少儿", "炫动卡通", "旅游卫视",
		"广西卫视","极速汽车","游戏风云","法制天地","娱乐前线","新闻资讯","中央二套","中央七套","中央九套","中央十套","动感101","东方广播","东广新闻","故事广播","经典947","上海交通台","上海电台","戏剧曲艺","LoveRadio","第一财经","五星体育"];//频道名称
		public static const CHANL_ARR:Array = ["fi","re","art","sports","ics","ent","life","ori","drama","news","mov","zj","hn","js","bj","teen","toon","tour","gx","max","game","cons","entf","fh","cctv2","cctv7","cctv9","cctv10","a101","a792","a909","a1072","a947","atraf","ashr","aplay","alove","afi","asports"];
		//UI加载目录
//		public static const UI_DIR:String = "/bbtv_common/bbtv_flash/flash/v5/";//ui文件根目录
		//public static const UI_DIR:String = "file:///E:/Work Source/web IPTV/Flash/新版bbtv播放器/2009-6-23/";//ui文件根目录
		//public static const UI_DIR:String = "http://localhost/v3/";//ui文件根目录
		public static const UI_DIR:String = "./";//ui文件根目录

	}	
}