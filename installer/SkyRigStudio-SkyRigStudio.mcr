macroScript SkyRigStudio
category:"SkyRig Studio"
internalCategory:"SkyRig Studio"
buttonText:"SkyRig Studio"
toolTip:"SkyRig Studio - HDRI and Sun (Corona)"
(
	on execute do
	(
		local f = (getDir #userScripts) + "\\SkyRigStudio\\skyrig_studio.py"
		if doesFileExist f then python.ExecuteFile f
		else messageBox ("SkyRig Studio: file not found / файл не найден:\n" + f) title:"SkyRig Studio"
	)
)

macroScript SkyRigStudioUninstall
category:"SkyRig Studio"
internalCategory:"SkyRig Studio"
buttonText:"Uninstall SkyRig Studio"
toolTip:"Uninstall SkyRig Studio / Удалить SkyRig Studio"
(
	on execute do
	(
		local f = (getDir #userScripts) + "\\SkyRigStudio\\uninstall.ms"
		if doesFileExist f then fileIn f
		else messageBox ("Uninstaller not found / не найден деинсталлятор:\n" + f) title:"SkyRig Studio"
	)
)
