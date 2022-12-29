msg_order = {}

require("aaa")

function music(msg)
	raw = string.match(msg.fromMsg,"^[%s]*(.-)[%s]*$",#music_order+1)
	if #raw==0 then return "风见花理将耳机摘下，把它与随身听一同递给你——还“贴心”地连上了整个病栋的广播系统。\n（使用【.music 歌曲名】进行点歌）" end
	json = require("json")
	rest = encodeURI(raw)
	res,data = http.get("https://music.163.com/api/search/get/web?csrf_token=hlpretag=&hlposttag=&s=" .. rest .. "&type=1&offset=0&total=true&limit=1")
	j = json.decode(data)
	if j.code~=200 then return "随身听小小的屏幕被一只兔子的脸挤满了，无法找到你想要的音乐。\n错误码："..j.code.."\n（因为测试时实在是整不出错所以如果碰见错误请包括错误码和.music信息一同通过[.send 文本]方式发送给骰主，不为什么，就开开眼）" end
	if j.result.songs[1].fee==1 then return "随身听中钻出一只梳着牛排头戴着墨镜叼着烟还缠着大金链子的兔子，它态度嚣张地朝你索要过路费，看起来这首歌是不能播放了。\n（错误：该歌曲为付费歌曲，无法直接通过外链播放）" end
	songname = j.result.songs[1].name
	cnt = 1
	singername = ""
	while cnt<=#j.result.songs[1].artists do
		if cnt == 1 then
			singername = singername .. j.result.songs[1].artists[cnt].name
		else
			singername = singername .. "、" .. j.result.songs[1].artists[cnt].name
		end
		cnt = cnt + 1
	end
	songurl = "http://music.163.com/song/media/outer/url?id=" .. j.result.songs[1].id
	imgres,imgdata = http.get("http://music.163.com/api/song/detail/?id="..j.result.songs[1].id.."&ids=%5B"..j.result.songs[1].id.."%5D")
	imgj=json.decode(imgdata)
	img = imgj.songs[1].album.picUrl
	return "[CQ:xml,data=<?xml version='1.0' encoding='UTF-8' standalone='yes' ?><msg serviceID=\"2\" templateID=\"1\" action=\"web\" brief=\"&#91;♫&#93;"..songname.."\" sourceMsgId=\"0\" url=\""..songurl.."\" flag=\"0\" adverSign=\"0\" multiMsgFlag=\"0\" ><item layout=\"2\"><audio cover=\""..img.."\" src=\""..songurl.."\" /><title>"..songname.."</title><summary>"..singername.."</summary></item></msg>]"
end
music_order = ".music"
msg_order[music_order] = "music"
