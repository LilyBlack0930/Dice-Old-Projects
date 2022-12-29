-- {\_/}
-- (-ω-)
-- / >❤
-- VA-11 Hall-A调酒模拟-骰娘特供版
-- 脚本制作by 兔兔(1142145792)
-- 指令：.va
-- 这是会记录用户属性以进行调酒的版本

msg_order={}

function findAlcohol(msg,keyword)  -- 查找素材
	if string.match(msg.fromMsg,keyword) then  -- 如果找得到内容
		if string.match(msg.fromMsg,"%d+%s*"..keyword) then  -- 如果内容是带数字的
			local str = string.match(msg.fromMsg,"%d*%s*"..keyword)
			num = tonumber(string.match(str,"%d*"))
		else  -- 如果不带数字，就默认1
			num = 1
		end
	else  -- 如果找不到，就为0
		num = 0
	end
	return num
end

function intoKey(numAdelhyde,numBronsonExtract,numPowderedDelta,numFlanergide,numKarmotrine,ice,old,shake)
	-- 该函数有双返回值，因为原版配方中存在一些“任意Karmotrine”，而全部列出费时费力占文件大小。（虽然写注释也很占大小下次不许写了）
	local numAdelhyde = string.format("%X",numAdelhyde)
	local numBronsonExtract = string.format("%X",numBronsonExtract)
	local numPowderedDelta = string.format("%X",numPowderedDelta)
	local numFlanergide = string.format("%X",numFlanergide)
	local numKarmotrine = string.format("%X",numKarmotrine)
	if ice==1 then ICE="T" else ICE="F" end
	if old==1 then OLD="T" else OLD="F" end
	if shake==1 then SHAKE="T" else SHAKE="F" end
	fullstr = numAdelhyde..numBronsonExtract..numPowderedDelta..numFlanergide..numKarmotrine.."-"..ICE..OLD..SHAKE
	fullstrX = numAdelhyde..numBronsonExtract..numPowderedDelta..numFlanergide.."X".."-"..ICE..OLD..SHAKE
	return fullstr,fullstrX
end

function cocktail(msg)
	
	-- readConf & initialize
	-- 后方的口味备注来自少女前线va11复刻，仅供参考，但甜味和酒精两项基本是公认的。
	local numAdelhyde = getUserConf(msg.fromQQ,"numAdelhyde",0)  -- 甜、红色
	local numBronsonExtract = getUserConf(msg.fromQQ,"numBronsonExtract",0)  -- 苦、黄色
	local numPowderedDelta = getUserConf(msg.fromQQ,"numPowderedDelta",0)  -- 酸、蓝色
	local numFlanergide = getUserConf(msg.fromQQ,"numFlanergide",0)  -- 辣、绿色
	local numKarmotrine = getUserConf(msg.fromQQ,"numKarmotrine",0)  -- 酒精、白色
	local ice = getUserConf(msg.fromQQ,"vallIce",-1)  -- 加冰
	local old = getUserConf(msg.fromQQ,"vallOld",-1)  -- 陈化
	
	-- show materials
	if ice==1 then isICE="√" else isICE="×" end
	if old==1 then isOLD="√" else isOLD="×" end
	if msg.fromMsg==".va show" then return "当前素材：\n"..numAdelhyde.." Adelhyde\n"..numBronsonExtract.." Bronson Extract\n"..numPowderedDelta.." Powdered Delta\n"..numFlanergide.." Flanergide\n"..numKarmotrine.." Karmotrine\n加冰："..isICE.."\n陈化："..isOLD.."\n“调制饮料，改变人生。”" end
	
	-- process
	numAdelhyde = numAdelhyde + findAlcohol(msg,"Adelhyde") + findAlcohol(msg,"adelhyde")
	numBronsonExtract = numBronsonExtract + findAlcohol(msg,"Bronson") + findAlcohol(msg,"bronson")
	numPowderedDelta = numPowderedDelta + findAlcohol(msg,"Powdered") + findAlcohol(msg,"powdered")
	numFlanergide = numFlanergide + findAlcohol(msg,"Flanergide") + findAlcohol(msg,"flanergide")
	numKarmotrine = numKarmotrine + findAlcohol(msg,"Karmotrine") + findAlcohol(msg,"karmotrine")
	if string.match(msg.fromMsg,"加冰") then ice = ice * -1 end
	if string.match(msg.fromMsg,"陈化") then old = old * -1 end
	
	-- if more than limit
	if numAdelhyde + numBronsonExtract + numPowderedDelta + numFlanergide + numKarmotrine > 20 then return "你加入的素材总数超过最大上限(20)，添加失败！" end
	if numAdelhyde>10 then numAdelhyde=10 end
	if numBronsonExtract>10 then numBronsonExtract=10 end
	if numPowderedDelta>10 then numPowderedDelta=10 end
	if numFlanergide>10 then numFlanergide=10 end
	if numKarmotrine>10 then numKarmotrine=10 end
	
	-- setConf
	setUserConf(msg.fromQQ,"numAdelhyde",numAdelhyde)
	setUserConf(msg.fromQQ,"numBronsonExtract",numBronsonExtract)
	setUserConf(msg.fromQQ,"numPowderedDelta",numPowderedDelta)
	setUserConf(msg.fromQQ,"numFlanergide",numFlanergide)
	setUserConf(msg.fromQQ,"numKarmotrine",numKarmotrine)
	setUserConf(msg.fromQQ,"vallIce",ice)
	setUserConf(msg.fromQQ,"vallOld",old)
	
	-- make blend
	if string.match(msg.fromMsg,"调制") then return blendShort(msg,numAdelhyde,numBronsonExtract,numPowderedDelta,numFlanergide,numKarmotrine,ice,old) end
	if string.match(msg.fromMsg,"调和") then return blendLong(msg,numAdelhyde,numBronsonExtract,numPowderedDelta,numFlanergide,numKarmotrine,ice,old) end
	
	-- reset all materials
	if string.match(msg.fromMsg,"重做") or string.match(msg.fromMsg,"reset") then return vallReset(msg) end
	
	-- make return
	if findAlcohol(msg,"Adelhyde") + findAlcohol(msg,"Bronson") + findAlcohol(msg,"Powdered") + findAlcohol(msg,"Flanergide") + findAlcohol(msg,"Karmotrine") + findAlcohol(msg,"adelhyde") + findAlcohol(msg,"bronson") + findAlcohol(msg,"powdered") + findAlcohol(msg,"flanergide") + findAlcohol(msg,"karmotrine") ~= 0 or string.match(msg.fromMsg,"加冰") or string.match(msg.fromMsg,"陈化") then
		-- 如果有修改
		if ice==1 then isICE="√" else isICE="×" end
		if old==1 then isOLD="√" else isOLD="×" end
		return "你对配料做出了一些修改……\n当前素材：\n"..numAdelhyde.." Adelhyde\n"..numBronsonExtract.." Bronson Extract\n"..numPowderedDelta.." Powdered Delta\n"..numFlanergide.." Flanergide\n"..numKarmotrine.." Karmotrine\n加冰："..isICE.."\n陈化："..isOLD
	end
	
	-- some default commands
	if msg.fromMsg==".va" or string.match(msg.fromMsg,"help") then return "欢迎来到VA-11 Hall-A调酒模拟-骰娘特供版！\n发送[.va show]查看当前已添加的素材\n发送[.va list]查看Jill的调酒列表\n输入[.va]后接任意数量操作以调酒\n操作列表：\n(1-10)Adelhyde\n(1-10)Bronson Extract\n(1-10)Powdered Delta\n(1-10)Flanergide\n(1-10)Karmotrine\n加冰(再次发送以取消)\n陈化(再次发送以取消)\n调和/调制(存在此关键词将立即制作)\n重做/reset(重置为原始状态)" end
	
	-- show recipe
	if string.match(msg.fromMsg,"list") then return "使用[.va recipe 名称]来查询\n配方列表：\n1. Bad Touch\n2. Beer\n3. Bleeding Jane\n4. Bloom Light\n5. Blue Fairy\n6. Brandtini\n7. Cobalt Velvet\n8. Crevice Spike\n9. Fluffy Dream\n10. Fringe Weaver\n11. Frothy Water\n12. Grizzly Temple\n13. Gut Punch\n14. Marsblast\n15. Mercury Blast\n16. Moonblast\n17. Piano Man\n18. Piano Woman\n19. Piledriver\n20. Sparkle Star\n21. Sugar Rush\n22. Sunshine Cloud\n23. Suplex\n24. Zen Star" end
	
	if string.match(msg.fromMsg,"recipe") then
		return vallRecipe(msg.fromMsg)
	end
	
	-- 要是走到这里，就说明表达式过完了都不知道想干什么……
	-- 特此留一个注释掉的return，以检测是否出现指令问题
	-- return "VA-11 Hall-A调酒模拟-骰娘特供版\n未知指令：\n"..msg.fromMsg
end
cocktail_order = ".va"
msg_order[cocktail_order] = "cocktail"

function vallReset(msg)
	setUserConf(msg.fromQQ,"numAdelhyde",0)
	setUserConf(msg.fromQQ,"numBronsonExtract",0)
	setUserConf(msg.fromQQ,"numPowderedDelta",0)
	setUserConf(msg.fromQQ,"numFlanergide",0)
	setUserConf(msg.fromQQ,"numKarmotrine",0)
	setUserConf(msg.fromQQ,"vallIce",-1)
	setUserConf(msg.fromQQ,"vallOld",-1)
	return "你将素材倒空了……\n“有时重新开始也未尝不是一件坏事。”"
end

function blendShort(msg,numAdelhyde,numBronsonExtract,numPowderedDelta,numFlanergide,numKarmotrine,ice,old)
	vallKey,vallKeyX = intoKey(numAdelhyde,numBronsonExtract,numPowderedDelta,numFlanergide,numKarmotrine,ice,old,0)
	
	if vallKey=="00000-FFF" then return "你还什么都没加呢！" end
	
	if vallhalla[vallKey] or vallhalla[vallKeyX] then 
		if vallhalla[vallKey] then product=vallhalla[vallKey]
		else product=vallhalla[vallKeyX] end
	else
		product=vallhalla.error[ranint(1,6)]
	end
	setUserConf(msg.fromQQ,"numAdelhyde",0)
	setUserConf(msg.fromQQ,"numBronsonExtract",0)
	setUserConf(msg.fromQQ,"numPowderedDelta",0)
	setUserConf(msg.fromQQ,"numFlanergide",0)
	setUserConf(msg.fromQQ,"numKarmotrine",0)
	setUserConf(msg.fromQQ,"vallIce",-1)
	setUserConf(msg.fromQQ,"vallOld",-1)
	return "你调出了一杯"..product
end

function blendLong(msg,numAdelhyde,numBronsonExtract,numPowderedDelta,numFlanergide,numKarmotrine,ice,old)
	vallKey,vallKeyX = intoKey(numAdelhyde,numBronsonExtract,numPowderedDelta,numFlanergide,numKarmotrine,ice,old,1)
	
	if vallKey=="00000-FFT" then return "你还什么都没加呢！" end
	
	if vallhalla[vallKey] or vallhalla[vallKeyX] then 
		if vallhalla[vallKey] then product=vallhalla[vallKey]
		else product=vallhalla[vallKeyX] end
	else
		product=vallhalla.error[ranint(1,6)]
	end
	
	setUserConf(msg.fromQQ,"numAdelhyde",0)
	setUserConf(msg.fromQQ,"numBronsonExtract",0)
	setUserConf(msg.fromQQ,"numPowderedDelta",0)
	setUserConf(msg.fromQQ,"numFlanergide",0)
	setUserConf(msg.fromQQ,"numKarmotrine",0)
	setUserConf(msg.fromQQ,"vallIce",-1)
	setUserConf(msg.fromQQ,"vallOld",-1)
	
	return "你调出了一杯"..product
end

function vallRecipe(keyword)
	
	if string.match(keyword,"Zen Star") then return vrecipe[24] end
	if string.match(keyword,"Suplex") then return vrecipe[23] end
	if string.match(keyword,"Sunshine Cloud") then return vrecipe[22] end
	if string.match(keyword,"Sugar Rush") then return vrecipe[21] end
	if string.match(keyword,"Sparkle Star") then return vrecipe[20] end
	if string.match(keyword,"Piledriver") then return vrecipe[19] end
	if string.match(keyword,"Piano Woman") then return vrecipe[18] end
	if string.match(keyword,"Piano Man") then return vrecipe[17] end
	if string.match(keyword,"Moonblast") then return vrecipe[16] end
	if string.match(keyword,"Mercury Blast") then return vrecipe[15] end
	if string.match(keyword,"Marsblast") then return vrecipe[14] end
	if string.match(keyword,"Gut Punch") then return vrecipe[13] end
	if string.match(keyword,"Grizzly Temple") then return vrecipe[12] end
	if string.match(keyword,"Frothy Water") then return vrecipe[11] end
	if string.match(keyword,"Fringe Weaver") then return vrecipe[10] end
	if string.match(keyword,"Fluffy Dream") then return vrecipe[9] end
	if string.match(keyword,"Crevice Spike") then return vrecipe[8] end
	if string.match(keyword,"Cobalt Velvet") then return vrecipe[7] end
	if string.match(keyword,"Brandtini") then return vrecipe[6] end
	if string.match(keyword,"Blue Fairy") then return vrecipe[5] end
	if string.match(keyword,"Bloom Light") then return vrecipe[4] end
	if string.match(keyword,"Bleeding Jane") then return vrecipe[3] end
	if string.match(keyword,"Beer") then return vrecipe[2] end
	if string.match(keyword,"Bad Touch") then return vrecipe[1] end
	if string.match(keyword,"Flaming Moai") then return "【Flaming Moai】\n这个酒并没有记在Jill的配方表中……不过，或许你可以试试斐波那契数列？" end  -- hidden
	
	-- 自定义酒的位置
	if string.match(keyword,"Cold Water") then return "【Cold Water】\n想要一杯水？那你去把冰放化了吧。" end
	if string.match(keyword,"Lonely Jellyfish") then return "【Lonely Jellyfish】\n它的主要配方是一滴“甜味”、一些“蓝色”、以及其三倍的“酒精”。" end
	if string.match(keyword,"Mexico Sunrise") then return "【Mexico Sunrise】\n它的主要配方是两份“红色”、其两倍的“黄色”、任意的“酒精”，以及大量的冰块。" end
	
	recipeOrder = tonumber(string.match(keyword,"%d+"))  -- 数字序号
	if recipeOrder then
		if vrecipe[recipeOrder] then
			return vrecipe[recipeOrder]
		else
			return vrecipe[0]
		end
	end
	
end

vallhalla = {}
vallhalla["error"] = {"#y#bb=","##20%!!","#u??!!","f@###","n#@##*","gt??!#"}
vallhalla["02224-TFF"] = "Bad Touch\n“我们毕竟不过是群哺乳动物。”\n酸味，时尚，复古。"
vallhalla["04448-TFF"] = "Bad Touch\n“我们毕竟不过是群哺乳动物。”\n酸味，时尚，复古。"  -- large
vallhalla["12124-FFF"] = "Beer\n“以传统手法酿造的啤酒已经成为了奢侈品，但这种酒和真货的味道相当接近……”\n发泡，时尚，复古。"
vallhalla["24248-FFF"] = "Beer\n“以传统手法酿造的啤酒已经成为了奢侈品，但这种酒和真货的味道相当接近……”\n发泡，时尚，复古。"  -- large
vallhalla["01330-FFT"] = "Bleeding Jane\n“对着镜子重复三次这杯饮料的名字，就会让你看上去像个傻瓜。”\n辛辣，经典，解酒。"
vallhalla["02660-FFT"] = "Bleeding Jane\n“对着镜子重复三次这杯饮料的名字，就会让你看上去像个傻瓜。”\n辛辣，经典，解酒。"  -- large
vallhalla["40123-TTF"] = "Bloom Light\n“这杯酒泛着完全多余的灰褐色……”\n辛辣，宣传，清淡。"
vallhalla["80246-TTF"] = "Bloom Light\n“这杯酒泛着完全多余的灰褐色……”\n辛辣，宣传，清淡。"  -- large
vallhalla["4001X-FTF"] = "Blue Fairy\n“只喝一口就能让你的牙齿变蓝。希望你喝完之后能好好刷牙。”\n甜味，女性化，温和。"
vallhalla["8002X-FTF"] = "Blue Fairy\n“只喝一口就能让你的牙齿变蓝。希望你喝完之后能好好刷牙。”\n甜味，女性化，温和。"  -- large
vallhalla["60301-FTF"] = "Brandtini\n“每10个自命不凡的混球里就会有8个推荐这种酒，但他们沉溺于自命不凡没空为人推荐什么。”\n甜味，时尚，惬意。"
vallhalla["20035-TFF"] = "Cobalt Velvet\n“如同把香槟倒在还剩一点可乐的杯子里。”\n发泡，时尚，火辣。 "
vallhalla["4006A-TFF"] = "Cobalt Velvet\n“如同把香槟倒在还剩一点可乐的杯子里。”\n发泡，时尚，火辣。 "  -- large
vallhalla["0024X-FFT"] = "Crevice Spike\n“它既能把你的醉意驱除，也能够把你的意识驱除。”\n酸味，男性化，解酒。"
vallhalla["0048X-FFT"] = "Crevice Spike\n“它既能把你的醉意驱除，也能够把你的意识驱除。”\n酸味，男性化，解酒。"  -- large
vallhalla["3030X-FTF"] = "Fluffy Dream\n“一两口就足以取悦你的舌头，再多喝就可能会导致睡过头。”\n酸味，女性化，温和。"
vallhalla["6060X-FTF"] = "Fluffy Dream\n“一两口就足以取悦你的舌头，再多喝就可能会导致睡过头。”\n酸味，女性化，温和。"  -- large
vallhalla["10009-FTF"] = "Fringe Weaver\n“如同就着一勺糖喝下无水酒精。”\n发泡，时尚，强烈。"
vallhalla["11110-FTF"] = "Frothy Water\n“自2040年以来，家长指导级节目里最受用的啤酒代用品。”\n发泡，经典，清淡。"
vallhalla["22220-FTF"] = "Frothy Water\n“自2040年以来，家长指导级节目里最受用的啤酒代用品。”\n发泡，经典，清淡。"  -- large
vallhalla["33301-FFT"] = "Grizzly Temple\n“这种酒的味道几乎令人难以忍受。基本上只有它所宣传的那部电影的爱好者会点它。”\n苦味，宣传，清淡。"
vallhalla["66602-FFT"] = "Grizzly Temple\n“这种酒的味道几乎令人难以忍受。基本上只有它所宣传的那部电影的爱好者会点它。”\n苦味，宣传，清淡。"  -- large
vallhalla["0501X-FTF"] = "Gut Punch\n“这个名字的意思是'由内脏(Gut)制成的混合饮料(Punch)'，但是同时也描述了饮用时的感受(重击腹部)。”\n苦味，男性化，强烈。"
vallhalla["0A02X-FTF"] = "Gut Punch\n“这个名字的意思是'由内脏(Gut)制成的混合饮料(Punch)'，但是同时也描述了饮用时的感受(重击腹部)。”\n苦味，男性化，强烈。"  -- large
vallhalla["06142-FFT"] = "Marsblast\n“只要喝上一口就足以让你的脸像火星一样红。”\n辛辣，男性化，强烈。"
vallhalla["11332-TFT"] = "Mercury Blast\n“在这种酒研发过程中，没有温度计遭到伤害。”\n酸味，时尚，火辣。"
vallhalla["22664-TFT"] = "Mercury Blast\n“在这种酒研发过程中，没有温度计遭到伤害。”\n酸味，时尚，火辣。"  -- large
vallhalla["60112-TFT"] = "Moonblast\n“与你每个月都有一周时间能看到的那座月球强子大炮没有关系。”\n甜味，女性化，惬意。"
vallhalla["23553-TFF"] = "Piano Man\n“该饮品不代表酒吧钢琴师协会及其相关组织的意见。”\n酸味，宣传，强烈。"
vallhalla["55233-FTF"] = "Piano Woman\n“它的本名是Pretty Woman，但有很多人投诉如果有种酒叫Piano Man(男钢琴师)，那就该有另一种被命名为Piano Woman(女钢琴师)。”\n甜味，宣传，惬意。"
vallhalla["03034-FFF"] = "Piledriver\n“你的舌头可能察觉不到它的火辣程度，但喝的时候请小心不要烧到嗓子。”\n苦味，男性化，火辣。"
vallhalla["06068-FFF"] = "Piledriver\n“你的舌头可能察觉不到它的火辣程度，但喝的时候请小心不要烧到嗓子。”\n苦味，男性化，火辣。"  -- large
vallhalla["2010X-FTF"] = "Sparkle Star\n“这种饮料曾经真的能够迸出(Sparkle)杯子，但这导致过多顾客投诉皮肤问题，于是他们被迫重新设计了不会迸射出任何东西的版本。”\n甜味，女性化，惬意。"
vallhalla["4020X-FTF"] = "Sparkle Star\n“这种饮料曾经真的能够迸出(Sparkle)杯子，但这导致过多顾客投诉皮肤问题，于是他们被迫重新设计了不会迸射出任何东西的版本。”\n甜味，女性化，惬意。"  -- large
vallhalla["2010X-FFF"] = "Sugar Rush\n“甘甜，清淡，水果风味，不能更加女性化的饮品。”\n甜味，女性化，惬意。"
vallhalla["4020X-FFF"] = "Sugar Rush\n“甘甜，清淡，水果风味，不能更加女性化的饮品。”\n甜味，女性化，惬意。"  -- large
vallhalla["2200X-TFT"] = "Sunshine Cloud\n“味道就像昔日的巧克力牛奶，甚至还保留着那份香气。也有人说它有些焦糖的味道……”\n苦味，女性化，温和。"
vallhalla["4400X-TFT"] = "Sunshine Cloud\n“味道就像昔日的巧克力牛奶，甚至还保留着那份香气。也有人说它有些焦糖的味道……”\n苦味，女性化，温和。"  -- large
vallhalla["04033-TFF"] = "Suplex\n“对Piledriver进行微妙调整之后，将火辣的感觉从喉咙转移到了舌头上。”\n苦味，男性化，火辣。"
vallhalla["08066-TFF"] = "Suplex\n“对Piledriver进行微妙调整之后，将火辣的感觉从喉咙转移到了舌头上。”\n苦味，男性化，火辣。"  -- large
vallhalla["44444-TFF"] = "Zen Star\n“你可能会认为如此均衡的配方能够将这杯酒变得美味了……那你就大错特错了。”\n酸味，宣传，清淡。"
vallhalla["11235-FFF"] = "Flaming Moai"

-- 下面是自创配方示例。也可以自行添加其他配方
vallhalla["00000-TFF"] = "Cold Water\n“这白开水怎么没味啊。”\n无味，清淡，温和。"  -- 什么都不加只加冰
vallhalla["000A0-FTT"] = "Nuclear Wastewater\n“小绵羊脏了——”\n苦味，宣传，强烈。"  -- 10份Flanergide，陈化，调和
vallhalla["0000A-FFF"] = "Spirytus\n“它还有一个更响亮的名号——‘生命之水’。”\n辛辣，强烈，复古。"  -- 10份Karmotrine
vallhalla["A0000-FFF"] = "Syrup\n“现在你获得了一杯纯糖浆，满意了吗？”\n甜味，经典，强烈。"  -- 10份Adelhyde
vallhalla["10309-FFF"] = "Lonely Jellyfish\n“这款饮料的卖点只有悬浮在中间的水母而已，至于孤独的解释权则归水母所有。”\n甜味，宣传，女性化。"  -- 1份Adelhyde，3份Powdered Delta，9份酒精
vallhalla["2400X-TFF"] = "Mexico Sunrise\n“模拟了日出时天空的颜色。推荐在夏季饮用。”\n酸味，宣传，惬意。"  -- 2份Adelhyde，4份Bronson Extract，任选酒精，加冰
vallhalla["4800X-TFF"] = "Mexico Sunrise\n“模拟了日出时天空的颜色。推荐在夏季饮用。”\n酸味，宣传，惬意。"  -- large

-- vallhalla[""] = ""

vrecipe = {}
vrecipe[0] = "配方编号错误，请重新输入！"
vrecipe[1] = "【Bad Touch】\nBad Touch是由2 Bronson Extract、2 Powdered Delta、2 Flanergide和4 Karmotrine加冰，调制而成。"
vrecipe[2] = "【Beer】\nBeer是由1 Adelhyde、2 Bronson Extract、1 Powdered Delta、2 Flanergide和4 Karmotrine调制而成。"
vrecipe[3] = "【Bleeding Jane】\nBleeding Jane是由1 Bronson Extract、3 Powdered Delta和3 Flanergide调和而成。"
vrecipe[4] = "【Bloom Light】\nBloom Light是由4 Adelhyde、1 Powdered Delta、2 Flanergide和3 Karmotrine陈化，加冰，调制而成。"
vrecipe[5] = "【Blue Fairy】\nBlue Fairy是由4 Adelhyde、1 Flanergide和任选Karmotrine陈化，调制而成。"
vrecipe[6] = "【Brandtini】\nBrandtini是由6 Adelhyde、3 Powdered Delta和1 Karmotrine陈化，调制而成。"
vrecipe[7] = "【Cobalt Velvet】\nCobalt Velvet是由2 Adelhyde、3 Flanergide和5 Karmotrine加冰，调制而成。" 
vrecipe[8] = "【Crevice Spike】\nCrevice Spike是由2 Powdered Delta、4 Flanergide和任选Karmotrine调和而成。"
vrecipe[9] = "【Fluffy Dream】\nFluffy Dream是由3 Adelhyde、3 Powdered Delta和任选Karmotrine陈化，调制而成。"
vrecipe[10] = "【Fringe Weaver】\nFringe Weaver是由1 Adelhyde和9 Karmotrine陈化，调制而成。"
vrecipe[11] = "【Frothy Water】\nFrothy Water是由1 Adelhyde、1 Bronson Extract、1 Powdered Delta和1 Flanergide陈化，调制而成。"
vrecipe[12] = "【Grizzly Temple】\nGrizzly Temple是由3 Adelhyde、3 Bronson Extract、3 Powdered Delta和1 Karmotrine调和而成。"
vrecipe[13] = "【Gut Punch】\nGut Punch是由5 Bronson Extract、1 Flanergide和任选Karmotrine陈化，调制而成。"
vrecipe[14] = "【Marsblast】\nMarsblast是由6 Bronson Extract、1 Powdered Delta、4 Flanergide和2 Karmotrine调和而成。"
vrecipe[15] = "【Mercury Blast】\nMercury Blast是由1 Adelhyde、1 Bronson Extract、3 Powdered Delta、3 Flanergide和2 Karmotrine加冰，调和而成。"
vrecipe[16] = "【Moonblast】\nMoonblast是由6 Adelhyde、1 Powdered Delta、1 Flanergide和2 Karmotrine加冰，调和而成。"
vrecipe[17] = "【Piano Man】\n Piano Man是由2 Adelhyde、3 Bronson Extract、5 Powdered Delta、5 Flanergide和3 Karmotrine加冰，调制而成。"
vrecipe[18] = "【Piano Woman】\nPiano Woman是由5 Adelhyde、5 Bronson Extract、2 Powdered Delta、3 Flanergide和3 Karmotrine陈化，调制而成。"
vrecipe[19] = "【Piledriver】\nPiledriver是由3 Bronson Extract、3Flanergide和4 Karmotrine调制而成。"
vrecipe[20] = "【Sparkle Star】\nSparkle Star是由2Adelhyde、1 Powdered Delta和任选Karmotrine陈化，调制而成。"
vrecipe[21] = "【Sugar Rush】\nSugar Rush是由2 Adelhyde、1 Powdered Delta和任选Karmotrine调制而成。"
vrecipe[22] = "【Sunshine Cloud】\nSunshine Cloud是由2 Adelhyde、2 Bronson Extract和任选Karmotrine加冰，调和而成。"
vrecipe[23] = "【Suplex】\nSuplex是由4 Bronson Extract、3 Flanergide和3 Karmotrine加冰，调制而成。"
vrecipe[24] = "【Zen Star】\nZen Star是由每种原料各4份，加冰，调制而成。"