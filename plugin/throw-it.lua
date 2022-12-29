msg_order = {}
function throw(msg)
	raw = string.match(msg.fromMsg,"^[%s]*(.-)[%s]*$",#throw_order+1)
	qq = string.match(raw,"%d+")
	if raw == "自己" then qq = msg.fromQQ end
	if not qq then return "" end
	return "[CQ:image,url=http://api.weijieyue.cn/api/tupian/diu.php?qq="..qq.."]"
end
throw_order = "丢"
msg_order[throw_order]="throw"