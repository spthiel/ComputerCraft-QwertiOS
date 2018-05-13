-- Setup global vars --

local qos = {}
local monitor = peripheral.find("monitor", function(name, object) return object.isColour() end)
qos.monitor = monitor
qos.speakers = {peripheral.find("speaker")}
qos.userfolder = qos.osfolder.."/users"

if not fs.exists(qos.userfolder) then
	fs.makeDir(qos.userfolder)
end

_G.qos = qos

print("Global vars set")

os.loadAPI(qos.osfolder.."/qos")

qos.foo("test")

-- End --
