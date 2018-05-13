-- Setup global vars --

local qos = {}
qos.osfolder = _G.osfolder
local monitor = peripheral.find("monitor", function(name, object) return object.isColour() end)
qos.monitor = monitor
_G.qos = qos

print("Global vars set")

-- End --
