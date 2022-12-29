-- 放一些经常用到的可以被直接调用的函数
-- 取整：quzheng(num) 传入数字，返回无小数点的数字
-- 1-5大成功，96-100大失败的判定：dice(num,succeed_rate) 传入随机后的数字与成功率，返回掷骰结果
-- 字符串分割：Split(szFullString, szSeparator) 传入完整字符和分割标识符，返回分割后的table
-- 抽取table值：table_draw(tab) 传入table值，返回table中的随机一个值
-- URI编码：encodeURI(s)，返回编码后的内容，其中空格为"+"
-- 无空格的URI编码：encodeURI_spaceless(s) 返回编码后的内容，其中空格为""
-- 读文件：read_file(path)
-- 写文件：write_file(path,text)
-- 覆写文件：overwrite_file(path,text)
-- 杜绝乱码的获取NN：getNN(group, QQ)

msg_order = {}

-- 取整，但返回string，如果需要数字请使用tonumber()函数
function quzheng(num)
  if(num==nil)then
      return ""
  end
  return string.format("%.0f",num)
end


-- 通用成功率判定模板
function dice(num,succeed_rate)
  if (num<=succeed_rate) then
    if (num<=5) then
	  return "大成功"
	elseif (num<=succeed_rate/5) then
	  return "极难成功"
	elseif (num<=succeed_rate/2) then
	  return "困难成功"
	else
	  return "成功"
	end
  elseif (num>=96) then
    return "大失败"
  else
    return "失败"
  end
end


-- 随便从哪找来的字符串分割函数，来源： https://www.cnblogs.com/AaronBlogs/p/7615877.html 
function Split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
	   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
	   if not nFindLastIndex then
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
		break
	   end
	   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
	   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
	   nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end


-- 实用的脚本-随机抽取table类型数据
function table_draw(tab)
    return tab[ranint(1,#tab)]
end


function encodeURI(s) --对传入参数编码进行通常的URL编码
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end


function encodeURI_spaceless(s) --对传入参数编码进行URL编码，空格返回空值的版本
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "")
end

-- 用于读文件
function read_file(path)
    local text = ""
    local file = io.open(path, "r") -- 打开了文件读写路径
    if (file ~= nil) then -- 如果文件不是空的
        text = file.read(file, "*a") -- 读取内容
        io.close(file) -- 关闭文件
    end 
    return text
end

-- 用于写文件
function write_file(path, text)
	file = io.open(path, "a") -- 以追加的方式
    file.write(file, text) -- 写入内容
    io.close(file) -- 关闭文件
end

-- 用于覆写文件
function overwrite_file(path, text)
	file = io.open(path, "w") -- 以只写的方式，会将原内容清空后写
	file.write(file, text)
	io.close(file)
end

function getNick(group, QQ)
	nick = "{nick}"
	return nick
end
msg_order["607F74DA8E2F782504D9E7013B288E7B"] = "getNick"

function getNN(group, QQ)
	nick = eventMsg("607F74DA8E2F782504D9E7013B288E7B", group, QQ)
	return nick
end

function getMaster()
    local f = assert(io.open(getDiceDir().."/conf/Console.xml","r"))
    local content = f.read("a")
    f.close()
    local master = string.match(content,"<master>(%d+)</master>")
    return master
end