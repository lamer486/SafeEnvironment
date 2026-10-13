-- SafeEnvironment installer (run by mzp.run after the files are copied)
(
	local ttl = "SafeEnvironment"
	local ver = (maxVersion())[1]
	local hasCorona = (for c in textureMap.classes where (c as string) == "CoronaBitmap" collect c).count > 0
	local warn = ""
	if ver < 27000 do warn += "\n\n! Нужен 3ds Max 2025 или новее (PySide6) / requires 3ds Max 2025+."
	if not hasCorona do warn += "\n\n! Corona Renderer не найден: скрипт работает только с Corona / Corona Renderer not found."
	-- зарегистрировать кнопку сейчас, без перезапуска Max
	local mcr = (getDir #userMacros) + "\\SafeEnvironment-SafeEnvironment.mcr"
	if doesFileExist mcr do fileIn mcr
	local msg = "SafeEnvironment установлен.\n\nКнопка: Customize > Customize User Interface > Toolbars (или Menus / Quads) > категория «SafeEnvironment» — перетащите «SafeEnvironment» на панель." + warn + "\n\nЗапустить сейчас?"
	if queryBox msg title:ttl do
		try ( macros.run "SafeEnvironment" "SafeEnvironment" ) catch ( messageBox "Не удалось запустить. Перезапустите 3ds Max и повторите." title:ttl )
)
