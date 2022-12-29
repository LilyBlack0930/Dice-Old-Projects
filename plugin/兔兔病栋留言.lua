msg_order = {}

require("aaa")

ttbd_path = getDiceDir().."\\plugin\\ttbd\\ttbd_liuyan.json"

function ttbd_write(message,user_qq)
	local letter = read_file(ttbd_path)
	json = require("json")
	if #letter==0 then
		num = 1
		j = {}
		j.usagi = {}
	else
		j = json.decode(letter)
		num = #j.usagi + 1
	end
	j.usagi[num] = {}
	j.usagi[num].message = message
	j.usagi[num].name = getUserConf(user_qq,"nick","")
	j.usagi[num].qq = user_qq
	j.usagi[num].times = 0
	j.usagi[num].isPermanent = false
	letter_full = json.encode(j)
	overwrite_file(ttbd_path,letter_full)
end

function ttbd_liuyan(msg)
	
	-- if msg.fromQQ~="1142145792" then return "" end -- 暂时不让人使用的开关，正式版记得删了这行
	
	raw = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#ttbd_liuyan_order+1)
	raw = string.gsub(raw,"%[CQ:image,file=(.-).mnimg%]","[图片]")
	if #msg.fromMsg==#ttbd_liuyan_order then -- 如果没有内容则返回该文本
		return "嗯？{nick}想在留言簿上写点什么吗？"
	end
	if getUserConf(getDiceQQ(),"DoListen",0)==1 then -- 监听模式
		if msg.fromGroup=="0" then
			message = os.date("%Y-%m-%d %H:%M:%S") .. "\n用户"..getUserConf(msg.fromQQ,"nick","(获取用户名信息失败！)").."("..msg.fromQQ..")在骰娘的私聊窗口进行了留言并附带以下文本：\n"..raw
		else
			message = os.date("%Y-%m-%d %H:%M:%S") .. "\n用户"..getUserConf(msg.fromQQ,"nick","(获取用户名信息失败！)").."("..msg.fromQQ..")在群"..getGroupConf(msg.fromGroup, "name", "(获取群名参数错误！)").."("..msg.fromGroup..")进行了留言并附带以下文本：\n"..raw
		end
		sendMsg(message,0,getDiceQQ())
	end
		
	if getUserToday(msg.fromQQ,"留言次数",0)>3 then
		return "你今天已经留言太多次了！\n你的留言虽然不会被继续记录，但仍然会进行转达。"
	else
		setUserToday(msg.fromQQ,"留言次数",getUserToday(msg.fromQQ,"留言次数",0)+1)
		ttbd_write(raw,msg.fromQQ)
		return "已经记下{nick}的留言内容：\n"..raw.."\n你的消息我收到了，回头会交给院长的。什么时候院长才会收到？这种事情要你管！"
	end
	
	return ""
end
ttbd_liuyan_order="留言"
msg_order[ttbd_liuyan_order] = "ttbd_liuyan"