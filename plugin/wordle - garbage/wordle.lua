msg_order={}

width = 136
height = 160
bit = 3
Red = 255
Green = 255
Blue = 255

bfType = 'BM'
bfSize = (width*height*bit + 54)
bfReserved1 = 0
bfReserved2 = 0
bfOffBits = 54

biSize = 40
biWidth = width
biHeight = height
biPlanes = 1
biBitCount = bit * 8
biCompression = 0
biSizeImage = 0
biXPelsPerMeter = 3780
biYPelsPerMeter = 3780
biClrUsed = 0
biClrImportant = 0

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

function read_file(path)
    local text = ""
    local file = io.open(path, "r") -- 打开了文件读写路径
    if (file ~= nil) then -- 如果文件不是空的
        text = file.read(file, "*a") -- 读取内容
        io.close(file) -- 关闭文件
    end 
    return text
end

function overwrite_file(path, text)
	file = io.open(path, "w") -- 以只写的方式，会将原内容清空后写
	file.write(file, text)
	io.close(file)
end

function intTobytes(count,x)
	local b4 = 0
	local b3 = 0
	local b2 = 0
	local b1 = 0
	if count == 4 then  
		b4=x%256  x=(x-x%256)/256
		b3=x%256  x=(x-x%256)/256
		b2=x%256  x=(x-x%256)/256
		b1=x%256  x=(x-x%256)/256 
		return string.char(b4,b3,b2,b1)
	elseif count == 2 then
		b2=x%256  x=(x-x%256)/256
		b1=x%256  x=(x-x%256)/256
		return string.char(b2,b1)  
	elseif count == 1 then
		b1=x%256  x=(x-x%256)/256
		return string.char(b1)
	end
end

wordleFolderArray=Split(getDiceDir(),"\\")
wordleFolder = ""
for i=1,#wordleFolderArray-1,1 do wordleFolder = wordleFolder .. wordleFolderArray[i].."\\" end
wordleFolder=wordleFolder.."data\\image\\wordle\\"

function wordle(msg)
	raw = string.match(msg.fromMsg,"^%a%a%a%a%a$") -- 仅匹配5字纯英文，若不匹配返回nil
	if raw==nil then return "" end
	json = require("json")
	raw = string.lower(raw) -- 转换成小写方便对表
	require("wordle_wordlist")
	if wordleWords[raw]==nil then return "这好像不是单词呢，换一个试试？\n（若发现单词未收录的现象，请[.send]联系管理员）" end
	
	if msg.fromGroup=="0" then
		wGroup = "qq"..msg.fromQQ
	else
		wGroup = "group"..msg.fromGroup
	end
	
	wordleData = read_file(wordleFolder..wgroup..".json")
	if #wordleData==0 then
		j = {}
	else
		j = json.decode(wordleData)
	end
	
end

function wordle_start(msg) -- 初始化

	require("wordle_wordlist")
	random_word = wordleWordlist[ranint(1,#wordleWordlist)]
	
	if msg.fromGroup=="0" then
		wGroup = "qq"..msg.fromQQ
	else
		wGroup = "group"..msg.fromGroup
	end
	
	
end
-- msg_order["猜单词"]="wordle_start"


--[[

存储步骤
1.初始化，在发送指令后记录群号、生成单词
2.猜词，存储每一位匹配与否的数据，记录猜测数
3.猜完了：结束游戏，删除数据并存回

存储细则
1.全部存储入data\image\wordle文件夹，每个文件单独存放
2.文件名为qq/group+号码.json，例qq1142145792.json或group689683078.json
3.1.WordAnswer={"a","b","c","d","e"}
3.2.guess={{},{},{},{},{},{}}（初始化为空数组）
3.3.answer={{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}（0=blank,1=gray,2=yellow,3=green）
3.4.tries=0（逐次增加，=6直接结束游戏）

]]


--[[

图像处理细则
1.图像大小：136*160
2.每格大小：20*20
3.格子与图像边缘的距离：10&10
4.格子与格子之间的距离：4&4
5.图像初始点：横轴X从左往右，纵轴Y从下往上，左下角为(1,1)，右上角为(136,160)
6.字母格排列数：5*6
7.字母格初始点：横轴I从左往右，纵轴J从上往下，左上角为(1,1)，右下角为(5,6)
8.字母网格判定：(x-10)//24+1得横轴网格点，7-(160-y+10)//24得纵轴网格点
9.网格相对点判定：(x-10)%24与(160-y+10)%24所得余数，左上角为(1,1)，右下角为(20,20)，0或20以上取白色
10.字母着色：依照网格相对点查表上色（前期请用dotMagenta）

图像处理流程
1.从左下起逐点着色
2.每点进行一次判定，次序为：查看权重、选择权重对应颜色、若权重高有字母则添加
3.例点(11,11)，先进行一次是否有字母判定，有字母，非对位，非对字，是灰色
4.兜底规则：网格横轴为6或纵轴为7的做空白处理（前期请先用dotCyan）

]]

--[[

字符判定
1.读取对应json数据
2.tries++
3.guess[tries]={"a","b","c","d","e"}
4.双轴for循环：以guess匹配WordAnswer，若匹配且数字相同则answer[num]=3，否则=2，再则=1
5.写回去

]]

function dotWhite()
io.write(intTobytes(1,255))--蓝
io.write(intTobytes(1,255))--绿
io.write(intTobytes(1,255))--红
end

function dotLightGray()
io.write(intTobytes(1,218))--蓝
io.write(intTobytes(1,218))--绿
io.write(intTobytes(1,218))--红
end

function dotGray()
io.write(intTobytes(1,128))--蓝
io.write(intTobytes(1,128))--绿
io.write(intTobytes(1,128))--红
end

function dotYellow()
io.write(intTobytes(1,88))--蓝
io.write(intTobytes(1,180))--绿
io.write(intTobytes(1,201))--红
end

function dotGreen()
io.write(intTobytes(1,100))--蓝
io.write(intTobytes(1,170))--绿
io.write(intTobytes(1,106))--红
end

function dotMagenta() --Debug色，用于初期字母判定
io.write(intTobytes(1,255))--蓝
io.write(intTobytes(1,0))--绿
io.write(intTobytes(1,255))--红
end

function dotCyan() --Debug色
io.write(intTobytes(1,255))--蓝
io.write(intTobytes(1,255))--绿
io.write(intTobytes(1,0))--红
end
