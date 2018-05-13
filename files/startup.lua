_G.qos.osfolder = "/qwetios"
_G.qos.userfolder = "/qwetios"
programName = "autoupdate"
programCode = "RXgXFX2h"
startupCode = "Wj6Ftupr"

if fs.exists(programName) then
	fs.delete(programName)
end
shell.run("pastebin get " .. programCode .. " " .. programName)
shell.run(programName)
if fs.exists(programName) then
	fs.delete(programName)
end

shell.run(_G.osfolder.."/"..startupCode)
