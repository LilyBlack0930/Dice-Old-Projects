msg_order = {}

require("aaa")

function ttdtpd(msg)
	deck = drawDeck(getDiceQQ(),0,"兔兔的甜品店")	-- 从兔兔的甜品店牌堆里抽取并写入deck
	ret = deck	--返回结果的第一段：牌堆抽取结果本体
	res = {}	--数组变量
	n = 1	--算数
	for word in string.gmatch(deck,"%d+[.]*[0-9]*c") do	--自动搜寻其中含价位的部分，带C
		res[n] = tonumber(string.sub(word,1,-2))	--剔除C并转数字
		n = n + 1	--计数
	end
	lossC = 0	--初始化并赋值，作为最终扣除的金钱
	if res[1] then lossC=lossC+res[1] end		-- 大智慧
	if res[2] then lossC=lossC+res[2] end		-- 大功德
	if res[3] then lossC=lossC+res[3] end		-- 大慈悲
	ownC = getUserConf(msg.fromQQ,"C币",0) -- 获取现有C币
	modC = ownC - lossC
	if modC<0 then
		if ownC == 0 then
			ret = ret .. "\n但是你已经身无分文……\n从角落里钻出数只兔兔，把甜品分走了。"
		else
			modC = 0
			ret = ret .. "\n"
		end
	elseif modC==0 then
		
	else
		
	end
	return deck .. "\n这一顿共花了你" .. lossC .. "C！"
end
msg_order["兔兔的甜品店"] = "ttdtpd"