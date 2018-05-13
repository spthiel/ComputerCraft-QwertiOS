local tArgs, gUser, gRepo, gPath, gBranch = {...}, nil, nil, "", "master"
local usage = [[
 github <user> <repo> [path] [remote path] [branch]
 Remote path defaults to the root of the repo.
 Path defaults to the download folder.
 Branch defaults to master.
 If you want to leave an option empty use a dot.
 Example: github johnsmith hello-world . foo
 Everything inside the directory foo will be
 downloaded to downloads/hello-world/.
  ]]
local blackList = [[
@blacklistedfile
]]

local title = "Github Repo Downloader"
local fileList = {dirs={},files={}}
local monitor = peripheral.find("monitor", function(name, object) return object.isColour() end)
local x , y = monitor.getSize()

monitor.setTextColor(colors.yellow)

-- GUI
function printTitle()
	local line = 2
	monitor.setCursorPos(1,line)
	for i = 2, x, 1 do monitor.write("-") end
	monitor.setCursorPos((x-title:len())/2,line+1)
	monitor.write(title)
	monitor.setCursorPos(1,line+2)
	for i = 2, x, 1 do monitor.write("-") end
end

function writeCenter( str )
    str = " "..str.." "
	monitor.clear()
	printTitle()
	monitor.setCursorPos((x-str:len())/2-1,y/2-1)
	monitor.setBackgroundColor(colors.yellow)
	for i = -1, str:len(), 1 do monitor.write(" ") end
	monitor.setBackgroundColor(colors.black)
	monitor.setCursorPos((x-str:len())/2-1,y/2)
	monitor.setBackgroundColor(colors.yellow)
    monitor.write(" ")
	monitor.setBackgroundColor(colors.black)
	monitor.write(str)
	monitor.setBackgroundColor(colors.yellow)
    monitor.write(" ")
	monitor.setBackgroundColor(colors.black)
	monitor.setCursorPos((x-str:len())/2-1,y/2+1)
	monitor.setBackgroundColor(colors.yellow)
	for i = -1, str:len(), 1 do monitor.write(" ") end
	monitor.setBackgroundColor(colors.black)
end

function printUsage()
	local str = "Press space key to continue"
	monitor.clear()
	printTitle()
	monitor.setCursorPos(1,y/2-4)
	monitor.write(usage)
	monitor.setCursorPos((x-str:len())/2,y/2+7)
	monitor.write(str)
	while true do
		local event, param1 = os.pullEvent("key")
		if param1 == 57 then
			sleep(0)
			break
		end
	end
	monitor.clear()
	monitor.setCursorPos(1,1)
end

-- Download File
function downloadFile( path, url, name )
	writeCenter("Downloading File: "..name)
	dirPath = path:gmatch('([%w%_%.% %-%+%,%;%:%*%#%=%/]+)/'..name..'$')()
	if dirPath ~= nil and not fs.isDir(dirPath) then fs.makeDir(dirPath) end
	local content = http.get(url)
	local file = fs.open(path,"w")
	file.write(content.readAll())
	file.close()
end

-- Get Directory Contents
function getGithubContents( path )
	local pType, pPath, pName, checkPath = {}, {}, {}, {}
	local response = http.get("https://api.github.com/repos/"..gUser.."/"..gRepo.."/contents/"..path.."/?ref="..gBranch)
	if response then
		response = response.readAll()
		if response ~= nil then
			for str in response:gmatch('"type":"(%w+)"') do table.insert(pType, str) end
			for str in response:gmatch('"path":"([^\"]+)"') do table.insert(pPath, str) end
			for str in response:gmatch('"name":"([^\"]+)"') do table.insert(pName, str) end
		end
	else
		writeCenter( "Error: Can't resolve URL" )
		sleep(2)
		monitor.clear()
		monitor.setCursorPos(1,1)
		error()
	end
	return pType, pPath, pName
end

-- Blacklist Function
function isBlackListed( path )
	if blackList:gmatch("@"..path)() ~= nil then
		return true
	end
end

-- Download Manager
function downloadManager( path )
	local fType, fPath, fName = getGithubContents( path )
	for i,data in pairs(fType) do
		if data == "file" then
			checkPath = http.get("https://raw.github.com/"..gUser.."/"..gRepo.."/"..gBranch.."/"..fPath[i])
			if checkPath == nil then

				fPath[i] = fPath[i].."/"..fName[i]
			end
			local path = "downloads/"..gRepo.."/"..fPath[i]
			if gPath ~= "" then path = gPath.."/"..gRepo.."/"..fPath[i] end
			if not fileList.files[path] and not isBlackListed(fPath[i]) then
				fileList.files[path] = {"https://raw.github.com/"..gUser.."/"..gRepo.."/"..gBranch.."/"..fPath[i],fName[i]}
			end
		end
	end
	for i, data in pairs(fType) do
		if data == "dir" then
			local path = "downloads/"..gRepo.."/"..fPath[i]
			if gPath ~= "" then path = gPath.."/"..gRepo.."/"..fPath[i] end
			if not fileList.dirs[path] then
				writeCenter("Listing directory: "..fName[i])
				fileList.dirs[path] = {"https://raw.github.com/"..gUser.."/"..gRepo.."/"..gBranch.."/"..fPath[i],fName[i]}
				downloadManager( fPath[i] )
			end
		end
	end
end

-- Main Function
function main( path )
	writeCenter("Connecting to Github")
	downloadManager(path)
	for i, data in pairs(fileList.files) do
		downloadFile( i, data[1], data[2] )
	end
	writeCenter("Download completed")
	sleep(2,5)
	monitor.clear()
	monitor.setCursorPos(1,1)
end

-- Parse User Input
function parseInput( user, repo , dldir, path, branch )
	if path == nil then path = "" end
	if branch ~= nil then gBranch = branch end
	if repo == nil then printUsage()
	else
		gUser = user
		gRepo = repo
		if dldir ~= nil then gPath = dldir end
		main( path )
	end
end

if not http then
	writeCenter("You need to enable the HTTP API!")
	sleep(3)
	monitor.clear()
	monitor.setCursorPos(1,1)
else
	for i=1, 5, 1 do
		if tArgs[i] == "." then tArgs[i] = nil end
	end
	parseInput( tArgs[1], tArgs[2], tArgs[3], tArgs[4], tArgs[5] )
end
