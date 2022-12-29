msg_order = {}
function gugugu(msg)
	res = ""
	gugugu_res,gugugu_data = http.get("http://www.koboldgame.com/gezi/api.php")
	res = string.sub(gugugu_data, 17 , -4)
	return res
end
-- msg_order["咕咕语录"] = "gugugu"
-- msg_order["鸽子语录"] = "gugugu"