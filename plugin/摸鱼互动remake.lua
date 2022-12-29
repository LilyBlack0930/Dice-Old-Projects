msg_order = {}

function quzheng(num)
  if(num==nil)then
      return ""
  end
  return string.format("%.0f",num)
end

--摸鱼后增长1摸鱼次数
--可以查看摸鱼次数
--可以放生鱼鱼

function fish_fish(msg)
	local fish_today = getUserToday(msg.fromQQ,"今日摸鱼",0) --判定今日次数
	if fish_today >= 3 then --判定次数上限
		return "摸鱼也要有个限度啊{nick}！"
	end
	fish_today = fish_today + 1
	setUserToday(msg.fromQQ,"今日摸鱼",fish_today) --当日次数增加
	setUserConf(msg.fromQQ,"摸鱼次数",getUserConf(msg.fromQQ,"摸鱼次数",0)+1) --累计次数增加
	local DiceQQ = getDiceQQ()
	setUserToday(DiceQQ,"今日摸鱼",getUserToday(DiceQQ,"今日摸鱼",0)+1) --当日总次数增加
	local self_total_fish = getUserConf(DiceQQ,"摸鱼总次数",0)
	setUserConf(DiceQQ,"摸鱼总次数",getUserConf(DiceQQ,"摸鱼总次数",0)+1) --累计总次数增加
	return "你抽出一条大鱼，用娴熟的手法抚摸起来。\n今日已摸"..quzheng(getUserToday(DiceQQ,"今日摸鱼",0)).."条\n累计摸鱼"..quzheng(getUserConf(DiceQQ,"摸鱼总次数",0)).."条"
end
msg_order["我要摸鱼！"] = "fish_fish"
msg_order["我要摸鱼!"] = "fish_fish"

function fish_release(msg)
	if getUserConf(msg.fromQQ,"摸鱼次数",0)==0 then
		return "{nick}你已经没有鱼可以放生了！"
	end
	setUserConf(msg.fromQQ,"摸鱼次数",getUserConf(msg.fromQQ,"摸鱼次数",0)-1)
	return "你将一条鱼放回了鱼塘，它很感激你并用尾巴抽了你一大嘴巴子"
end
msg_order["放生鱼鱼"] = "fish_release"

function fish_pond(msg)
	local fish = getUserConf(msg.fromQQ,"摸鱼次数",0)
	if(fish==0)then
		return "什么嘛，{nick}的鱼塘里这不是完全没有鱼嘛"
	elseif(fish<30)then
    	return "{nick}已经摸了"..quzheng(fish).."条鱼，要加油哦"
    elseif(fish<90)then
    	return "{nick}已经摸了"..quzheng(fish).."条鱼，稍具规模了呢"
    elseif(fish<180)then
    	return "{nick}，你已经摸了"..quzheng(fish).."条了，你是波塞冬吗？"
    else
    	return "{nick}，我不知你抱着何种心态……总之你已经摸了"..quzheng(fish).."条鱼了，永无止境的摸鱼啊……"
    end
end
msg_order["查看鱼塘"] = "fish_pond"