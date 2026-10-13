-- SafeEnvironment uninstaller
(
	local ttl = "SafeEnvironment"
	if queryBox "Удалить SafeEnvironment (скрипт и кнопку)?\n\nВаши библиотека, пресеты и кэш в %APPDATA%\\SafeEnvironment останутся." title:ttl do
	(
		local dir = (getDir #userScripts) + "\\SafeEnvironment"
		local mcr = (getDir #userMacros) + "\\SafeEnvironment-SafeEnvironment.mcr"
		python.Execute ("import shutil, os\nshutil.rmtree(r'" + dir + "', ignore_errors=True)\nif os.path.isfile(r'" + mcr + "'): os.remove(r'" + mcr + "')")
		local msg = "Удалено. Кнопка исчезнет после перезапуска 3ds Max."
		if queryBox "Удалить также библиотеку, пресеты и кэш (%APPDATA%\\SafeEnvironment)?" title:ttl do
		(
			python.Execute "import shutil, os\nshutil.rmtree(os.path.join(os.environ.get('APPDATA',''), 'SafeEnvironment'), ignore_errors=True)"
			msg += "\nДанные пользователя удалены."
		)
		messageBox msg title:ttl
	)
)
