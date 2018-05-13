-- Setup global vars --

local qos = {}
qos.osfolder = "/qwertios"
qos.oscode = qos.osfolder.."/os"
local monitor = peripheral.find("monitor", function(name, object) return object.isColour() end)
qos.monitor = monitor
qos.speakers = {peripheral.find("speaker")}
qos.userfolder = qos.osfolder.."/users"
qos.defaultbgcolor = colors.black
qos.defaultcolor = colors.yellow

if not fs.exists(qos.userfolder) then
	fs.makeDir(qos.userfolder)
end

_G.qos = qos

print("Global vars set")

-- Load api --

if fs.exists(_G.qos.oscode.."/qos.lua") then

	print("Move: ".._G.qos.oscode.."/qos.lua".." -> ".._G.qos.oscode.."/Qos")
	fs.move(_G.qos.oscode.."/qos.lua",_G.qos.oscode.."/Qos")

end

print(qos.oscode.."/Qos")
shell.run("cd /")
os.loadAPI(qos.oscode.."/Qos")

Qos.foo("test")

term.flood = {	function (color) self.setBackgroundColor(color) self.clear() end }

term.flood(colors.lime)
-- End --
