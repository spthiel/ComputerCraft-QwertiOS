-- Setup global vars --

local qos = {}
qos.osfolder = "/qwertios"
qos.oscode = qos.osfolder.."/os"
local monitor = peripheral.find("monitor", function(name, object) return object.isColour() end)
qos.monitor = monitor
qos.speakers = {peripheral.find("speaker")}
qos.userfolder = qos.osfolder.."/users"

if not fs.exists(qos.userfolder) then
	fs.makeDir(qos.userfolder)
end

_G.qos = qos

print("Global vars set")

-- Load api --

print(qos.oscode.."/qos")
print("test")
os.loadAPI(qos.oscode.."/qos")

qos.foo("test")

-- End --
