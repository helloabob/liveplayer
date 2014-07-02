$(function() {
    getLastVisiter(bbtv_comment_channelid, bbtv_comment_id, 3);
});

function getLastVisiter(channel, id, count) {
    $.ajax({
        type: "get",
        url: "http://www1.bbtv.cn/ws/getLastVisiter.ashx?callback=?",
        dataType: "json",
        data: "channel=" + channel + "&id=" + id + "&count=" + count,
        beforeSend: function() {

        },
        success: function(data) {
            
            var count = 0;
            var lhtml = "";
            if (data.Root.Collections[0].SMGBB_TV_FootMark != undefined) {
                $(data.Root.Collections[0].SMGBB_TV_FootMark).each(function(i) {
                    var username = this.UserName; //留言用户
                    var userheadpic = this.UserHeadPic.replace(/\\/g, ""); //留言时间
                    var vistetime = $.trim(this.FootMark_UpdateTime.substring(0, 10));
                    var arylist = vistetime.split('-');
                    lhtml += "<li><a href=\"http://user.bbtv.cn/user/" + username + "\" target=\"_blank\" class=\"pic\"><img src=\"" + userheadpic + "\" alt=\"" + username + "\" /></a><a href=\"http://user.bbtv.cn/user/" + username + "\" target=\"_blank\" title=\""+ username +"\">"+username+"</a><span>"+arylist[1]+"月"+arylist[2]+"日</span></li>";
                });
            }
            $("ul.picList").html(lhtml);
        },
        complete: function() {

        },
        error: function() {

        }
    });
};