msg_order = {} 

require("aaa")

function quzheng(num)
  if(num==nil)then
      return ""
  end
  return string.format("%.0f",num)
end

function touxiang(msg)
  local touxiang_qq=msg.fromQQ
  return "[CQ:image,url=http://q1.qlogo.cn/g?b=qq&nk="..quzheng(touxiang_qq).."&s=640]"
end

function tupian(msg)
	local rest = string.match(msg.fromMsg,"^[%s]*(.-)[%s]*$",#"获取图片"+1)
	if msg.fromMsg=="获取图片" then return "" end
	return "[CQ:image,url="..rest.."]"
end
msg_order["获取图片"]="tupian"

function wangzhan(msg)
	local rest = string.match(msg.fromMsg,"^[%s]*(.-)[%s]*$",#"获取网站"+1)
	if msg.fromMsg=="获取网站" then return "" end
	res, data = http.get(rest)
	path = getDiceDir().."\\plugin\\masterRecord\\website.html"
	if res ~= true then return "网页获取失败！错误："..tostring(res) end
	overwrite_file(path,data)
	return tostring(res).." - 已生成"
end
msg_order["获取网站"]="wangzhan"

function echoes(msg)
	local rest = string.match(msg.fromMsg,"^[%s]*(.-)[%s]*$",#".echo"+1)
	if msg.fromQQ~="1142145792" then return "" end
	return rest
end
msg_order[".echo"]="echoes"

function test(msg)
	return ""
end
msg_order["测试"] = "test"

function bpic(msg)
	msg = string.match(msg.fromMsg, "(.-)@")
	return "[CQ:image,url="..msg.."]"
end
msg_order["https://i0.hdslb.com/"] = "bpic"