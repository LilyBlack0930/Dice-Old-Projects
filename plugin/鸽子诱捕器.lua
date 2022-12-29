--[[
                                             跑团公示板(鸽子诱捕器) by 兔兔
 _|    _|                                _|  设置自动清理过期记录时钟：.admin clock+pigeon_clear=5:00或设置成任何你想的时间
 _|    _|    _|_|_|    _|_|_|    _|_|_|      按计划是可以再做一个数据共享，奈何能力不足，鸽了
 _|    _|  _|_|      _|    _|  _|    _|  _|  自定义内容蛮多的，有兴趣的可以改
 _|    _|      _|_|  _|    _|  _|    _|  _|  本质上就是一个组队系统，因此也可以用来做些别的
   _|_|    _|_|_|      _|_|_|    _|_|_|  _|  ……但是请不要将其用作非法用途
                                     _|      需要用到json.lua，在论坛里已经上传了
                                 _|_|        
]]
--+-+-+-+-+-+-+--以下为指令和参数配置项--+-+-+-+-+-+-+--
new_pigeon_order = "新建团"  -- 新建跑团公示，推荐团名格式：[规则]-[模组名]，指令及参数为：新建团 <团名>
edit_pigeon_order = "描述团"  -- 编辑跑团公示，指令及参数为：描述团 <团名> [描述]，无描述时会删除
del_pigeon_order = "删除团"  -- 删除跑团公示，指令及参数为：删除团 <团名>
join_pigeon_order = "加入团"  -- 加入已存在的团，指令及参数为：加入团 <团名>
leave_pigeon_order = "离开团"  -- 离开已加入的团，指令及参数为：离开团 <团名>
show_pigeon_order = "查看团"  -- 查看某个团的具体信息，指令及参数为：查看团 <团名>
list_pigeon_order = "查看所有团"  -- 列出全部跑团公示，无参数
remove_pigeon_order = "移出成员"  -- 将某成员移出自己开的团，指令及参数为：移出成员 <团名> <对方QQ号>
order_list_order = "跑团公示"  -- 查看以上所有指令名和指令用途
clear_time_limit = 2592000  -- 需要配合定时任务使用。跑团公示超过了这个时间会被清理，单位是秒，默认是30天（2592000秒）

--+-+-+-+-+-+-+--以下为回复句配置项--+-+-+-+-+-+-+--
--[[
    这里是自定义转义符说明，用法与骰娘回复的{nick}、{self}等相同，但只能用在这里的回复句配置项中
    并非所有语句中的转义符都可以成功生效，会在语句末尾声明可生效的转义符。考虑到可能会有人想做一些炫酷的功能，将转义符设置得尽可能的多了
    另外，严格来说，这不能算作转义符，只是为了方便而这么叫，其实就是一堆gsub堆起来的
    {pTitle}：团的名称，包括编号
    {pGMQQ}：团主的QQ
    {pGMName}：团主的用户名
    {pObjQQ}：PL或操作对象的QQ
    {pObjName}：PL或操作对象的用户名
	{pInfo}：团的描述
	{pTime}：团的创建时间
]]
pigeon_title_not_found = "找不到你所说的团[{pTitle}]！请确认名字是否输入正确！"  -- 没有输入标题对应的跑团公示，可生效转义符为{pTitle}
pigeon_picture_not_supported = "考虑到被风控的风险，跑团公示不支持插入图片哦~"  -- 如果标题或描述有图片的提示
pigeon_new_title_nil = "{nick}你的团名呢？"  -- 新建团时没有输入团名
pigeon_edit_title_nil = "{nick}你想编辑哪个团的信息呀？"  -- 编辑团时没有输入团名或团名格式输入错误
pigeon_del_title_nil = "{nick}你想删除哪个团呀？"  -- 删除团时没有输入团名
pigeon_join_title_nil = "{nick}你想加入哪个团呀？"  -- 加入团时没有输入团名
pigeon_show_title_nil = "{nick}你想查看哪个团呀？"  -- 查看团时没有输入团名
pigeon_remove_title_nil = "{nick}你想从哪个团里移出成员呀？"  -- 移出成员时没有输入团名或团名格式输入错误
pigeon_new_title_too_long = "团名过长！"  -- 新建团时名字过长
pigeon_new_create_successful = "已新建跑团公示：\n名称：{pTitle}\n创建时间：{pTime}\nGM：{pGMName}({pGMQQ})"  -- 成功新建了团，可生效转义符为{pTitle}{pGMQQ}{pGMName}{pTime}
pigeon_info_del = "已删除团[{pTitle}]的描述！"  -- 删除了团的描述，可生效转义符为{pTitle}{pGMQQ}{pGMName}{pTime}
pigeon_info_edit = "已将团[{pTitle}]的描述更新为：\n{pInfo}"  -- 修改了团的描述，可生效转义符为{pTitle}{pInfo}{pGMQQ}{pGMName}{pTime}
pigeon_not_gm = "{nick}，你不是这个团的GM，不能进行这个操作！"  -- 非团主进行了删除/描述/踢人的操作，可生效转义符为{pTitle}{pGMQQ}{pGMName}
pigeon_del_successful = "已将团[{pTitle}]移除！"  -- 成功删除了团，可生效转义符为{pTitle}
pigeon_join_gm = "{nick}，你是这个团的GM，不可重复加入团内！"  -- 作为GM加入了自己开的团
pigeon_join_already = "{nick}你已经在这个团里了！"  -- 重复加入一个团，可生效转义符为{pTitle}{pGMQQ}{pGMName}
pigeon_join_successful = "团[{pTitle}]新增成员：{pObjName}({pObjQQ})"  -- 有pl成功加入了某个团，可生效转义符为{pTitle}{pGMQQ}{pGMName}{pObjQQ}{pObjName}{pInfo}{pTime}
pigeon_leave_gm = "{nick}，你是这个团的GM！若想离开团，请使用[/删除团]来将整个团删除！"  -- 作为GM离开自己开的团
pigeon_leave_successful = "{nick}离开了[{pTitle}]……"  -- 成功离开了团，可生效转义符为{pTitle}{pGMQQ}{pGMName}{pObjQQ}{pObjName}{pInfo}{pTime}
pigeon_not_inlist = "{nick}，你不在这个团里！"  -- 本就不在团里的人离开了团，可生效转义符为{pTitle}{pGMQQ}{pGMName}
pigeon_list_msg = "当前{self}持有的团公示有："  -- 查看全部跑团公示时的开头语句
pigeon_list_empty = "{self}未持有任何团公示！"  -- 查看跑团公示时无任何公示的语句
pigeon_remove_qq_nil = "{nick}你想移出哪位成员呀？"  -- 移出成员时没有输入QQ号
pigeon_remove_gm = "{nick}你不可以将自己从团内踢出！"  -- 作为GM从团内移出了自己
pigeon_remove_successful = "成功移出{pObjName}({pObjQQ})！"  -- 成功将用户移出自己的团，可生效转义符为{pTitle}{pGMQQ}{pGMName}{pObjQQ}{pObjName}
pigeon_remove_not_inlist = "{pObjName}({pObjQQ})已不在团内！"  -- 试图移出本就不在团内的人，可生效转义符为{pTitle}{pObjQQ}{pObjName}
--+-+-+-+-+-+-+--以上为全部配置内容--+-+-+-+-+-+-+--

msg_order = {}
pigeon_path = getDiceDir().."\\plugin\\PigeonCatcher\\"
pigeon_name = "PigeonList.json"
pigeon_full_path = pigeon_path..pigeon_name
title_max_length = 150  -- 团名的字数上限（对于字数上限，中文字符一个会被算作3个，因此设为预想长度的三倍）
info_max_length = 1000  -- 团描述的字数上限

-- 文件预检，如果没有文件或文件夹会进行创建
file, err = io.open(pigeon_full_path,"r")
if err then mkDirs(pigeon_path) end
if file then
    io.close(file)
else
    file = io.open(pigeon_full_path,"w")
    file.write(file, "{}")
    io.close(file)
end

function read_file(path)
    local text = ""
    local file = io.open(path, "r")
    if (file ~= nil) then
        text = file.read(file, "*a")
        io.close(file)
    end 
    return text
end
function overwrite_file(path, text)
	file = io.open(path, "w")
	file.write(file, text)
	io.close(file)
end

function new_pigeon(msg)  -- 开新团
    local text = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#new_pigeon_order+1)
    if text=="" then return pigeon_new_title_nil end
    if #text > title_max_length then return pigeon_new_title_too_long end
    if string.match(text,"%[CQ:image,") then return pigeon_picture_not_supported end
    text = string.gsub(text,"%[CQ:(.-)%]","")  -- 防止团名为艾特某人、艾特全体等奇怪的现象发生
    title = text..string.format("#%04d",ranint(1,9999))  -- 添加四位随机数字保证团名基本不会重复
    local gm_QQ = msg.fromQQ
    local gm_name = getUserConf(msg.fromQQ,"name","")
    json =  require("json")
    local pigeon_list = read_file(pigeon_full_path)
    if #pigeon_list==0 then j = {} else j = json.decode(pigeon_list) end
    while j[title] do
        title = text..string.format("#%04d",ranint(1,9999))  -- 要真重复了还可以重新roll
    end
    j[title] = {}
    j[title]["gm_QQ"] = gm_QQ
    j[title]["gm_name"] = gm_name
    j[title]["create_time"] = os.time()
    pigeon_newlist = json.encode(j)
    overwrite_file(pigeon_full_path,pigeon_newlist)
    res = pigeon_new_create_successful:gsub("{pTitle}",title):gsub("{pGMQQ}",gm_QQ):gsub("{pGMName}",gm_name):gsub("{pTime}",os.date("%Y-%m-%d %H:%M:%S", j[title]["create_time"]))
    return res
end
msg_order[new_pigeon_order] = "new_pigeon"

function edit_pigeon(msg)  -- 给团公示增加描述（仅限团主）
    local title, info =string.match(msg.fromMsg,"[%s]*(.-#%d%d%d%d)[%s]*(.-)[%s]*$",#edit_pigeon_order+1)
    if not title then return pigeon_edit_title_nil end
	if not info then info = "" end
    info = string.gsub(info,"%[CQ:at,(.-)%]","")
    if string.match(info,"%[CQ:image,") then return pigeon_picture_not_supported end
    json =  require("json")
    local pigeon_list = read_file(pigeon_full_path)
    if #pigeon_list==0 then j = {} else j = json.decode(pigeon_list) end
    if not j[title] then
        res = pigeon_title_not_found:gsub("{pTitle}",title)
        return res
    end
    if j[title]["gm_QQ"]~=msg.fromQQ then
        res = pigeon_not_gm:gsub("{pTitle}",title):gsub("{pGMQQ}",j[title]["gm_QQ"]):gsub("{pGMName}",j[title]["gm_name"])
        return res
    end
    if #info==0 then
        j[title]["info"]=nil
        ret = pigeon_info_del:gsub("{pTitle}",title):gsub("{pGMQQ}",j[title]["gm_QQ"]):gsub("{pGMName}",j[title]["gm_name"]):gsub("{pTime}",os.date("%Y-%m-%d %H:%M:%S", j[title]["create_time"]))
    else
        j[title]["info"] = info
        ret = pigeon_info_edit:gsub("{pTitle}",title):gsub("{pInfo}",info):gsub("{pGMQQ}",j[title]["gm_QQ"]):gsub("{pGMName}",j[title]["gm_name"]):gsub("{pTime}",os.date("%Y-%m-%d %H:%M:%S", j[title]["create_time"]))
    end
    pigeon_newlist = json.encode(j)
    overwrite_file(pigeon_full_path,pigeon_newlist)
    return ret
end
msg_order[edit_pigeon_order] = "edit_pigeon"

function del_pigeon(msg)  -- 删除团（仅限团主）
    local title = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#del_pigeon_order+1)
    if title=="" then return pigeon_join_title_nil end
    json =  require("json")
    local pigeon_list = read_file(pigeon_full_path)
    if #pigeon_list==0 then j = {} else j = json.decode(pigeon_list) end
    if not j[title] then
        res = pigeon_title_not_found:gsub("{pTitle}",title)
        return res
    end
    if j[title]["gm_QQ"]~=msg.fromQQ then
        res = pigeon_not_gm:gsub("{pTitle}",title):gsub("{pGMQQ}",j[title]["gm_QQ"]):gsub("{pGMName}",j[title]["gm_name"])
        return res
    end
    j[title] = nil
    pigeon_newlist = json.encode(j)
    overwrite_file(pigeon_full_path,pigeon_newlist)
    res = pigeon_del_successful:gsub("{pTitle}",title)
    return res
end
msg_order[del_pigeon_order] = "del_pigeon"

function join_pigeon(msg)  -- 加入团
    local title = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#del_pigeon_order+1)
    if title=="" then return pigeon_join_title_nil end
    local pl_QQ = msg.fromQQ
    local pl_name = getUserConf(msg.fromQQ,"name","")
    json =  require("json")
    local pigeon_list = read_file(pigeon_full_path)
    if #pigeon_list==0 then j = {} else j = json.decode(pigeon_list) end
    if not j[title] then
        res = pigeon_title_not_found:gsub("{pTitle}",title)
        return res
    end
    if j[title]["gm_QQ"]==pl_QQ then return pigeon_join_gm end
    if j[title]["pl"] then
        for i=1, #j[title]["pl"] do
            if j[title]["pl"][i]["QQ"]==pl_QQ then
                res = pigeon_join_already:gsub("{pTitle}",title):gsub("{pGMQQ}",j[title]["gm_QQ"]):gsub("{pGMName}",j[title]["gm_name"])
                return res
            end
        end
    else
        j[title]["pl"] = {}
    end
    num = #j[title]["pl"]+1
    j[title]["pl"][num] = {}
    j[title]["pl"][num]["QQ"] = pl_QQ
    j[title]["pl"][num]["name"] = pl_name
    pigeon_newlist = json.encode(j)
    overwrite_file(pigeon_full_path,pigeon_newlist)
    if not j[title]["info"] then info="" else info=j[title]["info"] end
    res = pigeon_join_successful:gsub("{pTitle}",title):gsub("{pGMQQ}",j[title]["gm_QQ"]):gsub("{pGMName}",j[title]["gm_name"]):gsub("{pObjQQ}",pl_QQ):gsub("{pObjName}",pl_name):gsub("{pInfo}",info):gsub("{pTime}",os.date("%Y-%m-%d %H:%M:%S", j[title]["create_time"]))
    return res
end
msg_order[join_pigeon_order] = "join_pigeon"

function leave_pigeon(msg)  -- 离开团
    local title = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#del_pigeon_order+1)
    if title=="" then return pigeon_join_title_nil end
    local pl_QQ = msg.fromQQ
    json =  require("json")
    local pigeon_list = read_file(pigeon_full_path)
    if #pigeon_list==0 then j = {} else j = json.decode(pigeon_list) end
    if not j[title] then
        res = pigeon_title_not_found:gsub("{pTitle}",title)
        return res
    end
    if j[title]["gm_QQ"]==pl_QQ then return pigeon_leave_gm end
    if j[title]["pl"] then
        for i=1, #j[title]["pl"] do
            if j[title]["pl"][i]["QQ"]==pl_QQ then
                j[title]["pl"][i]=nil
                pigeon_newlist = json.encode(j)
                overwrite_file(pigeon_full_path,pigeon_newlist)
                if not j[title]["info"] then j[title]["info"]="" end
                res = pigeon_leave_successful:gsub("{pTitle}",title):gsub("{pGMQQ}",j[title]["gm_QQ"]):gsub("{pGMName}",j[title]["gm_name"]):gsub("{pObjQQ}",pl_QQ):gsub("{pObjName}",getUserConf(msg.fromQQ,"name","")):gsub("{pInfo}",j[title]["info"]):gsub("{pTime}",os.date("%Y-%m-%d %H:%M:%S", j[title]["create_time"]))
                return res
            end
        end
        res = pigeon_not_inlist:gsub("{pTitle}",title):gsub("{pGMQQ}",j[title]["gm_QQ"]):gsub("{pGMName}",j[title]["gm_name"])
        return res
    else
        res = pigeon_not_inlist:gsub("{pTitle}",title):gsub("{pGMQQ}",j[title]["gm_QQ"]):gsub("{pGMName}",j[title]["gm_name"])
        return res
    end
end
msg_order[leave_pigeon_order] = "leave_pigeon"

function show_pigeon(msg)  -- 查看一个团的具体内容
    local title = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#del_pigeon_order+1)
    if title=="" then return pigeon_show_title_nil end
    json =  require("json")
    local pigeon_list = read_file(pigeon_full_path)
    if #pigeon_list==0 then j = {} else j = json.decode(pigeon_list) end
    if not j[title] then
        res = pigeon_title_not_found:gsub("{pTitle}",title)
        return res
    end
    ret = "["..title.."]\n创建时间："..os.date("%Y-%m-%d %H:%M:%S",j[title]["create_time"]).."\nGM："..j[title]["gm_name"].."("..j[title]["gm_QQ"]..")"
    if j[title]["pl"] then
        if j[title]["pl"][1] then
            for i=1, #j[title]["pl"] do
                ret = ret.."\nPL"..i.."："..j[title]["pl"][i]["name"].."("..j[title]["pl"][i]["QQ"]..")"
            end
        else
            ret = ret.."\nPL：暂无"
        end
    else
        ret = ret.."\nPL：暂无"
    end
    if j[title]["info"] then ret = ret.."\n描述："..j[title]["info"] end
    return ret
end
msg_order[show_pigeon_order] = "show_pigeon"

function list_pigeon(msg)  -- 查看团列表
    ret = pigeon_list_msg
    i = 1
    json =  require("json")
    local pigeon_list = read_file(pigeon_full_path)
    if #pigeon_list<=2 then return pigeon_list_empty end
    j = json.decode(pigeon_list)
    for k, v in pairs(j) do
        ret = ret.."\n"..i.."："..k.." [GM:"..j[k]["gm_name"].."("..j[k]["gm_QQ"]..")]"
        if i%20==0 then ret=ret.."\f" end
        i = i + 1
    end
    return ret
end
msg_order[list_pigeon_order] = "list_pigeon"

function remove_pigeon(msg)  -- GM移除成员
    local title, pl_QQ =string.match(msg.fromMsg,"[%s]*(.-#%d%d%d%d).-(%d+).*",#remove_pigeon_order+1)
    if not title then return pigeon_remove_title_nil end
    if not pl_QQ then return pigeon_remove_qq_nil end
    json =  require("json")
    local pigeon_list = read_file(pigeon_full_path)
    if #pigeon_list==0 then j = {} else j = json.decode(pigeon_list) end
    if not j[title] then
        res = pigeon_title_not_found:gsub("{pTitle}",title)
        return res
    end
    if j[title]["gm_QQ"]~=msg.fromQQ then
        res = pigeon_not_gm:gsub("{pTitle}",title):gsub("{pGMQQ}",j[title]["gm_QQ"]):gsub("{pGMName}",j[title]["gm_name"])
        return res
    end
    if j[title]["gm_QQ"]==pl_QQ then return pigeon_remove_gm end
    if j[title]["pl"] then
        for i=1, #j[title]["pl"] do
            if j[title]["pl"][i]["QQ"]==pl_QQ then
                j[title]["pl"][i]=nil
                pigeon_newlist = json.encode(j)
                overwrite_file(pigeon_full_path,pigeon_newlist)
                res = pigeon_remove_successful:gsub("{pTitle}",title):gsub("{pGMQQ}",j[title]["gm_QQ"]):gsub("{pGMName}",j[title]["gm_name"]):gsub("{pObjQQ}",pl_QQ):gsub("{pObjName}",getUserConf(pl_QQ,"name",""))
                return res
            end
        end
        res = pigeon_remove_not_inlist:gsub("{pTitle}",title):gsub("{pObjQQ}",pl_QQ):gsub("{pObjName}",getUserConf(pl_QQ,"name",""))
        return res
    else
        res = pigeon_remove_not_inlist:gsub("{pTitle}",title):gsub("{pObjQQ}",pl_QQ):gsub("{pObjName}",getUserConf(pl_QQ,"name",""))
        return res
    end
end
msg_order[remove_pigeon_order] = "remove_pigeon"

function order_list(msg)
    return "[跑团公示/鸽子诱捕器]\n指令列表\n"..new_pigeon_order.." -新建跑团公示\n"..edit_pigeon_order.." -编辑跑团公示详细信息\n"..del_pigeon_order.." -删除跑团公示\n"..join_pigeon_order.." -加入团\n"..leave_pigeon_order.." -离开团\n"..show_pigeon_order.." -查看指定团\n"..list_pigeon_order.." -查看所有团\n"..remove_pigeon_order.." -从团中移出指定成员\n"..order_list_order.." -查看此条信息"
end
msg_order[order_list_order] = "order_list"

task_call = {}
task_name = "pigeon_clear"
function pigeonclear()
    i = 0
    json =  require("json")
    local pigeon_list = read_file(pigeon_full_path)
    if #pigeon_list==0 then j = {} else j = json.decode(pigeon_list) end
    now_time = os.time()
    for k, v in pairs(j) do
        create_time = j[k]["create_time"]
        if now_time-create_time>clear_time_limit then
            j[k]=nil
            i = i + 1
        end
    end
    pigeon_newlist = json.encode(j)
    overwrite_file(pigeon_full_path,pigeon_newlist)
    if i>=1 then eventMsg(".send notice 0 [鸽子诱捕器]:已清理过期跑团公示"..tostring(i).."条",0,getDiceQQ()) end
end
task_call[task_name] = "pigeonclear"
