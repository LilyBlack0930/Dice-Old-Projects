loadLua("aaa")

msg_order={}

function shock_awei(msg)
  if msg.fromGroup=="0" then return "" end
  local a = msg.fromQQ
  local num = ranint(1, 100)
  local succeed_rate = 60
  if (a=="3421256529") then
    if (num<=succeed_rate) then
	setUserConf(3306860448, "阿委牛子电量", getUserConf(3306860448, "阿委牛子电量",0)+ranint(1,100))
	return "{pc}把电击棒塞入自己的裆下：D100=--/-- 自动成功！\n{pc}的体质检定：D100="..quzheng(num).."/"..succeed_rate.." "..dice(num,succeed_rate).." 余裕余裕，区区轻伤不在话下！\n\n某处的电量值上升了……"
	else
	setUserConf(3306860448, "阿委牛子电量", getUserConf(3306860448, "阿委牛子电量",0)+ranint(1,100))
	return "{pc}把电击棒塞入自己的裆下：D100=--/-- 自动成功！\n{pc}的体质检定：D100="..quzheng(num).."/"..succeed_rate.." "..dice(num,succeed_rate).." 痛得当场倒下！\n\n某处的电量值上升了……"
	end
  else  -- 不是阿委自己电的
	if (getUserToday(msg.fromQQ,"电阿委次数",0) > 5)then
	  return "打咩！{nick}你今天已经电很多次了！就算不一定每次都成功电到了也请珍惜阿委的身体！"
	end
	setUserToday(msg.fromQQ, "电阿委次数", getUserToday(msg.fromQQ,"电阿委次数",0)+1)
    local res = drawDeck(msg.fromGroup,msg.fromQQ,"_电阿委牛子")
    local dice_result = tonumber(string.match(string.match(res,"([0-9]+/)(%d+)"),"%d+"))
	dickFly = ""  -- 牛子飞了
    if ( dice_result<=60 ) then
  	  setUserConf(3306860448, "阿委牛子电量", getUserConf(3306860448, "阿委牛子电量",0)+ranint(1,24))
	  if ranint(1,5)==1 then
		  setUserConf(3306860448,"野生阿委牛子",getUserConf(3306860448,"野生阿委牛子",0)+1)
		  dickFly = "\f有什么东西飞走了！"
	  end
    end
	
    return res..dickFly
  end
end
msg_order["#电阿委牛子"] = "shock_awei"
msg_order["#电阿傻牛子"] = "shock_awei"

function awei_shock(msg)
	if msg.fromGroup=="0" then return "" end
	if (msg.fromQQ == "3421256529") then
		return awei_awei_shock(msg)
	end
	shock_object = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#awei_shock_order+1)
	if (shock_object=="阿委" or shock_object=="阿傻" or shock_object=="委员长" or shock_object=="阿福" or shock_object=="[CQ:at,qq=3421256529]") then
		return "{nick}用阿委的牛子电了阿委！\n\n阿委短路了！"
	end
	power = ranint(1,24)
	current_power = getUserConf(3306860448, "阿委牛子电量",0)
	left_power = current_power - power
	if (current_power <= 0) then
		return "{nick}试图使用阿委的牛子对他人实施电击……\n但是失败了！\n阿委的牛子已经一点电都不剩了！"
	end
	if left_power <= 0 then left_power = 0 end
	setUserConf(3306860448, "阿委牛子电量", left_power)
	power = power + ranint(0,50)
	
	dickFly = ""  -- 牛子飞了
	if ranint(1,5)==1 then
		setUserConf(3306860448,"野生阿委牛子",getUserConf(3306860448,"野生阿委牛子",0)+1)
		dickFly = "\f阿委牛子飞了！"
	end
	
	if left_power == 0 then 
		return "{nick}拔下阿委的牛子对" .. shock_object .. "使用电击！\n效果拔群！\n造成了" .. quzheng(power) .. "点伤害！\n滋滋滋滋……\n阿委的牛子逐渐暗淡了下来！"..dickFly
	end
	return "{nick}拔下阿委的牛子对" .. shock_object .. "使用电击！\n效果拔群！\n造成了" .. quzheng(power) .. "点伤害！"..dickFly
end
awei_shock_order = "#用阿委牛子电"
msg_order[awei_shock_order]="awei_shock"
msg_order["#用阿傻牛子电"]="awei_shock"

function awei_awei_shock(msg)
	if msg.fromGroup=="0" then return "" end
	shock_object = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#awei_awei_shock_order+1)
	if (msg.fromQQ ~= "3421256529") then
		return ""
	end
	if (shock_object=="阿委" or shock_object=="阿傻" or shock_object=="委员长" or shock_object=="阿福" or shock_object=="[CQ:at,qq=3421256529]") then
		return "阿委，打咩！亲自执行魔术回路打咩！"
	end
	power = ranint(1,38)
	current_power = getUserConf(3306860448, "阿委牛子电量",0)
	left_power = current_power - power
	if left_power < 0 then left_power = 0 end
	if (current_power <= 0) then
		return "阿委试图用牛子电别人……\n但是失败了！\n牛子已经一点电量都不剩了！"
	end
	setUserConf(3306860448, "阿委牛子电量", left_power)
	power = power + 100 + ranint(0,50)
	if left_power == 0 then 
		return "阿委用牛子电了" .. shock_object .. "！\n效果拔群！\n造成了" .. quzheng(power) .. "点伤害！\n滋滋滋滋……\n阿委的牛子逐渐暗淡了下来！"
	end
	return "阿委用牛子电了" .. shock_object .. "！\n效果拔群！\n造成了" .. quzheng(power) .. "点伤害！"
end
awei_awei_shock_order = "#用牛子电"
msg_order[awei_awei_shock_order]="awei_awei_shock"

function awei_show(msg)
	current_power = quzheng(getUserConf(3306860448, "阿委牛子电量",0))
	return "当前电量：" .. current_power
end
msg_order["#查询阿委牛子电量"]="awei_show"

function dick_show(msg)
	if msg.fromMsg~="#查询剩余阿委牛子" then return "" end
	current_dick = quzheng(getUserConf(3306860448,"野生阿委牛子",0))
	if current_dick==0 then
		res = "现在外面一片祥和~"
	else
		res = "当前还有"..current_dick.."个牛子逍遥法外！"
	end
	return res
end
msg_order["#查询剩余阿委牛子"]="dick_show"


function dick_catch(msg)
	if msg.fromMsg~="#捕捉阿委牛子" then return "" end
	current_dick = quzheng(getUserConf(3306860448,"野生阿委牛子",0))
	if current_dick==0 then return "外面好安静呢……嗯？{nick}你抄着网想干什么？" end
	if getUserToday(msg.fromQQ,"捕捉阿委次数")>5 then return "{nick}你不嫌累吗？快歇歇吧，别一天到晚抓着捕虫网在外面跑了。\n*把{nick}拽了回来*" end
	setUserToday(msg.fromQQ,"捕捉阿委次数",getUserToday(msg.fromQQ,"捕捉阿委次数")+1)
	awei_dick_dex_roll = ranint(1,80)
	user_dex_roll = ranint(1,60)
	if user_dex_roll<=60 and user_dex_roll<awei_dick_dex_roll then
		setUserConf(msg.fromQQ,"C币",getUserConf(msg.fromQQ,"C币",0)+7)
		setUserConf(3306860448,"野生阿委牛子",getUserConf(3306860448,"野生阿委牛子",0)-1)
		resist = "对抗成功！你捕捉到了阿委的牛子，获得了7枚C币！"
	else
		if user_dex_roll==awei_dick_dex_roll then resist = "数值相等，但阿委牛子的基础值更胜一筹，对抗失败！" end
		if user_dex_roll>60 then resist = "捕捉失败！" end
		if user_dex_roll>awei_dick_dex_roll then resist = "阿委牛子的出目小于你的出目，对抗失败！" end
		resist = resist.."阿委的牛子继续逍遥法外！"
	end
	return "{nick}试图捕捉一根阿委牛子！\n阿委的牛子的敏捷检定：D100="..quzheng(awei_dick_dex_roll).."/80 "..dice(awei_dick_dex_roll,80).."\n{nick}的检定：D100="..quzheng(user_dex_roll).."/60 "..dice(user_dex_roll,60).."\n"..resist
end
msg_order["#捕捉阿委牛子"]="dick_catch"