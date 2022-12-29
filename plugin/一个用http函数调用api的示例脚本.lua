--[[ 
{\_/}		参考：基于lua-mirai的脚本中心仓库Lua Script Center(https://gitee.com/ooooonly/lua-mirai-project/tree/master/ScriptCenter)
(-ω-)		脚本制作 by 兔兔(1142145792)
/ >❤ 		只是把LuaMirai项目中的很多需要使用http请求就可以解决的项目搬运了过来，属于普通的娱乐型自用脚本
]]
msg_order = {}

function U2S(msg)
	local item = ""
	local text = string.gsub(string.gsub(msg,"\\u","|0x"),"|","",1)
	local items = {}
	repeat
		item, text = string.match(text,"^([^|]*)[|]*(.-)$")  -- 按|拆分
		table.insert(items,item)
	until(text=="")
	ret = ""
	for i,v in ipairs(items) do
		if #v <= 6 then
			ret = ret .. utf8.char(tonumber(v))
		else
			ret = ret .. utf8.char(tonumber(string.sub(v,1,6))) .. string.gsub(string.sub(v,7),"\\n","\n")
		end
	end
	return ret
end

function caihongpi(msg)
	chp_res,chp_data = http.get("https://api.shadiao.app/chp")
	rest = U2S(string.match(chp_data,[["text":"(.*)"]]))
	
	return "To {nick}：\n" .. rest
end
msg_order["彩虹屁"] = "caihongpi"
msg_order["夸我"] = "caihongpi"

function hitokoto(msg)
	htkt_res,htkt_data = http.get("https://api.ixiaowai.cn/ylapi/index.php")
	return "{nick}，你要的一言来了：\n" .. htkt_data
end
msg_order["一言"] = "hitokoto"

function dujitang(msg)
	djt_res,djt_data = http.get("https://api.shadiao.app/du")
	rest = U2S(string.match(djt_data,[["text":"(.*)"]]))
	return "To {nick}：\n" .. rest
end
msg_order["毒鸡汤"] = "dujitang"

function pengyouquan(msg)
	pyq_res,pyq_data = http.get("https://api.shadiao.app/pyq")
	rest = U2S(string.match(pyq_data,[["text":"(.*)"]]))
	return "{nick}，你要的朋友圈文案来了：\n" .. rest
end
msg_order["朋友圈"] = "pengyouquan"
