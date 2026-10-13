-- SkyRig Studio uninstaller
global SRS_uninst_guard
if SRS_uninst_guard == undefined or (timeStamp() - SRS_uninst_guard) > 2000 do
(
	local ttl = "SkyRig Studio"
	if queryBox "Удалить SkyRig Studio (скрипт и кнопку)?\n\nВаши библиотека, пресеты и кэш в %APPDATA%\\SafeEnvironment останутся." title:ttl do
	(
		local dir = (getDir #userScripts) + "\\SkyRigStudio"
		local mcr = (getDir #userMacros) + "\\SkyRigStudio-SkyRigStudio.mcr"
		local oldDir = (getDir #userScripts) + "\\SafeEnvironment"
		local oldMcr = (getDir #userMacros) + "\\SafeEnvironment-SafeEnvironment.mcr"
		python.Execute ("import shutil, os\nfor d in (r'" + dir + "', r'" + oldDir + "'):\n\tshutil.rmtree(d, ignore_errors=True)\nfor f in (r'" + mcr + "', r'" + oldMcr + "'):\n\tif os.path.isfile(f): os.remove(f)")
		local msg = "Удалено. Кнопка исчезнет после перезапуска 3ds Max."
		if queryBox "Удалить также библиотеку, пресеты и кэш (%APPDATA%\\SafeEnvironment)?" title:ttl do
		(
			python.Execute "import shutil, os\nshutil.rmtree(os.path.join(os.environ.get('APPDATA',''), 'SafeEnvironment'), ignore_errors=True)"
			msg += "\nДанные пользователя удалены."
		)
		messageBox msg title:ttl
	)

	SRS_uninst_guard = timeStamp()
)
