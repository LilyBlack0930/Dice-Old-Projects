-- 写这个脚本的初衷是惠骰自定义回复有对特定用户的特定回复而这里没有相关样例
-- 制作by 兔兔

loadLua("aaa")

msg_order = {}

function bite_koaku(msg)
  local a = msg.fromQQ
  if (a=="1341239612") then
  return "{pc}抓起自己的翅膀痛下狠嘴：D100=--/-- 自动成功， 并且由于红色药丸的效果额外造成1点伤害！\nHP-2，你为什么要这么做？"
  else
  eventMsg(".draw啃小恶魔", msg.fromGroup, msg.fromQQ)
  return ""
  end
end
msg_order["#啃小恶魔"] = "bite_koaku"

--电阿委牛子已迁移至【电阿委牛子.lua】

function touch_zuimeng(msg)
  local a = msg.fromQQ
  if(a=="1142145792")then
    return "兔兔院长你又在摸醉梦吼，休息一下好不啦——"
  end
  if(a=="1419001719")then
    local num = ranint(1, 10)+ranint(1, 10)+ranint(1, 10)+ranint(1, 10)+ranint(1, 10)+ranint(1, 10)+ranint(1, 10)+ranint(1, 10)+ranint(1, 10)+ranint(1, 10)
    return "醉梦摸了摸自己！\n转眼间"..quzheng(num).."小时过去了……"
  end
  if(a=="1341239612")then
    return "小恶魔不准摸鱼！"
  end
  if(a=="646319220")then
    local num = ranint(2,5)
    return "妈咪对醉梦进行了爱的抚摸！\n转眼间"..quzheng(num).."小时过去了！"
  end
  local num = ranint(1, 2)+ranint(1, 2)+ranint(1, 2)+ranint(1, 2)+ranint(1, 2)
  return "你摸了摸醉梦，触发时间魔法！\n等你回过神来，已经过去了"..quzheng(num).."小时……"
end
msg_order["#摸醉梦"] = "touch_zuimeng"
