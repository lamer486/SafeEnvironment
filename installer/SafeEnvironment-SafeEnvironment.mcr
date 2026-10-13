macroScript SafeEnvironment
category:"SafeEnvironment"
internalCategory:"SafeEnvironment"
buttonText:"SafeEnvironment"
toolTip:"SafeEnvironment - HDRI and Sun (Corona)"
(
	on execute do
	(
		local f = (getDir #userScripts) + "\\SafeEnvironment\\safe_environment.py"
		if doesFileExist f then python.ExecuteFile f
		else messageBox ("SafeEnvironment: file not found / файл не найден:\n" + f) title:"SafeEnvironment"
	)
)

macroScript SafeEnvironmentUninstall
category:"SafeEnvironment"
internalCategory:"SafeEnvironment"
buttonText:"Uninstall SafeEnvironment"
toolTip:"Uninstall SafeEnvironment / Удалить SafeEnvironment"
(
	on execute do
	(
		local f = (getDir #userScripts) + "\\SafeEnvironment\\uninstall.ms"
		if doesFileExist f then fileIn f
		else messageBox ("Uninstaller not found / не найден деинсталлятор:\n" + f) title:"SafeEnvironment"
	)
)
