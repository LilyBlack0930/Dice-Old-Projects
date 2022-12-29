msg_order = {}

require("aaa")

ttbd_path = getDiceDir().."\\plugin\\ttbd\\ttbd_liwu.json"


--[[
脚本目标：
1.收礼
2.写入
3.有好感变化
4.每日有上限
5.有差分回复
]]




--[[
空白模板自取，倒扣好感请至少在-5点以下
[""] = {
        refuse = ,
        favor = ,
        reply = "",
    },
]]

gift_list = { -- 特殊礼物列表
	["肖战"] = {
        refuse = true, --拒收
        favor = -10,
        reply = "谁要这玩意儿啊！你自己留着吧！\n*风见花理一把把那玩意儿糊到了你的脸上，并掏出一只兔兔，将其脚朝下丢进火盆",
    },
	["兔兔"] = {
        refuse = false,
        favor = 3,
        reply = "……但，这个，会不会不太合适……\n开玩笑的~以后有这种毛绒玩具尽管交给我！唯独这个无论收藏多少都不嫌多呢~\n*风见花理打开了某个空间的开口，并把“兔兔”郑重其事地收入其中。\n*你瞥到其中已经存在着堆积得如真正的雪山一样高的玩偶堆，刚才加入的新成员在这之中显得十分渺小又微不足道。",
    },
	["热fufu的睡前小恶魔奶"] = {
        refuse = true, --拒收
        favor = 0,
        reply = "不，请允许我严肃拒绝这份礼物！……就算给我八百个胆我也不敢收啊！",
    },
	["阿委的牛子"] = {
        refuse = true,
        favor = 0,
        reply = "呃……请让它从哪来的回哪去吧。",
    },
	["阿傻的牛子"] = {
        refuse = true,
        favor = 0,
        reply = "呃……请让它从哪来的回哪去吧。",
    },
	["阿福的牛子"] = {
        refuse = true,
        favor = 0,
        reply = "呃……请让它从哪来的回哪去吧。",
    },
	["阿委牛子"] = {
        refuse = true,
        favor = 0,
        reply = "呃……请让它从哪来的回哪去吧。",
    },
	["阿傻牛子"] = {
        refuse = true,
        favor = 0,
        reply = "呃……请让它从哪来的回哪去吧。",
    },
	["阿福牛子"] = {
        refuse = true,
        favor = 0,
        reply = "呃……请让它从哪来的回哪去吧。",
    },
	["橘子"] = {
        refuse = false,
        favor = 1,
        reply = "这个的话，得先确认不是“那位”橘子才行呐。\n*风见花理将这颗橘子翻来覆去地看了好一会，确认它并非生命体后收下了。",
    },
	["阿委"] = {
        refuse = true,
        favor = 0,
        reply = "这里不收笨蛋，我拒绝。",
    },
	["阿傻"] = {
        refuse = true,
        favor = 0,
        reply = "这里不收笨蛋，我拒绝。",
    },
	["阿福"] = {
        refuse = true,
        favor = 0,
        reply = "这里不收笨蛋，我拒绝。",
    },
	["委员长"] = {
        refuse = true,
        favor = 0,
        reply = "这里不收笨蛋，我拒绝。",
    },
	["醉梦"] = {
        refuse = false,
        favor = 2,
        reply = "好耶，是醉梦猫猫！\n*摸摸摸*",
    },
}


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

function rcv_gift(message,msg)
	
	gift = message -- 由于部分变量写错名字了只好这样一下……
	
	if getUserConf(getDiceQQ(),"DoListen",0)==1 then --监听
		if msg.fromGroup=="0" then
			Listen = os.date("%Y-%m-%d %H:%M:%S") .. "\n用户"..getUserConf(msg.fromQQ,"nick","(获取用户名信息失败！)").."("..msg.fromQQ..")在骰娘的私聊窗口进行了礼物投喂：\n"..message
		else
			Listen = os.date("%Y-%m-%d %H:%M:%S") .. "\n用户"..getUserConf(msg.fromQQ,"nick","(获取用户名信息失败！)").."("..msg.fromQQ..")在群"..getGroupConf(msg.fromGroup, "name", "(获取群名参数错误！)").."("..msg.fromGroup..")进行了进行了礼物投喂：\n"..message
		end
		sendMsg(Listen,0,getDiceQQ())
	end
	
	local react = gift_list[gift] -- 注：是个表
	if react then -- 如果存在表gift_list.gift（没有对应内容会是nil，即false）
		if react.favor~=0 then --如果是那些不加好感的礼物则不会有反应
			local add_favor = ranint(3,5)
			setUserConf(msg.fromQQ,"好感度",getUserConf(msg.fromQQ,"好感度",0)+add_favor+react.favor)
		end
		
		if react.refuse then return react.reply end -- 如果拒收，直接返回拒收文本，不进行后续操作
		
		ret = react.reply
		if gift~="兔兔" then ttbd_write(message,msg.fromQQ) end -- 特殊：兔兔不会出现在礼物堆里（虽然会被正常的收下）
		
		
	else -- 不在列表中的礼物走正常程序
	
		local add_favor = ranint(1,3)
		setUserConf(msg.fromQQ,"好感度",getUserConf(msg.fromQQ,"好感度",0)+add_favor) -- 加好感
		ttbd_write(message,msg.fromQQ) -- 写入
		ret = "那我就心怀感激地收下了，谢谢啦~"
		
	end
	setUserToday(msg.fromQQ,"gifts",getUserToday(msg.fromQQ,"gifts",0)+1) -- 用户的当日送礼数量+1
	setUserToday(getDiceQQ(),"rcv_gifts",getUserToday(getDiceQQ(),"rcv_gifts",0)+1) -- 骰娘的每日统计收礼数量+1
	return "{nick}想要把【" .. message .. "】赠送给我吗？\n你确定要这样做吗~？\n"..ret.."\n————\n今日收礼：" .. quzheng(getUserToday(getDiceQQ(),"rcv_gifts",0)) .. "件"
end

function rcv_gift_long(msg)
	
	if getUserToday(msg.fromQQ,"gifts",0)>=3 then return "打咩，今天已经收到很多{nick}的礼物了~再收下去院长要生气了，所以你自己留着吧~" end
	local gift = string.match(msg.fromMsg,"^[%s]*(.-)[%s]*$",#rcv_gift_long_order+1)
	if #gift==0 then return "嗯？{nick}要送给我什么？" end
	local gift = string.gsub(gift,"%[CQ:image,file=(.-).mnimg%]","[图片]")
	return rcv_gift(gift,msg)
end
rcv_gift_long_order = "给风见花理送"
msg_order["给风见花理送"] = "rcv_gift_long"
msg_order["给花理小姐送"] = "rcv_gift_long"
msg_order["给风见小姐送"] = "rcv_gift_long"
msg_order["给风见花理递"] = "rcv_gift_long"
msg_order["给花理小姐递"] = "rcv_gift_long"
msg_order["给风见小姐递"] = "rcv_gift_long"

function rcv_gift_short(msg)
	
	if getUserToday(msg.fromQQ,"gifts",0)>=3 then return "打咩，今天已经收到很多{nick}的礼物了~再收下去院长要生气了，所以你自己留着吧~" end
	local gift = string.match(msg.fromMsg,"^[%s]*(.-)[%s]*$",#rcv_gift_short_order+1)
	if #gift==0 then return "嗯？{nick}要送给我什么？" end
	local gift = string.gsub(gift,"%[CQ:image,file=(.-).mnimg%]","[图片]")
	return rcv_gift(gift,msg)
end
rcv_gift_short_order = "给风见送"
msg_order["给风见送"] = "rcv_gift_short"
msg_order["给花理送"] = "rcv_gift_short"
msg_order["给风见递"] = "rcv_gift_short"
msg_order["给花理递"] = "rcv_gift_short"