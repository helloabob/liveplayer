// JavaScript Document
/*
author:ybyt
date:2009-4-18
function:用户状态更改
*/
window.onload=function()
{
		var DialogWin=new Dialog();
		DialogWin.BindEvent();
		document.onclick=function(event)
		{
			event=event||window.event;
			var tag=event.srcElement||event.target;
			if(tag.id!="userMsgDate"&&tag.id!="txtUserMsg")
			{
				if(DialogWin.pad.style.display=="block"||DialogWin.shadow.style.display=="block")
				{
					DialogWin.doCancle();
				}
			}
		}

}
var Dialog=function(){
	this.eleObject=null;
	this.shadow=null;
	this.pad=null;
	this.txtInput=null;
	this.btnCfm=null;
	this.btnCle=null;
	this.dateCtn=null;
	this._init();
};
Dialog.prototype=
{
	_init	:function(){
		this.eleObject=this._$("userTxt");
		this.pad=this._$("userpad");
		this.shadow=this._$("userpad_shadow");
		this.txtInput=this._$("txtUserMsg");
		this.btnCfm=this._$("btnCfmMsg");
		this.btnCle=this._$("btnCleMsg");
		this.dateCtn=this._$("userMsgDate");

		this.txtInput.value="我正在...";

	},
	_$	:function(ele){
		return document.getElementById(ele);
	},
	//打开留言对话框
	showpad	:function(){
		this.pad.style.display="block";
		this.shadow.style.display="block";
		//this.txtbord.focus();
		this.addEventHandler(this.txtInput,"focus",(function(context, fun){return function(){return fun.apply(context);};})(this, this.focusInput));
		this.addEventHandler(this.btnCfm,"click",(function(context, fun){return function(){return fun.apply(context);};})(this, this.doConfirm));
		this.addEventHandler(this.btnCle,"click",(function(context, fun){return function(){return fun.apply(context);};})(this, this.doCancle));
	},
	//给对象绑定事件
	addEventHandler	:function(oTarget, sEventType, fnHandler){
		if (oTarget.addEventListener) {
			oTarget.addEventListener(sEventType, fnHandler, false);
		} else if (oTarget.attachEvent) {
			oTarget.attachEvent("on" + sEventType, fnHandler);
		} else {
			oTarget["on" + sEventType] = fnHandler;
		}
	},
	//取消
	doCancle	:function(){
		this.pad.style.display="none";
		this.shadow.style.display="none";
	},
	//确定
	doConfirm	:function(){
		if(this.txtInput.value==""||this.txtInput.value=="我正在...")
		{
			window.alert("您还未更新状态哦！")
		}
		else
		{
		this.pad.style.display="none";
		this.shadow.style.display="none";
		this.eleObject.innerHTML=this.txtInput.value;
		var mydate=new Date();
		var editDate = "";
		var editDate = (mydate.getMonth()+1) + "月" + mydate.getDate() + "日";
		this.dateCtn.innerHTML=editDate +"更新";
		}
	},
	//输入框聚焦
	focusInput	:function(){
		this.txtInput.value="";
	},
	BindEvent	:function()
	{		
		this.addEventHandler(this.dateCtn,"click",(function(context, fun){return function(){return fun.apply(context);};})(this, this.showpad));
	}
};





