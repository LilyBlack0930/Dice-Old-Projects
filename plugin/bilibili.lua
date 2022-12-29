--[[ 
{\_/}     感谢SocialSisterYi的API收集项目，终于通过一个官方API搞定一切内容
(-ω-)     项目地址：https://github.com/SocialSisterYi/bilibili-API-collect
/ >❤     Dice! 脚本 by 兔兔(1142145792)
]]

msg_order = {}

function bili_BV(msg)
	raw = string.match(msg.fromMsg,"BV[A-Za-z0-9]*")
	if #raw==2 then return "" end
	url = "https://api.bilibili.com/x/web-interface/view?bvid=" .. raw
	res,data = http.get(url)
	if not res then return "api访问失败！这是怎么回事？！" end
	if #data<2 then return "api无返回！这是怎么回事？！" end
	json = require("json")
	j = json.decode(data)
	if j.code~=0 then return "获取失败！难道视频被吞入黑洞了？！\n错误码："..j.code.."，"..j.message end
	title = j.data.title
	picture = "[CQ:image,url=" .. j.data.pic .. "]"
	describe = j.data.desc
	view = j.data.stat.view
	danmaku = j.data.stat.danmaku
	like = j.data.stat.like
	coin = j.data.stat.coin
	favorite = j.data.stat.favorite
	share = j.data.stat.share
	author = j.data.owner.name
	hrank = j.data.stat.his_rank
	pubdate = os.date("%Y-%m-%d %H:%M:%S",j.data.pubdate)
	ret = picture .. "\n" .. title .. "\n" .. view .. "播放 · 总弹幕数" .. danmaku .. "   " .. pubdate
	if hrank~=0 then
		ret = ret .. "  全站排行榜最高第" .. hrank .. "名"
	end
	ret = ret .. "\n点赞" .. like .. " 投币" .. coin .. " 收藏" .. favorite .. " 转发" .. share .. "\n作者：" .. author
	res,data = http.get("https://api.bilibili.com/x/tag/archive/tags?bvid="..raw)
	tagdata = json.decode(data)
	if tagdata.data then
		tags = {}
		for i=1, #tagdata.data do
			tags[i] = tagdata.data[i].tag_name
		end
		ret = ret .. "\n标签：【" .. table.concat(tags, "】【") .. "】"
	end
	ret = ret .. "\n描述：\n" .. describe .. "\n\n链接：https://www.bilibili.com/video/" .. raw
	return ret
end
msg_order["BV"] = "bili_BV"
msg_order["https://www.bilibili.com/video/BV"] = "bili_BV"
msg_order["http://www.bilibili.com/video/BV"] = "bili_BV"
msg_order["www.bilibili.com/video/BV"] = "bili_BV"
msg_order["bilibili.com/video/BV"] = "bili_BV"
msg_order["https://b23.tv/BV"] = "bili_BV"
msg_order["http://b23.tv/BV"] = "bili_BV"
msg_order["b23.tv/BV"] = "bili_BV"
msg_order["https://m.bilibili.com/video/BV"] = "bili_BV"
msg_order["http://m.bilibili.com/video/BV"] = "bili_BV"



function bili_av(msg)
	raw = string.match(msg.fromMsg,"av[0-9]*")
	avid = string.match(raw,"%d+")
	if #raw==2 then return "" end
	url = "https://api.bilibili.com/x/web-interface/view?aid=" .. avid
	res,data = http.get(url)
	if not res then return "api访问失败！这是怎么回事？！" end
	if #data<2 then return "api无返回！这是怎么回事？！" end
	json = require("json")
	j = json.decode(data)
	if j.code~=0 then return "获取失败！难道视频被吞入黑洞了？！\n错误码："..j.code.."，"..j.message end
	title = j.data.title
	picture = "[CQ:image,url=" .. j.data.pic .. "]"
	describe = j.data.desc
	view = j.data.stat.view
	danmaku = j.data.stat.danmaku
	like = j.data.stat.like
	coin = j.data.stat.coin
	favorite = j.data.stat.favorite
	share = j.data.stat.share
	author = j.data.owner.name
	hrank = j.data.stat.his_rank
	pubdate = os.date("%Y-%m-%d %H:%M:%S",j.data.pubdate)
	ret = picture .. "\n" .. title .. "\n" .. view .. "播放 · 总弹幕数" .. danmaku .. "   " .. pubdate
	if hrank~=0 then
		ret = ret .. "  全站排行榜最高第" .. hrank .. "名"
	end
	ret = ret .. "\n点赞" .. like .. " 投币" .. coin .. " 收藏" .. favorite .. " 转发" .. share .. "\n作者：" .. author
	res,data = http.get("https://api.bilibili.com/x/tag/archive/tags?aid="..avid)
	tagdata = json.decode(data)
	if tagdata.data then
		tags = {}
		for i=1, #tagdata.data do
			tags[i] = tagdata.data[i].tag_name
		end
		ret = ret .. "\n标签：【" .. table.concat(tags, "】【") .. "】"
	end
	ret = ret .. "\n描述：\n" .. describe .. "\n\n链接：https://www.bilibili.com/video/" .. raw
	return ret
end
msg_order["av"] = "bili_av"
msg_order["https://www.bilibili.com/video/av"] = "bili_av"
msg_order["http://www.bilibili.com/video/av"] = "bili_av"
msg_order["www.bilibili.com/video/av"] = "bili_av"
msg_order["bilibili.com/video/av"] = "bili_av"
msg_order["https://b23.tv/av"] = "bili_av"
msg_order["http://b23.tv/av"] = "bili_av"
msg_order["b23.tv/av"] = "bili_av"
msg_order["https://m.bilibili.com/video/av"] = "bili_av"
msg_order["http://m.bilibili.com/video/av"] = "bili_av"

