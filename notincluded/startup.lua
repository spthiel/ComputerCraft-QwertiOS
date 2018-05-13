_G.qos = {}
_G.qos.osfolder = "/qwertios"
_G.qos.oscode = _G.qos.osfolder.."/os"
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

if fs.exists(_G.qos.oscode) then
    fs.delete(_G.qos.oscode)
end


print("Move: ".."/"..repo.."/"..remotedir.." -> ".._G.qos.oscode)
fs.move("/"..repo.."/"..remotedir,_G.qos.oscode)

if fs.exists("/"..repo) then
    fs.delete(""..repo)
end

shell.run(_G.qos.oscode.."/bootloader")
