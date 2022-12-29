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

function ttbd_read()
	local letter = read_file(ttbd_path)
	if #letter==0 then
		return "“嗯哼，本来是想随便给点其他人写的留言把你打发走……不过看起来我的库存空了呢，下次再说吧。”"
	end
	local json = require("json")
	local j = json.decode(letter)
	if #j.usagi==0 then
		return "“嗯哼，本来是想随便给点其他人写的留言把你打发走……不过看起来我的库存空了呢，下次再说吧。”"
	else
		local num = #j.usagi
		local n = tonumber(quzheng(ranint(1,num)))
		local message = j.usagi[n].message
		local qq = j.usagi[n].qq
		local name = j.usagi[n].name
		local isPermanent = j.usagi[n].isPermanent
		local letter_text = "我看看~那今天就给你这个吧——是["..name.."("..qq..")]的留言：“"..message.."”"
		j.usagi[n].times = j.usagi[n].times + 1
		if j.usagi[n].times>=1 and isPermanent==false then
			table.remove(j.usagi,n)
		end
		letter_full = json.encode(j)
		overwrite_file(ttbd_path,letter_full)
		return letter_text
	end
end

function ttbd_gift()
	local letter = read_file(getDiceDir().."\\plugin\\ttbd\\ttbd_liwu.json")
	if #letter==0 then
		return "“嗯哼，本来是想随便给点从别人那收到的礼物把你打发走……不过看起来我的库存空了呢，下次再说吧。”"
	end
	local json = require("json")
	local j = json.decode(letter)
	if #j.usagi==0 then
		return "“嗯哼，本来是想随便给点从别人那收到的礼物把你打发走……不过看起来我的库存空了呢，下次再说吧。”"
	else
		local num = #j.usagi
		local n = tonumber(quzheng(ranint(1,num)))
		local message = j.usagi[n].message
		local qq = j.usagi[n].qq
		local name = j.usagi[n].name
		local isPermanent = j.usagi[n].isPermanent
		local letter_text = "我看看~那今天就给你这个吧——是来自["..name.."("..qq..")]的礼物："..message
		j.usagi[n].times = j.usagi[n].times + 1
		if j.usagi[n].times>=1 and isPermanent==false then
			table.remove(j.usagi,n)
		end
		letter_full = json.encode(j)
		overwrite_file(getDiceDir().."\\plugin\\ttbd\\ttbd_liwu.json",letter_full)
		return letter_text
	end
end

function ttbd(msg)
	
	-- if msg.fromQQ~="1142145792" then return "" end -- 暂时不让人使用的开关，正式版记得删了这行
	
	ret = "[CQ:image,url=http://q1.qlogo.cn/g?b=qq&nk=" .. msg.fromQQ .. "&s=160]" -- 首先获取头像
	slash = "\n————\n" -- 分隔符
	ret = ret .. slash -- 头像+分割
	cqat = "[CQ:at,qq=" .. msg.fromQQ .. "]"
	user = getUserConf(msg.fromQQ,"nick","")
	if getUserConf(getDiceQQ(),"NoImage",0)==1 then ret="" end -- 无图模式接口，直接删除头像句段
	
	if getUserToday(msg.fromQQ,"兔兔病栋签到",0)==1 then -- 如果该用户已经签到过了则返回内容
		setUserToday(msg.fromQQ,"兔兔病栋签到",2) -- 设置签到次数为两次
		ret = ret .. cqat.. "你今天已经签到过了！"
		return ret
	end
	
	if getUserToday(msg.fromQQ,"兔兔病栋签到",0)==2 then -- 如果该用户签到第三次则进行惩罚
		setUserToday(msg.fromQQ,"兔兔病栋签到",3) -- 设置签到次数为三次
		local lossC = ranint(6,18)
		ret = ret .. cqat .. "你今天已经签到过了！\n并且你今天已经不是第二次使用这个指令了，看样子得想办法让你长点记性……\n*风见花理的手放上腰间的短剑，两粒骰子相互碰撞发出响声*\n"
		if getUserConf(msg.fromQQ,"C币",0)==0 then
			ret = ret .. "*一阵风吹过，你可怜的小钱包裂开了好几个口子*"
		elseif getUserConf(msg.fromQQ,"C币",0)<=lossC then
			lossC = tonumber(quzheng(getUserConf(msg.fromQQ,"C币",0))) -- 只碎整数部分
			setUserConf(msg.fromQQ,"C币",getUserConf(msg.fromQQ,"C币",0)-lossC) -- 正常扣款
			ret = ret .. "*六道剑光同时斩来，你钱包里仅有的" .. lossC .. "枚C币悉数碎裂*"
		else
			setUserConf(msg.fromQQ,"C币",getUserConf(msg.fromQQ,"C币",0)-lossC) -- 正常扣款
			ret = ret .. "*六道剑光同时斩来，你钱包里的" .. quzheng(lossC) .. "枚C币应声碎裂*"
		end
		return ret
	end
	
	if getUserToday(msg.fromQQ,"兔兔病栋签到",0)==3 then -- 签到三次以上不会响应
		return ""
	end
	
	setUserToday(msg.fromQQ,"兔兔病栋签到",1) -- 设置用户已签到
	setUserToday(getDiceQQ(),"签到数量",getUserToday(getDiceQQ(),"签到数量",0)+1) -- 设置增加一个签到用户
	local getC = quzheng(ranint(10,17)) -- 随机一个增量
	local ownC = getUserConf(msg.fromQQ,"C币",0) -- 获取现有C币
	ret = ret .. "[" .. user .. "] " .. cqat ..  " 于 " .. os.date("%Y-%m-%d %H:%M:%S") .. " 签到成功！\n恭喜你成为今天第" .. quzheng(getUserToday(getDiceQQ(),"签到数量")) .. "个签到的用户！\n签到奖励：" .. getC .. "C\n" -- +用户名+@+于某时签到成功+签到排名+签到奖励
	
	if getUserToday(getDiceQQ(),"签到数量")==1 then -- 如果是第一个签到的
		local extraC = quzheng(ranint(14,17)) -- 随机一个额外增量
		setUserConf(msg.fromQQ,"C币",ownC+getC+extraC) -- 设置增加后的C币量，含额外量
		ret = ret .. "你是今天第一个签到的用户，花理额外塞给你" .. extraC .. "C\n"
	else
		setUserConf(msg.fromQQ,"C币",ownC+getC) -- 设置增加后的C币量，不含额外量
	end
	
	ret = ret .. "你当前拥有：" .. getUserConf(msg.fromQQ,"C币",0) .. "C" .. slash -- +拥有C币+分割
	ret = ret .. ttbd_random() .. slash -- +随机事件+分割
	
	raw = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#ttbd_order+1) -- 获取签到后的内容
	raw = string.gsub(raw,"%[CQ:image,file=(.-).mnimg%]","[图片]")
	if #msg.fromMsg==#ttbd_order then -- 如果没有内容则返回该文本
		ret = ret .. "“你除了签到之外就没什么想说的吗？也好，免去了我记录的麻烦。”"
	else
		ttbd_write(raw,msg.fromQQ)
		if getUserConf(getDiceQQ(),"DoListen",0)==1 then -- 监听模式
			if msg.fromGroup=="0" then
				message = os.date("%Y-%m-%d %H:%M:%S") .. "\n用户"..getUserConf(msg.fromQQ,"nick","(获取用户名信息失败！)").."("..msg.fromQQ..")在骰娘的私聊窗口进行了兔兔病栋的签到并附带以下文本：\n"..raw
			else
				message = os.date("%Y-%m-%d %H:%M:%S") .. "\n用户"..getUserConf(msg.fromQQ,"nick","(获取用户名信息失败！)").."("..msg.fromQQ..")在群"..getGroupConf(msg.fromGroup, "name", "(获取群名参数错误！)").."("..msg.fromGroup..")进行了兔兔病栋的签到并附带以下文本：\n"..raw
			end
			sendMsg(message,0,getDiceQQ())
		end
		ret = ret .. "“" .. raw .. "”吗，我记下了。"
	end
	
	return ret
	
end
ttbd_order = "签到"
msg_order[ttbd_order]="ttbd"

function ttbd_item()
	local random_deck = {}
	local KPC = {"饮品","主食","套餐","小菜"}
	local KPC_draw = KPC[math.random(#KPC)]
	random_deck[1] = "[KPC欢乐餐厅]的" .. KPC_draw .. "【" .. drawDeck(getDiceQQ(),0,"_kpc"..KPC_draw) .. "】"
	random_deck[2] = "一个刁民，他有一句话想说：" .. drawDeck(getDiceQQ(),0,"刁民")
	random_deck[3] = "写着“今日玄学”的纸条，上书：" .. drawDeck(getDiceQQ(),0,"_抽卡玄学")
	local bf = {"兔兔","醉梦","橘子","术士","老泽","七天","乌鸦","委员长","小恶魔","C子","可达鸭","咸鱼"}
	local bf_draw = bf[math.random(#bf)]
	random_deck[4] = "来自" .. bf_draw .. "的病房的物品：" ..drawDeck(getDiceQQ(),0,"_病房"..bf_draw)
	random_deck[5] = "一条" .. drawDeck(getDiceQQ(),0,"_兔兔鱼塘状态") .. "的鱼，它" .. drawDeck(getDiceQQ(),0,"_兔兔鱼塘心情")
	random_deck[6] = "在[兔兔菜园]找到的" .. drawDeck(getDiceQQ(),0,"_兔兔菜园菜")
	random_deck[7] = "从[醉梦的快餐店]买来的" .. drawDeck(getDiceQQ(),0,"_醉梦快餐店")
	random_deck[8] = "从[兔兔的甜品店]买来的" .. drawDeck(getDiceQQ(),0,"_兔兔甜品")
	local number = ranint(1,#random_deck)
	return "我看看~那今天就给你这个吧——是" .. random_deck[number]
end

function ttbd_randomorder()
	random_order = {"兽语","狗屁不通文章生成器","扔漂流瓶","#电阿委牛子","咕咕语录","我要摸鱼！",".music","#摸醉梦","夸我","一言","毒鸡汤","朋友圈"}
	local number = ranint(1,#random_order)
	return "我看看~那么今天的是一条指令提示，指令名为：“" .. random_order[number] .. "”"
end

function ttbd_hint()
	random_hint = {
		"这是一条特地给给一位笨蛋用户看的提示：\n“你可以使用[.r1dX]来掷1个X面骰，但在需要反复掷X面骰时，通过[.setX]指令来设置默认骰更为省力。\n然而，在需要经常变换掷骰面数的情况下，[.setX]无疑是十分多余的举动，反复使用指令还容易触发骰娘的刷屏警告。”",
		"“漂流瓶的每日上限是扔20个、捡20个，以及跳海1次。如果你有需要，可以联系骰娘的管理员进行次数重置。”",
		"“兽语虽然好用，但千万不要看见一条兽语就直接把它复制并发送出来以翻译成人话。万一是陷阱呢~”\n~呜嗷啊呜啊呜~啊嗷呜~嗷~啊嗷啊啊嗷嗷嗷啊~呜呜~嗷嗷~嗷呜~啊呜呜呜呜啊啊呜嗷~嗷啊嗷嗷~呜啊嗷啊~~呜嗷~嗷呜~嗷嗷啊~~啊~~啊",
		"“签到是可以反复发送的，只不过有效签到只有一次而已。”",
		"“想让一些属于你的物品出现在这一版块中吗？试试发送[给风见花理送xxx]吧——我可喜欢收礼了~”",
		"“想在这一版块中留下留言吗？除了发送每日一次的[签到xxx]之外，还可以试试[留言xxx]哦~不过这些留言同时也会被院长看见就是了。”"
	}
	local number = ranint(1,#random_hint)
	return random_hint[number]
end

function ttbd_event()
	eventnum = ranint(1,2)
	if eventnum==1 then
		setUserConf(3306860448, "阿委牛子电量", getUserConf(3306860448, "阿委牛子电量",0)+ranint(10,24))
		local event_num = ranint(1, 100)
		local succeed_rate = 60
		if event_num<=succeed_rate then
			return "事件：天空中突然一道惊雷劈下！\n某人的体质检定："..quzheng(event_num).."/"..succeed_rate.." "..dice(event_num,succeed_rate).."！\n电光消散后你看见一个人呆在原处，裆部还微微发着光……"
		else
			return "事件：天空中突然一道惊雷劈下！\n某人的体质检定："..quzheng(event_num).."/"..succeed_rate.." "..dice(event_num,succeed_rate).."！\n电光消散后你看见一个人倒在地上，不时抽搐，裆部还微微发着光……"
		end
	elseif eventnum==2 then
		local event_num = ranint(1, 2)+ranint(1, 2)+ranint(1, 2)+ranint(1, 2)+ranint(1, 2)
		return "事件：你的面前突然出现了一只醉梦猫猫鱼！\n柔软的皮毛仿佛对你有着无尽的吸引力，你不由自主地把手伸了过去……\n等你回过神来，已经过去了"..event_num.."个小时……"
	elseif eventnum==3 then
		return "事件：你的余光瞥见一个火球……\n它变大了！不对，它朝你飞过来了！你下意识捂紧了自己的小钱包——\n万幸，火球在快贴上你的鼻尖时“噗”的一声消失了。"
	end
end

function ttbd_random()
	switch = {}
	switch[1] = ttbd_read() -- case 1：随机一个池子留言
	switch[2] = ttbd_item() -- case 2：随机一个兔兔病栋牌堆
	switch[3] = ttbd_randomorder() -- case 3：随机的指令提示
	switch[4] = ttbd_gift() -- case 4：随机一个礼物
	switch[5] = ttbd_hint() -- case 5：一些脚本提示
	switch[6] = ttbd_event() -- case 6：随机事件
	case_num = ranint(1,#switch)
	return switch[tonumber(quzheng(case_num))]
end

function ttbd_show(msg)
	if msg.fromQQ~="1142145792" then return "嗯我看看这是你的签到……\n你又不是院长，想偷跑？没门！" end
	local ownC = getUserConf(msg.fromQQ,"C币",0)
	return "[CQ:at,qq=" .. msg.fromQQ .. "]你现在拥有：" .. ownC .. "C"
end
msg_order["查询C币"]="ttbd_show"

--[[
[CQ:image,url=http://q1.qlogo.cn/g?b=qq&nk="..msg.fromQQ.."&s=160]
————
[CQ:at,qq=msg.fromQQ]
[兔兔零号机@兔兔] 2022-01-01 00:00:00 签到成功！
恭喜你成为今天第getUserToday(getDiceQQ,"签到数量",1)
签到奖励：getC
当前拥有：.1ownC
————
【这里放一个随机调用短牌堆的选项】
————
收到了来自xx的xx
————
“你除了签到之外就没什么想说的吗？”
]]
-- local a = drawDeck(msg.fromQQ,0,"组成")

--[[
【头像】
@xx你今天已经签到过了！
]]

--[[
【头像】
@xx你今天已经签到过了！
并且你今天已经不是第二次使用这个指令了，看起来不得不让你长点记性……
*风见花理的手放上腰间的短剑，两粒骰子相互碰撞发出响声*
*六道剑光同时斩来，你的钱包里(6-18)枚C币应声碎裂* --不会超过上限，超过上限将只砍掉可砍的部分，没有钱了衣服会被砍碎
]]

--[[
第四次及以上签到不返回文本
]]




--[[这是旧兔兔病栋签到代码，运行正常，为防止底层代码重整时出现错误而保留
function ttbd(msg)

	if getUserToday(msg.fromQQ,"兔兔病栋签到",0)==1 then -- 如果该用户已经签到过了则返回内容
		setUserToday(msg.fromQQ,"兔兔病栋签到",2) -- 设置签到次数为两次
		return "[CQ:image,url=http://q1.qlogo.cn/g?b=qq&nk=" .. msg.fromQQ .. "&s=160]\n————\n[CQ:at,qq=" .. msg.fromQQ .. "]你今天已经签到过了！"
	end
	
	if getUserToday(msg.fromQQ,"兔兔病栋签到",0)==2 then -- 如果该用户签到第三次则进行惩罚
		setUserToday(msg.fromQQ,"兔兔病栋签到",3)
		local lossC = ranint(6,18)
		local coin_loss_alot = "[CQ:image,url=http://q1.qlogo.cn/g?b=qq&nk=" .. msg.fromQQ .. "&s=160]\n————\n[CQ:at,qq=" .. msg.fromQQ .. "]你今天已经签到过了！\n并且你今天已经不是第二次使用这个指令了，看样子得想办法让你长点记性……\n*风见花理的手放上腰间的短剑，两粒骰子相互碰撞发出响声*\n*六道剑光同时斩来，你钱包里的" .. quzheng(lossC) .. "枚C币应声碎裂*"
		local coin_loss_all = "[CQ:image,url=http://q1.qlogo.cn/g?b=qq&nk=" .. msg.fromQQ .. "&s=160]\n————\n[CQ:at,qq=" .. msg.fromQQ .. "]你今天已经签到过了！\n并且你今天已经不是第二次使用这个指令了，看样子得想办法让你长点记性……\n*风见花理的手放上腰间的短剑，两粒骰子相互碰撞发出响声*\n*六道剑光同时斩来，你钱包里仅有的" .. quzheng(getUserConf(msg.fromQQ,"C币",0)) .. "枚C币悉数碎裂*"
		local coin_loss_none = "[CQ:image,url=http://q1.qlogo.cn/g?b=qq&nk=" .. msg.fromQQ .. "&s=160]\n————\n[CQ:at,qq=" .. msg.fromQQ .. "]你今天已经签到过了！\n并且你今天已经不是第二次使用这个指令了，看样子得想办法让你长点记性……\n*风见花理的手放上腰间的短剑，两粒骰子相互碰撞发出响声*\n*一阵风吹过，你可怜的小钱包裂开了好几个口子*"
		if getUserConf(msg.fromQQ,"C币",0)==0 then
			res = coin_loss_none
		elseif getUserConf(msg.fromQQ,"C币",0)<=lossC then
			lossC = getUserConf(msg.fromQQ,"C币",0)
			setUserConf(msg.fromQQ,"C币",0)
			res = coin_loss_all
		else
			setUserConf(msg.fromQQ,"C币",getUserConf(msg.fromQQ,"C币",0)-lossC)
			res = coin_loss_alot
		end
		return res
	end
	
	if getUserToday(msg.fromQQ,"兔兔病栋签到",0)==3 then -- 签到三次以上不会有任何事情发生
		return ""
	end
	
	
	setUserToday(msg.fromQQ,"兔兔病栋签到",1) -- 设置用户已签到
	setUserToday(getDiceQQ(),"签到数量",getUserToday(getDiceQQ(),"签到数量",0)+1) -- 设置增加一个签到用户
	local getC = quzheng(ranint(10,17)) -- 随机一个增量
	local ownC = getUserConf(msg.fromQQ,"C币",0) -- 获取现有C币
	
	if getUserToday(getDiceQQ(),"签到数量")==1 then -- 如果是第一个签到的
		local extraC = quzheng(ranint(14,17)) -- 随机一个额外增量
		setUserConf(msg.fromQQ,"C币",ownC+getC+extraC) -- 设置增加后的C币量，含额外量
		return "[CQ:image,url=http://q1.qlogo.cn/g?b=qq&nk=" .. msg.fromQQ .. "&s=160]\n————\n[CQ:at,qq=" .. msg.fromQQ .. "][".. getUserConf(msg.fromQQ,"nick","") .. "] 于 " .. os.date("%Y-%m-%d %H:%M:%S") .. " 签到成功！\n恭喜你成为今天第" .. quzheng(getUserToday(getDiceQQ(),"签到数量")) .. "个签到的用户！\n签到奖励：" .. getC .. "C\n你是今天第一个签到的用户，花理额外塞给你" .. extraC .. "C\n你当前拥有：" .. getUserConf(msg.fromQQ,"C币",0) .. "C\n————\n后续功能制作中！\n————\n“你除了签到之外就没什么想说的吗？也好，免去了我记录的麻烦。”"
	end
	
	setUserConf(msg.fromQQ,"C币",ownC+getC) -- 设置增加后的C币量
	return "[CQ:image,url=http://q1.qlogo.cn/g?b=qq&nk=" .. msg.fromQQ .. "&s=160]\n————\n[CQ:at,qq=" .. msg.fromQQ .. "][".. getUserConf(msg.fromQQ,"nick","") .. "] 于 " .. os.date("%Y-%m-%d %H:%M:%S") .. " 签到成功！\n恭喜你成为今天第" .. quzheng(getUserToday(getDiceQQ(),"签到数量")) .. "个签到的用户！\n签到奖励：" .. getC .. "C\n你当前拥有：" .. getUserConf(msg.fromQQ,"C币",0) .. "C\n————\n后续功能制作中！————\n“你除了签到之外就没什么想说的吗？也好，免去了我记录的麻烦。”"
end
]]