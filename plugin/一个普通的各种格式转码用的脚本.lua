--[[
指令列表：
转换成Unicode
转换成十进制Unicode
十六进制转十进制（只支持单个转换）
十进制转十六进制（只支持单个转换，下同）
十进制转二进制
二进制转十进制
二进制转十六进制
十六进制转二进制
\u（unicode转UTF8字符，数量不限）
]]

msg_order = {}
function str2hex(str)
    local ret = ""
    for p, c in utf8.codes(str) do
        local charHexStr = string.sub(string.format("%#x", c), 3, -1)
		charHexStr = "\\u" .. charHexStr
        ret = ret .. charHexStr
    end
    return ret
end

function str2Unicode(msg)
	local raw = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#str2Unicode_order+1)
	return str2hex(raw)
end
str2Unicode_order = "转换成Unicode"
msg_order[str2Unicode_order]="str2Unicode"

function str2dec(str)
    local ret = ""
    for p, c in utf8.codes(str) do
        local charHexStr = c
		charHexStr = " " .. charHexStr
        ret = ret .. charHexStr
    end
    return ret
end

function str2DecUnicode(msg)
	local raw = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#str2DecUnicode_order+1)
	return str2dec(raw)
end
str2DecUnicode_order = "转换成十进制Unicode"
msg_order[str2DecUnicode_order]="str2DecUnicode"

function H2D(msg)
	local raw = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#H2D_order+1)
	ret = "0x"..raw
	return tonumber(ret)
end
H2D_order = "十六进制转十进制"
msg_order[H2D_order]="H2D"

function D2H(msg)
	local raw = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#D2H_order+1)
	ret = string.format("%X",raw)
	return ret
end
D2H_order = "十进制转十六进制"
msg_order[D2H_order]="D2H"

function D2B(msg)
	local raw = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#D2B_order+1)
	local a = raw
	local b = 0
	local t = {}
	while true do
		a = a / 2
		b = b + 1
		if a<2 then
			break
		end
	end
	for i=b,0,-1 do
		t[#t+1] = math.floor(raw/2^i)
		raw = raw % 2^i
	end
	return table.concat(t)
end
D2B_order = "十进制转二进制"
msg_order[D2B_order]="D2B"

function B2D(msg)
	local raw = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#B2D_order+1)
	ret = tonumber(raw,2)
	return ret
end
B2D_order = "二进制转十进制"
msg_order[B2D_order]="B2D"

function B2H(msg)
	local B = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#B2H_order+1)
	local D = tonumber(B,2)
	local H = string.format("%X",D)
	return H
end
B2H_order = "二进制转十六进制"
msg_order[B2H_order]="B2H"

function H2B(msg)
	local H = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#H2B_order+1)
	local D = tonumber("0x"..H)
	local raw = D
	local a = raw
	local b = 0
	local t = {}
	while true do
		a = a / 2
		b = b + 1
		if a<2 then
			break
		end
	end
	for i=b,0,-1 do
		t[#t+1] = math.floor(raw/2^i)
		raw = raw % 2^i
	end
	return table.concat(t)
end
H2B_order = "十六进制转二进制"
msg_order[H2B_order]="H2B"

function U2S(msg)
	local item = ""
	local text = string.gsub(string.gsub(msg.fromMsg,"\\u","|0x"),"|","",1)
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
U2S_order = "\\u"
msg_order[U2S_order] = "U2S"