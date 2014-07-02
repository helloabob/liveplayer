
//var _channelid = "0201"; //点播
//var _id = "";
var _pagesize = 5;
var _pageindex = 1;


var _host = window.location.host; //gethost(window.location.href)//;


$(document).ready(function() {


    document.getElementById("SMGBBTV_comment_vcode").src = "http://comment.bbtv.cn/vcode.ashx?type=comment&tm=" + encodeURIComponent(getClientTime());

    function getClientTime() {
        localtime = new Date();
        var cyear = localtime.getFullYear();
        var cmonth = localtime.getMonth() + 1;
        var cdate = localtime.getDate();
        var chour = localtime.getHours();
        var cminu = localtime.getMinutes();
        var cseco = localtime.getSeconds();

        ccyear = addZero(cyear);
        ccmonth = addZero(cmonth);
        ccdate = addZero(cdate);
        cchour = addZero(chour);
        ccminu = addZero(cminu);
        ccseco = addZero(cseco);

        return ccyear + "-" + ccmonth + "-" + ccdate + " " + cchour + ":" + ccminu + ":" + ccseco;
    }

    function addZero(num) {
        num = Math.floor(num);
        return ((num <= 9) ? ("0" + num) : num);
    }

    //更改注册验证码图片
    changevode = function(picid) {
        document.getElementById(picid).src = "http://comment.bbtv.cn/vcode.ashx?type=comment&tm=" + encodeURIComponent(getClientTime());
    }

    $('li.emots > img').click(function() {
        ChecknameInputOnfocus(document.getElementById("msg"));
        var val = $("#msg").val();

        $("#msg").val(val + this.alt);
        document.getElementById("msg").focus();
    });

    FixUserLogonState();

    getfeedback(bbtv_comment_id, 1);
    var _channelid = bbtv_comment_channelid;
    
    $("#msg").keyup(function() { checkCommentContent(); });
    $("#msg").focus(function() { checkCommentContent(); });
    $("#savecomment").click(function() {
        var content = $.trim($('#msg').val());
        var vcode = $.trim($('#comment_vcode').val());
        var rname = "";

        var isanonymous = 0;
        var defaultName = $("#anonymous").attr("checked");
        if (defaultName == true) {
            isanonymous = 0;
            rname = "东方宽频用户";
        }
        else
            isanonymous = 1;
        if (content.length > 600) {
            alert("内容别超过300个汉字哦");
            return false;
        }

        if (content.replace(/\s/g, "") == "") {
            alert("留言内容不能为空");
            return false;
        }
        if (vcode == "") {
            alert("请输入验证码!");
            return false;
        }

        content = content.replace(/\n/ig, '&lt;br&gt;');

        postcontent(content, _channelid, bbtv_comment_id, isanonymous, vcode);


    });


    	var traceurl = "http://www1.bbtv.cn/ws/trace.ashx?type=1001&channel=" + bbtv_comment_channelid + "&id=" + bbtv_comment_id + "&title=" + encodeURIComponent(bbtv_title) + "&content=" + encodeURIComponent(bbtv_detail) + "&url=" + encodeURIComponent(bbtv_url) + "&imgsrc=" + encodeURIComponent(bbtv_titlepic) + "&t=" + new Date().getTime();
	if(document.getElementById("trace") != undefined)    
		document.getElementById("trace").src = traceurl;
});

function getfeedback(id, p) {
        $.ajax({
            type: "get",
            url: "http://comment.bbtv.cn/selectfeedback_gb2312.ashx?callback=?",
            dataType: "json",
            data: "sort=1&startIndex=" + p + "&pageSize=" + _pagesize + "&channelID=" + bbtv_comment_channelid + "&channelObjectID=" + id,
            beforeSend: function() {

            },
            success: function(data) {
               
                var count = 0;
                var status = "0";
                try {
                    status = data.Root.state;
                } catch (e) {
                    status = "1";
                }
               
                if (status == undefined) {
                    if (data.Root.Collections[0].Count != undefined || data.Root.Collections[0].Count != null)
                        count = data.Root.Collections[0].Count;
                    if (count > 0) {
                        $("ul.pages").each(function() {
                            var pagehtml = "";
                    		var pagenum = Math.ceil(count / _pagesize);
                    		if (parseInt(p) < 1) p = 1;
                    		if (parseInt(p) >= pagenum) p = pagenum;
                    		if (parseInt(p) > 1)
                        		pagehtml += "<li class=\"btn first\" onclick=\"getfeedback(" + id + ",1);\"></li><li class=\"btn prev\" onclick=\"getfeedback(" + id + "," + (parseInt(p) - 1) + ");\"></li><li class=\"input\"><input autocomplete=\"off\" name=\"page\" onfocus=\"$(this).select();\" onkeydown=\"if(event.keyCode == 13) s14ub543.move(event, 'input');\" type=\"text\" value=\"" + parseInt(p) + "\" /></li>";
                    		else
                        		pagehtml += "<li class=\"btn first\" onclick=\"getfeedback(" + id + ",1);\"></li><li class=\"btn prev\" onclick=\"getfeedback(" + id + ", 1);\"></li><li class=\"input\"><input autocomplete=\"off\" name=\"page\" onfocus=\"$(this).select();\" onkeydown=\"if(event.keyCode == 13) s14ub543.move(event, 'input');\" type=\"text\" value=\"" + parseInt(p) + "\" /></li>";
                    		if (parseInt(p) < pagenum)
                        		pagehtml += "<li class=\"of\" onclick=\"getfeedback(" + id + "," + (parseInt(p) + 1) + ");\">...</li><li class=\"total\" onclick=\"getfeedback(" + id + "," + pagenum + ");\">" + pagenum + "</li><li class=\"btn next\" onclick=\"getfeedback(" + id + "," + (parseInt(p) + 1) + ");\"></li>";

                    		$(this).html(pagehtml);
                        });
                        $("div.allcmt h3").html("<ul class=\"pages\">"+$("ul.pages").eq(0).html()+"</ul>");
                        $("div.allcmt h3").append("共 <b>" + count + "</b>条评论");
                        var lhtml = "";
                        if (data.Root.Collections[0].smgbbGuestBookMsg != undefined) {
                            $(data.Root.Collections[0].smgbbGuestBookMsg).each(function(i) {
                                var userName = this.userName; //留言用户
                                var createTime = this.createTime; //留言时间
                                var content = this.content; //留言内容
                                var content_temp = this.content.replace(/&amp;lt;br&amp;gt;/g, "").replace(/\\u000a/g, "").replace(/\\/g, "");
                                content = content.replace(/&amp;lt;br&amp;gt;/g, "<br />").replace(/\\u000a/g, "<br />").replace(/\\/g, "");
                                content = replaceEmotionCode(content);
                                var userurl = "";
                                var userpic = "<img src='http://user.bbtv.cn/images/default_photo.gif' />";
                                if (userName != "东方宽频用户") {
                                    userpic = this.memo;
                                    if (userpic == "")
                                        userpic = "http://user.bbtv.cn/images/default_photo.gif";
                                    else
                                        userpic = userpic.replace(/\\/g, "");
                                    userpic = "<a target=_blank href='http://user.bbtv.cn/user/" + userName + "' class='pic'><img src='" + userpic + "?' alt='" + userName + "' width='56' /></a>";
                                    userurl = "<a target=_blank href='http://user.bbtv.cn/user/" + userName + "'>" + userName + "</a>";
                                }
                                else {
                                    userurl = userName;
                                }
                                var temp = "";
                                if (i % 2 == 0)
                                    temp = "<li class=\"odd\"><div class=\"cmt-icon\">" + userpic + "</div><div class=\"txt\"><h4><div class=\"post-time\">" + createTime + "</div><span>" + userName + "</span> 说： </h4><div class=\"cmt-con\"><p id=\"p"+i+"\">" + content + "</p></div><a href=\"javascript:;\" title=\"回复\" onclick=\"javascript:replay('p"+i+"')\" class=\"reply\">回复</a></div></li>";
                                else
                                    temp = "<li><div class=\"cmt-icon\">" + userpic + "</div><div class=\"txt\"><h4><div class=\"post-time\">" + createTime + "</div><span>" + userName + "</span> 说： </h4><div class=\"cmt-con\"><p id=\"p"+i+"\">" + content + "</p></div><a href=\"javascript:;\" title=\"回复\" onclick=\"javascript:replay('p"+i+"')\" class=\"reply\">回复</a></div></li>";
                                lhtml += temp;
                            });
                        }
                        $("#comment_list").html(lhtml);

                    }
                    else
                        $("#div-cmt-list").hide();
                }
                else
                    $("#div-cmt-list").hide();
            },
            complete: function() {
                $("#savecomment").disabled = false;
            },
            error: function() {
                alert("服务器繁忙请稍后再试");
                $("#savecomment").disabled = false;
            }
        });
    }

// 转换留言表情
function replaceEmotionCode(str) {
    var val = str;
    val = val.replace(/\[emo0\]/g, '<span class="emot-00"></span>');
    val = val.replace(/\[emo1\]/g, '<span class="emot-01"></span>');
    val = val.replace(/\[emo2\]/g, '<span class="emot-02"></span>');
    val = val.replace(/\[emo3\]/g, '<span class="emot-03"></span>');
    val = val.replace(/\[emo4\]/g, '<span class="emot-04"></span>');
    val = val.replace(/\[emo5\]/g, '<span class="emot-05"></span>');
    val = val.replace(/\[emo6\]/g, '<span class="emot-06"></span>');
    val = val.replace(/\[emo7\]/g, '<span class="emot-07"></span>');
    val = val.replace(/\[emo8\]/g, '<span class="emot-08"></span>');
    val = val.replace(/\[emo9\]/g, '<span class="emot-09"></span>');
    val = val.replace(/\[emo10\]/g, '<span class="emot-10"></span>');
    val = val.replace(/\[emo11\]/g, '<span class="emot-11"></span>');
    val = val.replace(/\[emo12\]/g, '<span class="emot-12"></span>');
    val = val.replace(/\[emo13\]/g, '<span class="emot-13"></span>');
    val = val.replace(/\[emo14\]/g, '<span class="emot-14"></span>');
    val = val.replace(/\[emo15\]/g, '<span class="emot-15"></span>');
    val = val.replace(/\[emo16\]/g, '<span class="emot-16"></span>');
    val = val.replace(/\[emo17\]/g, '<span class="emot-17"></span>');
    val = val.replace(/\[emo18\]/g, '<span class="emot-18"></span>');
    val = val.replace(/\[emo19\]/g, '<span class="emot-19"></span>');
    val = val.replace(/\[emo20\]/g, '<span class="emot-20"></span>');
    val = val.replace(/\[emo21\]/g, '<span class="emot-21"></span>');
    val = val.replace(/\[emo22\]/g, '<span class="emot-22"></span>');
    val = val.replace(/\[emo23\]/g, '<span class="emot-23"></span>');
    val = val.replace(/\[emo24\]/g, '<span class="emot-24"></span>');
    val = val.replace(/\[emo25\]/g, '<span class="emot-25"></span>');
    val = val.replace(/\[emo26\]/g, '<span class="emot-26"></span>');
    return val;
}

// 转换留言表情
function replaceCodeToEmotion(str) {
    var val = str;
    val = val.replace(/\<span class=emot-00\>\<\/span\>/ig, '[emo0]');
    val = val.replace(/\<span class=\"emot-00\"\>\<\/span\>/ig, '[emo0]');
    val = val.replace(/\<span class=emot-01\>\<\/span\>/ig, '[emo1]');
    val = val.replace(/\<span class=\"emot-01\"\>\<\/span\>/ig, '[emo1]');
    val = val.replace(/\<span class=emot-02\>\<\/span\>/ig, '[emo2]');
    val = val.replace(/\<span class=\"emot-02\"\>\<\/span\>/ig, '[emo2]');
    val = val.replace(/\<span class=emot-03\>\<\/span\>/ig, '[emo3]');
    val = val.replace(/\<span class=\"emot-03\"\>\<\/span\>/ig, '[emo3]');
    val = val.replace(/\<span class=emot-04\>\<\/span\>/ig, '[emo4]');
    val = val.replace(/\<span class=\"emot-04\"\>\<\/span\>/ig, '[emo4]');
    val = val.replace(/\<span class=emot-05\>\<\/span\>/ig, '[emo5]');
    val = val.replace(/\<span class=\"emot-05\"\>\<\/span\>/ig, '[emo5]');
    val = val.replace(/\<span class=emot-06\>\<\/span\>/ig, '[emo6]');
    val = val.replace(/\<span class=\"emot-06\"\>\<\/span\>/ig, '[emo6]');
    val = val.replace(/\<span class=emot-07\>\<\/span\>/ig, '[emo7]');
    val = val.replace(/\<span class=\"emot-07\"\>\<\/span\>/ig, '[emo7]');
    val = val.replace(/\<span class=emot-08\>\<\/span\>/ig, '[emo8]');
    val = val.replace(/\<span class=\"emot-08\"\>\<\/span\>/ig, '[emo8]');
    val = val.replace(/\<span class=emot-09\>\<\/span\>/ig, '[emo9]');
    val = val.replace(/\<span class=\"emot-09\"\>\<\/span\>/ig, '[emo9]');
    val = val.replace(/\<span class=emot-10\>\<\/span\>/ig, '[emo10]');
    val = val.replace(/\<span class=\"emot-10\"\>\<\/span\>/ig, '[emo10]');
    val = val.replace(/\<span class=emot-11\>\<\/span\>/ig, '[emo11]');
    val = val.replace(/\<span class=\"emot-11\"\>\<\/span\>/ig, '[emo11]');
    val = val.replace(/\<span class=emot-12\>\<\/span\>/ig, '[emo12]');
    val = val.replace(/\<span class=\"emot-12\"\>\<\/span\>/ig, '[emo12]');
    val = val.replace(/\<span class=emot-13\>\<\/span\>/ig, '[emo13]');
    val = val.replace(/\<span class=\"emot-13\"\>\<\/span\>/ig, '[emo13]');
    val = val.replace(/\<span class=emot-14\>\<\/span\>/ig, '[emo14]');
    val = val.replace(/\<span class=\"emot-14\"\>\<\/span\>/ig, '[emo14]');
    val = val.replace(/\<span class=emot-15\>\<\/span\>/ig, '[emo15]');
    val = val.replace(/\<span class=\"emot-15\"\>\<\/span\>/ig, '[emo15]');
    val = val.replace(/\<span class=emot-16\>\<\/span\>/ig, '[emo16]');
    val = val.replace(/\<span class=\"emot-16\"\>\<\/span\>/ig, '[emo16]');
    val = val.replace(/\<span class=emot-17\>\<\/span\>/ig, '[emo17]');
    val = val.replace(/\<span class=\"emot-17\"\>\<\/span\>/ig, '[emo17]');
    val = val.replace(/\<span class=emot-18\>\<\/span\>/ig, '[emo18]');
    val = val.replace(/\<span class=\"emot-18\"\>\<\/span\>/ig, '[emo18]');
    val = val.replace(/\<span class=emot-19\>\<\/span\>/ig, '[emo19]');
    val = val.replace(/\<span class=\"emot-19\"\>\<\/span\>/ig, '[emo19]');
    val = val.replace(/\<span class=emot-20\>\<\/span\>/ig, '[emo20]');
    val = val.replace(/\<span class=\"emot-20\"\>\<\/span\>/ig, '[emo20]');
    val = val.replace(/\<span class=emot-21\>\<\/span\>/ig, '[emo21]');
    val = val.replace(/\<span class=\"emot-21\"\>\<\/span\>/ig, '[emo21]');
    val = val.replace(/\<span class=emot-22\>\<\/span\>/ig, '[emo22]');
    val = val.replace(/\<span class=\"emot-22\"\>\<\/span\>/ig, '[emo22]');
    val = val.replace(/\<span class=emot-23\>\<\/span\>/ig, '[emo23]');
    val = val.replace(/\<span class=\"emot-23\"\>\<\/span\>/ig, '[emo23]');
    val = val.replace(/\<span class=emot-24\>\<\/span\>/ig, '[emo24]');
    val = val.replace(/\<span class=\"emot-24\"\>\<\/span\>/ig, '[emo24]');
    val = val.replace(/\<span class=emot-25\>\<\/span\>/ig, '[emo25]');
    val = val.replace(/\<span class=\"emot-25\"\>\<\/span\>/ig, '[emo25]');
    val = val.replace(/\<span class=emot-26\>\<\/span\>/ig, '[emo26]');
    val = val.replace(/\<span class=\"emot-26\"\>\<\/span\>/ig, '[emo26]');
    return val;
}


function replay(obj) {
    var str = $("#"+obj).html();
    ChecknameInputOnfocus(document.getElementById("msg"));
    str = replaceCodeToEmotion(str);
    $("#msg").val("【回复：" + str + "】");
    document.getElementById("msg").focus();
}

function postcontent(_content, _channel, _id, isanonymous, vcode) {
    $.ajax({
        type: "get",
        url: "http://comment.bbtv.cn/comment.ashx?callback=?",
        dataType: "json",
        data: "content=" + encodeURIComponent(_content) + "&channelid=" + _channel + "&isanonymous=" + isanonymous + "&channelobjid=" + _id + "&validatecode=" + vcode,
        beforeSend: function() {
            $("#savecomment").disabled = true;
        },
        success: function(data) {
            var status = "";

            if (data.Root.state != undefined)
                status = data.Root.state;
            if (status == "0")
                alert("评论提交失败，请重试!");
            else if (status == "1")
                alert("评论提交成功!\r\n您的评论需要通过系统审核才能显示，请耐心等待...");
            else if (status == "2")
                alert("评论提交失败，请登录再参与评论!");
            else if (status == "3")
                alert("验证码不正确，请刷新页面后重新输入!");
            else if (status == "4")
                alert("评论提交成功!\r\n您的评论需要通过审核才能显示，请耐心等待...");
            else
                alert("评论提交失败，请重试!");
            $('#msg').val('')
            $('#comment_vcode').val('');
            changevode('SMGBBTV_comment_vcode');
            getfeedback(bbtv_comment_id, 1);
        },
        complete: function() {
            $("#savecomment").disabled = false;
        },
        error: function() {
            alert("服务器繁忙请稍后再试");
            $("#savecomment").disabled = false;
        }
    });
}

function gethost(url) {
    var result = url.match("^http:\/\/([^\/:]*)");

    if (result[1]) {
        //        var domain = result[1].match("[0-9a-zA-Z-]*\.(com\.tw|com\.cn|com\.hk|net\.cn|org \.cn|gov\.cn|ac\.cn|bj\.cn|sh\.cn|tj\.cn|cq\.cn|he\.cn|sx\.cn|nm\.cn|ln \.cn|jl\.cn|hl\.cn|js\.cn|zj\.cn|ah\.cn|fj\.cn|jx\.cn|sd\.cn|ha\.cn|hb \.cn|hn\.cn|gd\.cn|gx\.cn|hi\.cn|sc\.cn|gz\.cn|yn\.cn|xz\.cn|sn\.cn|gs \.cn|qh\.cn|nx\.cn|xj\.cn|tw\.cn|hk\.cn|mo \.cn|com|net|org|biz|info|cn|mobi|name|sh|ac|io|tw|hk|ws|travel|us|tm|cc|tv|la|in| 中国|公司|网络)$");
        //        try { return domain[0] } catch (e) { };
        return result[1];
    }
    return false;

}

// 检测评论内容
function checkCommentContent() {
    var textBox = document.getElementById("msg");
    savePos(textBox);
    var remaingwords = getRemainingWords("msg", 600);
    $("#remaining_word").html("（还可输入" + remaingwords + "字）");
}

// 获取对象还能输入的字符串数
function getRemainingWords(obj, limitCount) {
    var text = $('#' + obj).val();
    var textlength = text.length;
    if (textlength >= limitCount) {
        $('#' + obj).val(text.substr(0, limitCount));
        return 0;
    }
    return parseInt(limitCount - textlength);
}

// 设置评论框中的光标位置
function savePos(textBox) {
    //如果是Firefox(1.5)的话，方法很简单
    if (typeof (textBox.selectionStart) == "number") {
        COMMENT_STATR_NUM = textBox.selectionStart;
        COMMENT_END_NUM = textBox.selectionEnd;
    }
    //下面是IE(6.0)的方法，麻烦得很，还要计算上'\n'
    else if (document.selection) {
        var range = document.selection.createRange();
        if (range.parentElement().id == textBox.id) {
            var range_all = document.body.createTextRange();
            range_all.moveToElementText(textBox);
            for (COMMENT_STATR_NUM = 0; range_all.compareEndPoints("StartToStart", range) < 0; COMMENT_STATR_NUM++)
                range_all.moveStart('character', 1);
            for (var i = 0; i <= COMMENT_STATR_NUM; i++) {
                if (textBox.value.charAt(i) == '\n')
                    COMMENT_STATR_NUM++;
            }
            var range_all = document.body.createTextRange();
            range_all.moveToElementText(textBox);
            for (COMMENT_END_NUM = 0; range_all.compareEndPoints('StartToEnd', range) < 0; COMMENT_END_NUM++)
                range_all.moveStart('character', 1);
            for (var i = 0; i <= COMMENT_END_NUM; i++) {
                if (textBox.value.charAt(i) == '\n')
                    COMMENT_END_NUM++;
            }
        }
    }
}

function ChecknameInputOnfocus(item) {

    if ($(item).val() == 'BBTV小提示：文明上网，登录评论！')
        $(item).val("");
}

function replycomment(str) {
    ChecknameInputOnfocus(document.getElementById("msg"));
    $("#msg").val("【回复：" + str + "】");
    document.getElementById("msg").focus();
}


function FixUserLogonState() {
    $.getJSON("http://www1.bbtv.cn/ws/getUserName.ashx?callback=?", {}, function(s) {
	
        if (s.Name != null) {
            $("#user_logostat").html("<li>您好，<a href=\"http://user.bbtv.cn/user/" + s.Name.value + "\" target=\"_blank\">" + s.Name.value + "</a></li>");
        }
        else {
            $("#user_logostat").html("<span class=\"blue\">[<a href=\"http://passport.bbtv.cn\" target=\"_blank\">登录</a>] [<a href=\"http://passport.bbtv.cn\" target=\"_blank\">注册</a>]</span>");
        }
    });
}
