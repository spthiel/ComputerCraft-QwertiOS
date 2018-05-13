_G.qos = {}
_G.qos.osfolder = "/qwertios"
local programName = "github"
local programCode = "Wj6Ftupr"

local githubname = "spthiel"
local repo = "ComputerCraft-QwertiOS"
local remotedir = "files"


if fs.exists(programName) then
    fs.delete(programName)
end
shell.run("pastebin get " .. programCode .. " " .. programName)
shell.run("github "..githubname.." "..repo.." ".."/".." "..remotedir)

if fs.exists(programName) then
    fs.delete(programName)
end

if fs.exists(_G.qos.osfolder) then
    fs.delete(_G.qos.osfolder)
end
print("Move: ".."/"..repo.."/"..remotedir.." -> ".._G.qos.osfolder)
fs.move("/"..repo.."/"..remotedir,_G.qos.osfolder)

if fs.exists("/"..repo) then
    fs.delete(""..repo)
end

shell.run(_G.qos.osfolder.."/bootloader")
