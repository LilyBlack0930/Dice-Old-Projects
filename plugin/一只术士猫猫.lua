loadLua("aaa")

reply_fireball_list = {
	"#术士猫猫听到了你的召唤！一个火球凭空袭来…但是好像砸歪了？", --1
	"#术士猫猫听——火球砸在你的脸上，诶嘿？",	--2
	"#呜哇！一连串火球给你描了个边，别的不说这描边还挺准的…？",	--3
	"#火球非常突兀地袭来！！你还没来得及反应然后就…\n#咦，不知道谁给你加了一个护盾术，火球被挡了下来。",	--4
	"#好像没有什么事情发生，随后你抬头看到了天上四个迅速扩大的小黑点…\n#卧槽，术士猫猫砸的不是火球术是流星爆——",	--5
	"#你召唤了大火球！但是出现在你面前的是术士猫猫本体……\n#随后你被糊了一脸的火球术。", --6
	"#出现的不是火球而是一只猫…但它自称可达鸭？它说，这个火球，它吞了，快说，谢谢鸭鸭。"	--7
}

reply_fireball_empty = "#你等了半天没有看到火球…\n术士猫猫今天的法术位已经丢空了，不能给你砸火球了。"

msg_order = {}

function fireball(msg)
	if (getUserToday(getDiceQQ(),"术士猫猫今日火球",0)>=10) then
		return reply_fireball_empty
	end
	num = tonumber(quzheng(ranint(1,#reply_fireball_list)))
	res = reply_fireball_list[num]
	setUserToday(getDiceQQ(),"术士猫猫今日火球",getUserToday(getDiceQQ(),"术士猫猫今日火球",0)+1)
	if (num==2 or num==5 or num==6) then
		coin_loss = ranint(1,5)
		current_coin = getUserConf(msg.fromQQ,"C币",0)
		if current_coin == 0 then
			setUserConf(msg.fromQQ,"C币",0)
			res = res .. "\n#接着你闻到一股焦糊味，低头一看，发现自己的钱包被烫黑了一块！"
		elseif current_coin<=coin_loss then
			setUserConf(msg.fromQQ,"C币",0)
			local coin_loss = current_coin
			res = res .. "\n#回过神来时，你钱包里仅有的" .. quzheng(coin_loss) .. "枚C币蒸发了！"
		else
			setUserConf(msg.fromQQ,"C币",current_coin-coin_loss)
			res = res .. "\n#回过神来时，你钱包里有" .. quzheng(coin_loss) .. "枚C币蒸发了！"
		end
	end
	return res
end
msg_order["#召唤大火球！"]="fireball"
msg_order["#召唤大火球!"]="fireball"


function getC(msg)
	if msg.fromQQ~="1142145792" then
		return ""
	end
	setUserConf(1142145792,"C币",1)
	return "done:获取C币"
end
msg_order["获取C币"]="getC"

function clearC(msg)
	if msg.fromQQ~="1142145792" then
		return ""
	end
	setUserConf(1142145792,"C币",0)
	setUserToday(getDiceQQ(),"术士猫猫今日火球",0)
	return "done:清空C币"
end
msg_order["清空C币"]="clearC"

--[[
#召唤大火球！
#术士猫猫听到了你的召唤！一个火球凭空袭来…但是好像砸歪了？
#术士猫猫听——火球砸在你的脸上，诶嘿？
#呜哇！一连串火球给你瞄了个边，别的不说这描边还挺准的…？
#你等了半天没有看到火球…术士猫猫今天的法术位已经丢空了，不能给你砸火球了。
#火球非常突兀地袭来！！你还没来得及反应然后就…咦，不知道谁给你加了一个护盾术，火球被挡了下来。
#好像没有什么事情发生，随后你抬头看到了天上四个迅速扩大的小黑点…卧槽，术士猫猫砸的不是火球术是流星爆——
#你召唤了大火球！但是出现在你面前的是术士猫猫本体……随后你被糊了一脸的火球术。
#出现的不是火球而是一只猫…但它自称可达鸭？它说，这个火球，它吞了，快说，谢谢鸭鸭。

]]