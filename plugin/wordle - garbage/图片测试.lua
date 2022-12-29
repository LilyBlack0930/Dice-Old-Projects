msg_order={}

width = 136;
height = 160;
bit = 3;
Red = 255;
Green = 255;
Blue = 255;

bfType = 'BM'
bfSize = (width*height*bit + 54);
bfReserved1 = 0;
bfReserved2 = 0;
bfOffBits = 54;

biSize = 40
biWidth = width;
biHeight = height;
biPlanes = 1;
biBitCount = bit * 8;
biCompression = 0
biSizeImage = 0;
biXPelsPerMeter = 3780;
biYPelsPerMeter = 3780;
biClrUsed = 0;
biClrImportant = 0;

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

picTest_folder_array=Split(getDiceDir(),"\\")
picTest_folder = ""
for i=1,#picTest_folder_array-1,1 do picTest_folder = picTest_folder .. picTest_folder_array[i].."\\" end
picTest_path=picTest_folder.."data\\image\\wordle\\picTest.bmp"--测试中

function intTobytes(count,x)
	local b4 = 0;
	local b3 = 0;
	local b2 = 0;
	local b1 = 0;
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

function picTest()
	
	file = assert(io.open(picTest_path, "w")) -- 以只写的方式，会将原内容清空后写
	if file==nil then
		os.execute("mkdir "..picTest_folder) -- 先创建文件夹，若已经有了则会是无效指令
		file = io.open(picTest_path,"a")
		io.output(file)
		file.write(file,"")
		io.close(file)
	end
	io.close(file)

	file = io.open(picTest_path, "w")
	

	-- 设置默认输出文件为 test.lua
	io.output(file)

	-- 在文件最后一行添加 Lua 注释
	io.write(bfType)

	io.write(intTobytes(4,bfSize))

	io.write(intTobytes(2,bfReserved1));
	io.write(intTobytes(2,bfReserved2));
	io.write(intTobytes(4,bfOffBits));

	--reconstruct bmp header
	io.write(intTobytes(4,biSize))
	io.write(intTobytes(4,biWidth))
	io.write(intTobytes(4,biHeight))
	io.write(intTobytes(2,biPlanes))
	io.write(intTobytes(2,biBitCount))
	io.write(intTobytes(4,biCompression))
	io.write(intTobytes(4,biSizeImage))
	io.write(intTobytes(4,biXPelsPerMeter))
	io.write(intTobytes(4,biYPelsPerMeter))
	io.write(intTobytes(4,biClrUsed))
	io.write(intTobytes(4,biClrImportant))



	-- reconstruct pixels
	for x=1,height, 1 do
		for y=1,width, 1 do
			io.write(intTobytes(1,Blue))
			io.write(intTobytes(1,Green))
			io.write(intTobytes(1,Red))
		end
	end

	io.close(file)
	return "[CQ:image,file=\\wordle\\picTest.bmp]"
end
-- msg_order["图片测试"]="picTest"