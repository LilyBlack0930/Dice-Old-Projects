-- 已弃置的项目

--[[
                                             鸽笼HTTP版 脚本by 兔兔
 _|    _|                                _|  这次是云数据！感谢后端大佬1787569211、3032902237，接口优化、API访问问题找他们！
 _|    _|    _|_|_|    _|_|_|    _|_|_|      仍然需要用到json.lua，会上传一份
 _|    _|  _|_|      _|    _|  _|    _|  _|  
 _|    _|      _|_|  _|    _|  _|    _|  _|  
   _|_|    _|_|_|      _|_|_|    _|_|_|  _|  
                                     _|      
                                 _|_|        
]]
--+-+-+-+-+-+-+--以下为指令和参数配置项--+-+-+-+-+-+-+--
arcReg_order = "鸽笼注册"  -- 务必先注册再使用，指令后跟密码
arcGet_order = "鸽笼找回"  -- 以防不记得key了，可以用密码找回
arcSearch_order = "鸽笼搜索"  -- 搜索
arcSearchID_order = "鸽笼查看"  -- 按ID搜索，可以一次输入多个ID，空格分隔
arcSearchMe_order = "我的鸽笼"  -- 以自己的QQ为关键词搜索
arcSearchAll_order = "所有鸽笼"  -- 搜索目前在库的所有团，可能会导致发送过多消息，请自行斟酌
arcAdd_order = "鸽笼添加"  -- 添加一个鸽笼，如果格式不对的话会提供正确格式以供手动填充
arcUpdate_order = "鸽笼修改"  -- 修改
arcDel_order = "鸽笼删除"  -- 删除自己开的团
arcVersion_order = "鸽笼版本"  -- 查询当前脚本版本与服务端版本

--+-+-+-+-+-+-+--以下为回复句配置项--+-+-+-+-+-+-+--
-- \n是换行，\f是换页(将句子从这个位置拆开，拆成多段发送)，可以在需要的地方插入
-- 照样有各种类似{self}的特殊文本以供更好地自定义回复句，只要按要求改就不会有大问题的

-- 搜索团时未能检测到正确格式的参数。后面固定接上指令和正确格式
search_parameter_missing = "没有参数或参数未能正确填写，搜索失败！请按下方格式填写并重新发送(所有参数均为选填，可删除对应行)："

-- 使用搜索时输入了主持人QQ。会出现在搜索成功时语句的前面
search_by_kpqq = "检测到主持人QQ！开始按主持人QQ查找，将会忽略剩余参数……\f"

-- 搜索成功，但没找到指定关键词对应的任何团。
search_zero_object = "搜索成功！\n但一个团都没有找到！"

-- 搜索成功，且存在团。自己做好换行，此处{order}会被转为变量arcSearchID_order的值，即按ID搜索的指令
search_list_head = "搜索成功！\n可发送“{order}”+ID，以查看对应团的详细信息！"

-- 搜索失败。此处{ERR}会被转为API返回的错误信息
search_failed = "搜索失败：{ERR}"


-- 按ID查找成功
searchID_succeed = "正在按ID查找……\f搜索成功！"

-- 按ID查找时没有找到对应团。此处{ID}会被转为查找时输入的ID
searchID_zero_object = "正在按ID查找……\f搜索成功！\n但ID{ID}对应的团不存在或已被删除！"

-- 按ID查找失败。此处{ERR}对应API返回的错误信息
searchID_failed = "正在按ID查找……\f搜索失败：{ERR}"

-- 按自己搜索成功，后面固定跟上团列表
searchMe_succeed = "让我看看，{nick}都开了些什么团……\f搜索成功！\n"

-- 按自己搜索，但一个团都没找到
searchMe_zero_object = "让我看看，{nick}都开了些什么团……\f搜索成功！\n但{nick}好像一个团都没有，该不会全鸽了吧？！"

-- 搜索自己的团失败。此处{ERR}会被转为API返回的错误信息
searchMe_failed = "让我看看，{nick}都开了些什么团……\f搜索自己的团失败：{ERR}"


-- 查看全部团成功
searchAll_succeed = "收到{nick}的指令，即将列出全部鸽笼……\f搜索成功！"

-- 查看全部团成功，但数据库里竟然一个团都没有
searchAll_zero_object = "收到{nick}的指令，即将列出全部鸽笼……\f搜索成功！\n但是鸽笼里一只鸽子都没有，怎么会这样！"

-- 搜索全部团失败。此处{ERR}会被转为API返回的错误信息
searchAll_failed = "收到{nick}的指令，即将列出全部鸽笼……\f搜索失败：{ERR}"


-- 添加团时出现参数缺失。后面固定接上指令和正确格式
add_parameter_missing = "缺失了部分参数或有参数存在错误！请按下方格式重新填写并发送指令："

-- 添加团成功。此处{ID}会被转为添加成功后该团在库内对应的ID
add_succeed = "添加成功！你的团ID是：{ID}\n自己开的团要好好跑完哦"

-- 添加团失败。此处{ERR}会被转为API返回的错误信息
add_failed = "添加失败：{ERR}"

-- 修改团时缺少ID导致无法修改，后面固定接上指令和正确格式
update_id_missing = "缺少待修改团的ID，无法进行修改！请按下方格式重新填写并发送指令(除ID外均为选填，可删除对应行)："

-- 修改团内容成功。{old_data}为修改前完整数据，{new_data}为修改后完整数据，会自动进行转换
update_succeed = "修改成功！\n————\n原数据：\n{old_data}\n————\n修改后数据：\n{new_data}"

-- 修改团内容失败。此处{ERR}会被转为API返回的错误信息
update_failed = "修改失败：{ERR}"


-- 删除团时没有输入ID
delete_id_missing = "请输入待删除的团的ID！"

-- 删除团的开头语句
delete_header = "正在删除……"

-- 单个团删除成功，已经自动插入回车所以不用管了
delete_succeed = "ID{ID} 删除成功！"

-- 单个团删除失败
delete_failed = "ID{ID} 删除失败，该ID不存在或你不是该团主持人"

-- 删除团命令失败。此处{ERR}会被转为API返回的错误信息
delete_request_failed = "\n请求失败：{ERR}"


-- 检查版本指令，{version}为获取到的API版本
version_check_succeed = "版本检查成功！\n当前脚本对应API版本：0.0.1\n当前API实际版本：{version}"

-- 检查版本失败
version_check_failed = "版本检查失败！"

-- 以下四项不常用or不推荐更改，请酌情考虑
register_not_master = "你不是{self}的Master，不能进行注册！"
getkey_not_master = "你不是{self}的Master，不能进行KEY找回！"
API_access_failed = "API访问失败！请尝试联系站长解决此问题"
API_key_missing = "API KEY缺失！请联系Master尝试注册或找回！"
--+-+-+-+-+-+-+--以上为全部配置内容--+-+-+-+-+-+-+--

APIKEY_PATH = getDiceDir().."/plugin/PigeonHTTP/API_KEY.txt"
APIPWD_PATH = getDiceDir().."/plugin/PigeonHTTP/API_PWD.txt"
file, err = io.open(APIKEY_PATH,'r')
if err then mkDirs(getDiceDir().."/plugin/PigeonHTTP") end
if file then
    io.close(file)
else
    file = io.open(APIKEY_PATH,'w')
    file.write(file, "")
    io.close(file)
    file = io.open(APIPWD_PATH,'w')
    file.write(file, "")
    io.close(file)
end

msg_order = {}

msg_order[arcReg_order] = "arcReg"
msg_order[arcGet_order] = "arcGet"
msg_order[arcSearch_order] = "arcSearch"
msg_order[arcSearchID_order] = "arcSearchID"
msg_order[arcSearchMe_order] = "arcSearchMe"
msg_order[arcSearchAll_order] = "arcSearchAll"
msg_order[arcAdd_order] = "arcAdd"
msg_order[arcUpdate_order] = "arcUpdate"
msg_order[arcDel_order] = "arcDel"
msg_order[arcVersion_order] = "arcVersion"

function arcReg(msg)
    url = "http://网址:45445/register"
    jsondata = {}
    jsondata.qq = getDiceQQ()
    jsondata.password = string.match(msg.fromMsg, "[%s]*(.-)[%s]*$", #arcReg_order+1)
    if msg.fromQQ~=getMaster() then return register_not_master end
    if #jsondata.password==0 then return "请输入密码！" end
    json = require("json")
    res, data = http.post(url, json.encode(jsondata))
    if not res then return API_access_failed end
    j = json.decode(data)
    if j.succ then
        file = io.open(APIKEY_PATH, "w")
        file.write(file, j.data)
        io.close(file)
        file = io.open(APIPWD_PATH, "w")
        file.write(file, jsondata.password)
        io.close(file)
        ret = "注册成功！你的API KEY为："..j.data.."\nAPIKEY和密码均已自动录入骰娘本地文件中，可在 " .. getDiceDir() .. "\\plugin\\PigeonHTTP 文件夹中查看\n请手动保存密码以防万一！"
    else
        ret = "注册失败："..j.err_msg
    end
    return ret
end

function arcGet(msg)
    qq = getDiceQQ()
    password = string.match(msg.fromMsg, "[%s]*(.-)[%s]*$", #arcGet_order+1)
    if msg.fromQQ~=getMaster() then return getkey_not_master end
    if #password==0 then return "请输入密码！" end
    res, data = http.get("http://网址:45445/searchKey?qq="..qq.."&password="..password)
    if not res then return API_access_failed end
    json = require("json")
    j = json.decode(data)
    if j.succ then
        overwrite_file(APIKEY_PATH,j.data)
        overwrite_file(APIPWD_PATH,password)
        ret = "KEY找回成功！你的API KEY为："..j.data.."\nAPIKEY和密码均已自动录入骰娘本地文件中，可在 " .. getDiceDir() .. "\\plugin\\PigeonHTTP 文件夹中查看\n不要再弄丢了哦~"
    else
        ret = "KEY找回失败："..j.err_msg
    end
    return ret
end

function arcSearch(msg)
    KEY = read_file(APIKEY_PATH)
    if #KEY==0 then return API_key_missing end
    url = "http://网址:45445/search?api_key="..KEY
    gID = string.match(msg.fromMsg,"ID%-[%s]*(%d+)")
    gName = string.match(msg.fromMsg,"团名%-[%s]*([%C]+)[%s]*")
    gGMQQ = string.match(msg.fromMsg,"主持人QQ%-[%s]*(%d+)")
    gStart = string.match(msg.fromMsg,"开始时间%-[%s]*(%d%d%d%d%-%d%d%-%d%d)")
    gLast = string.match(msg.fromMsg,"持续时间%-[%s]*(%d+[dh])")
    gMin = string.match(msg.fromMsg,"最小人数%-[%s]*([%d]+)")
    gMax = string.match(msg.fromMsg,"最大人数%-[%s]*([%d]+)")
    gNum = string.match(msg.fromMsg,"数量%-[%s]*(%d+)")
    if not(gID or gName or gGMQQ or gStart or gLast or gMin or gMax or gNum) then
        return search_parameter_missing.."\n"..arcSearch_order.."\nID-(精确查找，忽略以下所有参数)\n主持人QQ-(忽略以下所有参数)\n团名-\n开始时间-(格式为yyyy-MM-dd，查找对应日期及以前的团，默认当日30天以后)\n持续时间-(数字+后缀d或h，查找持续时间小于等于此的团)\n最小人数-(默认1)\n最大人数-(默认30)\n数量-(一次最大返回数量，默认100)"
    end
    json = require("json")
    if gID then
        ret = arcSearchID(msg)
        return ret
    elseif gGMQQ then
        ret = search_by_kpqq
        url = url.."&kp_qq="..gGMQQ
        res, data = http.get(url)
    else
        ret = ""
        if gNum then url=url.."&maxnum="..gNum end
        if gName then url=url.."&title="..encodeURI(gName) end
        if gStart then url=url.."&start_time="..gStart end
        if gLast then url=url.."&last_time="..gLast end
        if gMin then url=url.."&minper="..gMin end
        if gMax then url=url.."&maxper="..gMax end
        res, data = http.get(url)
    end
    if not res then return API_access_failed end
    json = require("json")
    j = json.decode(data)
    if j.succ then
        if #j.data==0 then
            ret = ret..search_zero_object
        else
            ret = ret..search_list_head:gsub("{order}",arcSearchID_order)
            for i=1,#j.data do
                ret = ret.."\nID"..tostring(j.data[i].id).." - "..j.data[i].title.." 主持人:"..j.data[i].kp_name.."("..j.data[i].kp_qq..")"
                if i%30==0 then ret = ret.."\f" end
            end
        end
    else
        ret = ret..search_failed:gsub("{ERR}",j.err_msg)
    end
    return ret
end

function arcSearchID(msg)
    KEY = read_file(APIKEY_PATH)
    if #KEY==0 then return API_key_missing end
    url = "http://网址:45445/search?api_key="..KEY
    id = string.match(msg.fromMsg,"(%d+)",#arcSearchID_order+1)
    url = url.."&id="..id
    res, data = http.get(url)
    if not res then return API_access_failed end
    json = require("json")
    j = json.decode(data)
    if j.succ then
        if #j.data==0 then
            ret = searchID_zero_object:gsub("{ID}",id)
        else
            ret = searchID_succeed
            for i=1,#j.data do
                --ret = ret.."ID: "..id.."\n团名："..j.data[1].title.."\n主持人昵称："..j.data[1].kp_name.."("..j.data[1].kp_qq..")\n开始时间："..j.data[1].start_time.."\n持续时间："..j.data[1].last_time.."\n最小人数："..tostring(j.data[1].minper).."\n最大人数："..tostring(j.data[1].maxper).."\n是否满人："..tostring(j.data[1].isfull):gsub("true","是"):gsub("false","否").."\n标签："..j.data[1].tags.."\n推荐技能："..j.data[1].skills.."\n备注："..j.data[1].tips.."\n描述："..j.data[1].des
                ret = ret.."\nID: "..j.data[i].id.."\n团名: "..j.data[i].title.."\n主持人昵称: "..j.data[i].kp_name.."("..j.data[i].kp_qq..")"
                if #j.data[i].players~=0 then
                    ret = ret.."\n当前玩家: "
                    for j=1,#j.data[i].players do
                        ret = ret..j.data[i].players[j].nick.."("..j.data[i].players[j].qq..") "
                    end
                end
                ret = ret.."\n开始时间: "..j.data[i].start_time.."\n持续时间: "..j.data[i].last_time.."\n最小人数: "..tostring(j.data[i].minper).."\n最大人数: "..tostring(j.data[i].maxper).."\n是否满人: "..tostring(j.data[i].isfull):gsub("true","是"):gsub("false","否").."\n标签: "..j.data[i].tags
                if j.data[i].skills then
                    ret = ret.."\n推荐技能: "..j.data[i].skills
                end
                if j.data[i].tips then
                    ret = ret.."\n提示: "..j.data[i].tips
                end
                ret = ret.."\n描述: "..j.data[i].des
            end
        end
    else
        ret = searchID_failed:gsub("{ERR}",j.err_msg)
    end
    return ret
end

function arcSearchMe(msg)
    KEY = read_file(APIKEY_PATH)
    if #KEY==0 then return API_key_missing end
    qq = msg.fromQQ
    url = "http://网址:45445/search?api_key="..KEY.."&kp_qq="..qq
    res, data = http.get(url)
    if not res then return API_access_failed end
    json = require("json")
    j = json.decode(data)
    if j.succ then
        ret = searchMe_succeed
        if #j.data==0 then
            ret = searchMe_zero_object
        else
            for i=1,#j.data do
                ret = ret.."\n"..tostring(i)..". ID"..tostring(j.data[i].id).." - "..j.data[i].title
                if i%30==0 then ret = ret.."\f" end
            end
        end
    else
        ret = searchMe_failed:gsub("{ERR}",j.err_msg)
    end
    return ret
end

function arcSearchAll(msg)
    KEY = read_file(APIKEY_PATH)
    if #KEY==0 then return API_key_missing end
    url = "http://网址:45445/search?api_key="..KEY
    res, data = http.get(url)
    if not res then return API_access_failed end
    json = require("json")
    j = json.decode(data)
    if j.succ then
        ret = searchAll_succeed
        if #j.data==0 then
            ret = searchAll_zero_object
        else
            for i=1,#j.data do
                ret = ret.."\nID"..tostring(j.data[i].id).." - "..j.data[i].title.." 主持人:"..j.data[i].kp_name.."("..j.data[i].kp_qq..")"
                if i%30==0 then ret = ret.."\f" end
            end
        end
    else
        ret = searchAll_failed:gsub("{ERR}",j.err_msg)
    end
    return ret
end

function arcAdd(msg)
    msg.fromMsg = msg.fromMsg:gsub("%[CQ:image,(.-)%]",""):gsub("%[CQ:bface,(.-)","")
    KEY = read_file(APIKEY_PATH)
    if #KEY==0 then return API_key_missing end
    url = "http://网址:45445/add?api_key="..KEY
    u = {}
    u.title = string.match(msg.fromMsg,"团名%-[%s]*([%C]*)")
    u.kp_name = string.match(msg.fromMsg,"主持人昵称%-[%s]*([%C]*)")
    u.kp_qq = string.match(msg.fromMsg,"主持人QQ%-[%s]*(%d+)")
    u.start_time = string.match(msg.fromMsg,"开始时间%-[%s]*(%d%d%d%d%-%d%d%-%d%d)")
    u.last_time = string.match(msg.fromMsg,"持续时间%-(%d+[dh])")
    u.minper = string.match(msg.fromMsg,"最小人数%-[%s]*([%C]*)")
    u.maxper = string.match(msg.fromMsg,"最大人数%-[%s]*([%C]*)")
    u.tags = string.match(msg.fromMsg,"标签%-[%s]*([%C]*)")
    u.skills = string.match(msg.fromMsg,"推荐技能%-[%s]*([%C]+)")
    u.tips = string.match(msg.fromMsg,"备注%-[%s]*([%C]+)")
    u.des = string.match(msg.fromMsg,"介绍%-[%s]*(.+)")
    if not(u.title and u.kp_name and u.kp_qq and u.start_time and u.last_time and u.minper and u.maxper and u.tags and u.des) then
        return add_parameter_missing.."\n"..arcAdd_order.."\n团名-\n主持人昵称-\n主持人QQ-\n开始时间-(预定的开团日期，格式为yyyy-MM-dd，例2022-07-01)\n持续时间-(数字+后缀d或h，d为天，h为小时)\n最小人数-\n最大人数-\n标签-\n推荐技能-(选填)\n备注-(选填)\n介绍-(可以换行)"
    end
    u.minper = tonumber(u.minper)
    u.maxper = tonumber(u.maxper)
    if u.last_time:gsub("(%d+[dh])","", 1)~="" then return "持续时间格式输入错误！\n正确格式为：数字+d或h(d为天，h为小时)" end
    json = require("json")
    res, data = http.post(url, json.encode(u))
    if not res then return API_access_failed end
    j = json.decode(data)
    if j.succ then
        ret = add_succeed:gsub("{ID}",tostring(j.data))
    else
        ret = add_failed:gsub("{ERR}",j.err_msg)
    end
    return ret
end

function arcUpdate(msg)
    KEY = read_file(APIKEY_PATH)
    if #KEY==0 then return API_key_missing end
    url = "http://网址:45445/update?api_key="..KEY
    u = {}
    u.id = string.match(msg.fromMsg,"ID%-[%s]*(%d+)")
    u.title = string.match(msg.fromMsg,"团名%-[%s]*([%C]*)")
    u.kp_name = string.match(msg.fromMsg,"主持人昵称%-[%s]*([%C]*)")
    u.kp_qq = tonumber(msg.fromQQ)  -- 想不到吧
    u.start_time = string.match(msg.fromMsg,"开始时间%-[%s]*(%d%d%d%d%-%d%d%-%d%d)")
    u.last_time = string.match(msg.fromMsg,"持续时间%-[%s]*(%d+[dh])")
    u.minper = string.match(msg.fromMsg,"最小人数%-[%s]*(%d+)")
    u.maxper = string.match(msg.fromMsg,"最大人数%-[%s]*(%d+)")
    u.isfull = string.match(msg.fromMsg,"是否满人%-[%s]*(%C+)")
    u.tags = string.match(msg.fromMsg,"标签%-[%s]*([%C]*)")
    u.skills = string.match(msg.fromMsg,"推荐技能%-[%s]*([%C]+)")
    u.tips = string.match(msg.fromMsg,"备注%-[%s]*([%C]+)")
    u.des = string.match(msg.fromMsg,"介绍%-[%s]*(.+)")
    if not u.id then
        return update_id_missing.."\n"..arcUpdate_order.."\nID-\n团名-\n主持人昵称-\n开始时间-(预定的开团日期，格式为yyyy-MM-dd，例2022-07-01)\n持续时间-(数字+后缀d或h，d为天，h为小时)\n最小人数-\n最大人数-\n是否满人-(是/否)\n标签-\n推荐技能-\n备注-\n介绍-"
    end
    
    if u.id then u.id = tonumber(u.id) end
    if u.minper then u.minper = tonumber(u.minper) end
    if u.maxper then u.maxper = tonumber(u.maxper) end
    if u.isfull then
        if u.isfull=="是" then u.isfull=true
        elseif u.isfull=="否" then u.isfull=false
        else u.isfull=nil
        end
    end
    json = require("json")
    sendMsg(json.encode(u),msg.fromGroup,msg.fromQQ)
    res, data = http.post(url, json.encode(u))
    if not res then return API_access_failed end
    j = json.decode(data)
    if j.succ then
        old_data = "团名："..j.data[1].title.."\n主持人昵称："..j.data[1].kp_name.."("..j.data[1].kp_qq..")\n开始时间："..j.data[1].start_time.."\n持续时间："..j.data[1].last_time.."\n最小人数："..tostring(j.data[1].minper).."\n最大人数："..tostring(j.data[1].maxper).."\n是否满人："..tostring(j.data[1].isfull):gsub("true","是"):gsub("false","否").."\n标签："..j.data[1].tags.."\n推荐技能："..j.data[1].skills.."\n备注："..j.data[1].tips.."\n描述："..j.data[1].des
        new_data = "团名："..j.data[2].title.."\n主持人昵称："..j.data[2].kp_name.."("..j.data[2].kp_qq..")\n开始时间："..j.data[2].start_time.."\n持续时间："..j.data[2].last_time.."\n最小人数："..tostring(j.data[2].minper).."\n最大人数："..tostring(j.data[2].maxper).."\n是否满人："..tostring(j.data[2].isfull):gsub("true","是"):gsub("false","否").."\n标签："..j.data[2].tags.."\n推荐技能："..j.data[2].skills.."\n备注："..j.data[2].tips.."\n描述："..j.data[2].des
        ret = update_succeed:gsub("{old_data}",old_data):gsub("{new_data}",new_data)
    else
        ret = update_failed:gsub("{ERR}",j.err_msg)
    end
    return ret
end

function arcDel(msg)
    KEY = read_file(APIKEY_PATH)
    if #KEY==0 then return API_key_missing end
    url = "http://网址:45445/delete?api_key="..KEY
    u = {}
    u.qq = tonumber(msg.fromQQ)
    u.id = {}
    item, rest = "", string.match(msg.fromMsg, "^[%s]*(.-)[%s]*$", #arcDel_order+1)
    if rest=="" then return delete_id_missing end
    repeat
        item, rest = string.match(rest,"^(%S*)[%s]*(.-)$")
        table.insert(u.id,tonumber(string.match(item,"(%d+)")))
    until(rest=="")
    json = require("json")
    ret = delete_header
    res, data = http.post(url, json.encode(u))
    if not res then return API_access_failed end
    j = json.decode(data)
    if j.succ then
        for i=1, #j.data do
            if j.data[i] then
                ret = ret.."\n"..delete_succeed:gsub("{ID}",u.id[i])
            else
                ret = ret.."\n"..delete_failed:gsub("{ID}",u.id[i])
            end
            if i%30==0 then ret = ret.."\f" end
        end
    else
        ret = ret..delete_request_failed:gsub("{ERR}",j.err_msg)
    end
    return ret
end

function arcVersion(msg)
    url = "http://网址:45445/version"
    res, data = http.get(url)
    if not res then return API_access_failed end
    json = require("json")
    j = json.decode(data)
    if j.succ then
        ret = version_check_succeed:gsub("{version}",j.data)
    else
        ret = version_check_failed
    end
    return ret
end

---------------------------------------------------------------------------

function getMaster()
    local f = io.open(getDiceDir().."/conf/Console.xml","r")
    local content = f.read(f, "a")
    io.close(f)
    local master = string.match(content,"<master>(%d+)</master>")
    return master
end

function overwrite_file(path, text)
	file = io.open(path, "w")
	file.write(file, text)
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

function encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end