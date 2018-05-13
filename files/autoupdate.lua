local newfiles = {"Wj6Ftupr"}
local color = colors.red

function writeCentered (dy, s, device)
	local w,h = device.getSize()
	local x = math.floor((w - string.len(s)) / 2)
	local y = math.floor(h/2) + dy
	device.setCursorPos(x,y)
	device.clearLine()
	device.write(s)
end

function drawLineCentered (dy, width, device)
	local w,h = device.getSize()
	local x = math.floor((w - width) / 2)
	local y = math.floor(h/2) + dy
	local str = ""
	for i = 1,width do
		str = str.." "
	end
	device.setCursorPos(x,y)
	device.clearLine()
	device.write(str)
end

function drawProgressBar (dy, widthfilled,widthempty,colorfull,colorempty,device)

	local w,h = device.getSize()
	local x = math.floor((w-(widthfilled+widthempty)) / 2)
	local y = math.floor(h/2) + dy
	local strfilled = ""
	for i = 1,widthfilled do
		strfilled = strfilled.." "
	end
	local strempty = ""
	for i = 1,widthempty do
		strempty = strempty.." "
	end
	device.setCursorPos(x,y)
	device.clearLine()
	device.setBackgroundColor(colorfull)
	device.write(strfilled)
	device.setBackgroundColor(colorempty)
	device.write(strempty)
	device.setBackgroundColor(colors.black)

end

function updateProgressbar(progress,total,device)

	local width = 40
	local ratio = progress/total
	local filled = 40*ratio
	local empty = width-filled
	drawProgressBar(0, filled,empty,color,colors.gray,device)

end

local monitor = peripheral.find("monitor", function(name, object) return object.isColour() end)

monitor.setBackgroundColor(colors.black)
monitor.clear()
monitor.setTextColor(color)
writeCentered (-1, "-- Downloading Packages --" ,monitor)
monitor.setBackgroundColor(colors.black)

local total = table.getn(newfiles)

if fs.exists(_G.osfolder) then
	fs.delete(_G.osfolder)
end

updateProgressbar(0,total,monitor)
writeCentered (1, "0%", monitor)
sleep(1)

for i,file in ipairs(newfiles) do

	shell.run("pastebin get " .. file .. " " .. osfolder.."/"..file)
	updateProgressbar(i,total,monitor)
	writeCentered (1, math.floor(i*100/total).."%",monitor)
end
