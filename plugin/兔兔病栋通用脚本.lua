msg_order = {}

require("aaa")

function NoImage(msg)
	if msg.fromQQ~="1142145792" then return "" end
	setUserConf(getDiceQQ(),"NoImage",1)
	return "已开启无图模式。\n目前应用无图模式变量的脚本有：\n兔兔病栋签到.lua"
end
msg_order["开启无图模式"]="NoImage"

function WithImage(msg)
	if msg.fromQQ~="1142145792" then return "" end
	setUserConf(getDiceQQ(),"NoImage",0)
	return "已关闭无图模式。\n目前应用无图模式变量的脚本有：\n兔兔病栋签到.lua"
end
msg_order["关闭无图模式"]="WithImage"

function SeeImage(msg)
	if msg.fromQQ~="1142145792" then return "" end
	return "当前无图模式状态为：" .. quzheng(getUserConf(getDiceQQ(),"NoImage",0)) .. "。\n目前应用无图模式变量的脚本有：\n兔兔病栋签到.lua"
end
msg_order["查询无图模式"]="SeeImage"
msg_order["查看无图模式"]="SeeImage"


function DoListen(msg)
	if msg.fromQQ~="1142145792" then return "" end
	setUserConf(getDiceQQ(),"DoListen",1)
	return "已开启监听模式。\n目前应用监听模式变量的脚本有：\n兔兔病栋签到.lua\n兔兔病栋礼物.lua\n兔兔病栋留言.lua"
end
msg_order["开启监听模式"]="DoListen"

function NoListen(msg)
	if msg.fromQQ~="1142145792" then return "" end
	setUserConf(getDiceQQ(),"DoListen",0)
	return "已关闭监听模式。\n目前应用监听模式变量的脚本有：\n兔兔病栋签到.lua\n兔兔病栋礼物.lua\n兔兔病栋留言.lua"
end
msg_order["关闭监听模式"]="NoListen"

function SeeListen(msg)
	if msg.fromQQ~="1142145792" then return "" end
	return "当前监听模式状态为：" .. quzheng(getUserConf(getDiceQQ(),"DoListen",0)) .. "。\n目前应用监听模式变量的脚本有：\n兔兔病栋签到.lua\n兔兔病栋礼物.lua\n兔兔病栋留言.lua"
end
msg_order["查询监听模式"]="SeeListen"
msg_order["查看监听模式"]="SeeListen"

function DoRecord(msg)
	if msg.fromQQ~="1142145792" then return "" end
	setUserConf(getDiceQQ(),"DoRecord",1)
	return "已开启记录模式。\n使用.reply show (.*)查看目前应用记录模式的群聊！"
end
msg_order["开启记录模式"]="DoRecord"

function NoRecord(msg)
	if msg.fromQQ~="1142145792" then return "" end
	setUserConf(getDiceQQ(),"DoRecord",0)
	return "已关闭记录模式。\n使用.reply show (.*)查看目前应用记录模式的群聊！"
end
msg_order["关闭记录模式"]="NoRecord"

function SeeRecord(msg)
	if msg.fromQQ~="1142145792" then return "" end
	return "当前记录模式状态为：" .. quzheng(getUserConf(getDiceQQ(),"DoRecord",0)) .. "。\n使用.reply show (.*)查看目前应用记录模式的群聊！"
end
msg_order["查询记录模式"]="SeeRecord"
msg_order["查看记录模式"]="SeeRecord"

function DoRepeat(msg)
	if msg.fromQQ~="1142145792" then return "" end
	setUserConf(getDiceQQ(),"DoRepeat",1)
	return "已开启复读模式。\n使用.reply show (.*)查看目前应用复读模式的群聊！"
end
msg_order["开启复读模式"]="DoRepeat"

function NoRepeat(msg)
	if msg.fromQQ~="1142145792" then return "" end
	setUserConf(getDiceQQ(),"DoRepeat",0)
	return "已关闭复读模式。\n使用.reply show (.*)查看目前应用复读模式的群聊！"
end
msg_order["关闭复读模式"]="NoRepeat"

function SeeRepeat(msg)
	if msg.fromQQ~="1142145792" then return "" end
	return "当前复读模式状态为：" .. quzheng(getUserConf(getDiceQQ(),"DoRepeat",0)) .. "。\n使用.reply show (.*)查看目前应用复读模式的群聊！"
end
msg_order["查询复读模式"]="SeeRepeat"
msg_order["查看复读模式"]="SeeRepeat"