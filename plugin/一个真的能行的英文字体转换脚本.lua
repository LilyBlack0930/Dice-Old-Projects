--[[ 
{\_/}		参考网址：https://beizhedenglong.github.io/weird-fonts/
(-ω-)		脚本制作 by 兔兔(1142145792)
/ >❤ 		其实只是由一个进行中的项目的中间产物衍生出来的想法，在Shiki的提点下顺畅地跑了起来。
			用途很简单，就是把你的字体里的能转换的部分都换成花体。
			部分字体我查了Unicode库确认是不支持或被保留替换的，也为此做了相应的调整，可能看上去不一样但他们要求就是改成那个（。）
]]
msg_order = {}

--以下为可自定义部分

--用于让骰娘进行转换字体的语句。默认为“字体转换”。
font_FontChanger_order = "字体转换"

--单次转换限定长度
font_FontChanger_length = 100

--以上为可自定义部分

msg_order[font_FontChanger_order] = "font_FontChanger"

function font_FontChanger(msg)
	local raw = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#font_FontChanger_order+1)--屏蔽空格并获取待转换内容
	local a = string.match(raw,":image,")
	if (#raw == 0) then	--检测字串长度，为0则传回默认内容
		return "一个真的能行的英文字体转换脚本 by兔兔零号机\n输入“字体转换”后跟想要的字符以获得效果，注意大多数情况下英文外的字符会被原封不动地送回哦。"
	elseif (a ~= nil) then
		return "一个真的能行的英文字体转换脚本 by兔兔零号机\n输入“字体转换”后跟想要的字符以获得效果，注意大多数情况下英文外的字符会被原封不动地送回哦。\n\n出现错误：语句中存在图片，请重新输入！"
	elseif (#raw > font_FontChanger_length) then
		return "一个真的能行的英文字体转换脚本 by兔兔零号机\n输入“字体转换”后跟想要的字符以获得效果，注意大多数情况下英文外的字符会被原封不动地送回哦。\n\n出现错误：输入内容过长！限制字数：" .. font_FontChanger_length .. "，当前输入字数：" .. #raw .."，中文字符三倍计算。为防止刷屏造成骰子被风控等不良后果，请重新输入！"
	else
		if (msg.fromGroup == "0") then
			return "你输入的内容为：\n" .. raw .. "\n结果为：\n" .. font_Light_Serif(raw) .. "\n" .. font_Serif_Italic(raw) .. "\n" .. font_Serif_Bold(raw) .. "\n" .. font_Serif_Bold_Italic(raw) .. "\n" .. font_Sans_Serif_Normal(raw) .. "\n" .. font_Sans_Serif_Italic(raw) .. "\n" .. font_Script_Normal(raw) .. "\n" .. font_Script_Bold(raw) .. "\n" .. font_Fraktur_Normal(raw) .. "\n" .. font_Fraktur_Bold(raw) .. "\n" .. font_Mono_Space(raw) .. "\n" .. font_Double_Struck(raw) .. "\n" .. font_Circle(raw) .. "\n" .. font_Sqare(raw) .. "\n" .. font_Regional_Flag_Indicator(raw)
		else
			--sendMsg("你输入的内容为：\n" .. raw .. "\n结果为：\n" .. font_Light_Serif(raw) .. "\n" .. font_Serif_Italic(raw) .. "\n" .. font_Serif_Bold(raw) .. "\n" .. font_Serif_Bold_Italic(raw) .. "\n" .. font_Sans_Serif_Normal(raw) .. "\n" .. font_Sans_Serif_Italic(raw) .. "\n" .. font_Script_Normal(raw) .. "\n" .. font_Script_Bold(raw) .. "\n" .. font_Fraktur_Normal(raw) .. "\n" .. font_Fraktur_Bold(raw) .. "\n" .. font_Mono_Space(raw) .. "\n" .. font_Double_Struck(raw) .. "\n" .. font_Circle(raw) .. "\n" .. font_Sqare(raw) .. "\n" .. font_Regional_Flag_Indicator(raw),0,msg.fromQQ)
			--return "你输入的内容为：\n" .. raw .. "\n结果为：\n" .. font_Serif_Bold(raw) .. "\n" .. font_Script_Normal(raw) .. "\n" .. font_Fraktur_Normal(raw) .. "\n......\n为防止大面积刷屏，仅保留部分内容，骰娘已经把完整内容通过小窗发给你啦~\n如果没有收到私聊，请添加骰娘为好友后尝试再次小窗发送~\n（通知：由于腾讯大面积封杀骰娘，小窗发送已被手动取消，请先添加骰娘为好友再进行）"
			return "你输入的内容为：\n" .. raw .. "\n结果为：\n" .. font_Light_Serif(raw) .. "\n" .. font_Serif_Italic(raw) .. "\n" .. font_Serif_Bold(raw) .. "\n" .. font_Serif_Bold_Italic(raw) .. "\n" .. font_Sans_Serif_Normal(raw) .. "\n" .. font_Sans_Serif_Italic(raw) .. "\n" .. font_Script_Normal(raw) .. "\n" .. font_Script_Bold(raw) .. "\n" .. font_Fraktur_Normal(raw) .. "\n" .. font_Fraktur_Bold(raw) .. "\n" .. font_Mono_Space(raw) .. "\n" .. font_Double_Struck(raw) .. "\n" .. font_Circle(raw) .. "\n" .. font_Sqare(raw) .. "\n" .. font_Regional_Flag_Indicator(raw)
		end
	end
end

function font_Light_Serif(str)
	return calc(str,65248,65248,0,"font_Light_Serif")
end

function font_Serif_Italic(str)
	return calc(str,119795,119789,0,"font_Serif_Italic")
end

function font_Serif_Bold(str)
	return calc(str,119743,119737,0,"font_Serif_Bold")
end

function font_Serif_Bold_Italic(str)
	return calc(str,119847,119841,0,"font_Serif_Bold_Italic")
end

function font_Sans_Serif_Normal(str)
	return calc(str,120159,120153,0,"font_Sans_Serif_Normal")
end

function font_Sans_Serif_Italic(str)
	return calc(str,120263,120257,0,"font_Sans_Serif_Italic")
end

function font_Script_Normal(str)
	return calc(str,119899,119893,0,"font_Script_Normal")
end

function font_Script_Bold(str)
	return calc(str,119951,119945,0,"font_Script_Bold")
end

function font_Fraktur_Normal(str)
	return calc(str,120003,119997,0,"font_Fraktur_Normal")
end

function font_Fraktur_Bold(str)
	return calc(str,120107,120101,0,"font_Fraktur_Bold")
end

function font_Mono_Space(str)
	return calc(str,120367,120361,0,"font_Mono_Space")
end

function font_Double_Struck(str)
	return calc(str,120055,120049,0,"font_Double_Struck")
end

function font_Circle(str)
	return calc(str,9333,9327,0,"font_Circle")
end

function font_Sqare(str)
	return calc(str,127215,127183,0,"font_Sqare")
end

function font_Regional_Flag_Indicator(str)
	return calc(str,127397,127365,1,"font_Regional_Flag_Indicator")
end

function calc(str,modUpper,modLower,SpaceBar,fontType)--计算用的主函数
	local ret = ""
	for p, c in utf8.codes(str) do --此时c已经是十进制
		local Dec = c
		if (c>=65 and c<=90) then --大写
			if fontType=="font_Bordered" then --部分字体需要特殊处理
				if Dec == 67 then modDec = 8450
				elseif Dec == 72 then modDec = 8461
				elseif Dec == 78 then modDec = 8469
				elseif Dec == 80 then modDec = 8473
				elseif Dec == 81 then modDec = 8474
				elseif Dec == 82 then modDec = 8477
				elseif Dec == 90 then modDec = 8484
				else modDec = Dec + modUpper
				end
			elseif fontType=="font_Script_Normal" then
				if Dec == 66 then modDec = 8492
				elseif Dec == 69 then modDec = 8497
				elseif Dec == 70 then modDec = 8496
				elseif Dec == 72 then modDec = 8459
				elseif Dec == 73 then modDec = 8464
				elseif Dec == 76 then modDec = 8466
				elseif Dec == 77 then modDec = 8499
				elseif Dec == 82 then modDec = 8475
				else modDec = Dec + modUpper
				end
			elseif fontType=="font_Fraktur_Normal" then
				if Dec == 67 then modDec = 8493
				elseif Dec == 72 then modDec = 8460
				elseif Dec == 73 then modDec = 8465
				elseif Dec == 82 then modDec = 8476
				elseif Dec == 90 then modDec = 8488
				else modDec = Dec + modUpper
				end
			elseif fontType=="font_Double_Struck" then
				if Dec == 67 then modDec = 8450
				elseif Dec == 72 then modDec = 8461
				elseif Dec == 78 then modDec = 8469
				elseif Dec == 80 then modDec = 8473
				elseif Dec == 81 then modDec = 8474
				elseif Dec == 82 then modDec = 8477
				elseif Dec == 90 then modDec = 8484
				else modDec = Dec + modUpper
				end
			else modDec = Dec + modUpper --加值
			end
		elseif (c>=97 and c<=122) then --小写
			if fontType=="font_Serif_Italic" then
				if Dec == 104 then modDec = 8462
				else modDec = Dec + modLower
				end
			elseif fontType=="font_Script_Normal" then
				if Dec == 101 then modDec = 8495
				elseif Dec == 103 then modDec = 8458
				elseif Dec == 111 then modDec = 8500
				else modDec = Dec + modLower
				end
			else modDec = Dec + modLower
			end
		else --啥也不是的情况
			if (Dec>=48 and Dec <=57) then --仅针对数字0-9
				if fontType=="font_Serif_Bold" then modDec = Dec + 120734
				elseif fontType=="font_Double_Struck" then modDec = Dec + 120744
				elseif fontType=="font_Circle" then
					if Dec == 48 then modDec = 9450
					else modDec = Dec + 9263
					end
				else modDec = Dec
				end
			else
				modDec = Dec
			end
		end
		ret = ret .. "[CQ:emoji,id=" .. modDec .. "]"
		if (SpaceBar == 1 and ((c>=65 and c<=90) or (c>=97 and c<=122))) then--仅对英文进行空格区分
			ret = ret .. " "
		end
	end
	local toChar = ret
	return toChar
end
