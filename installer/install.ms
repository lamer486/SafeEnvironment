-- SafeEnvironment installer (run by mzp.run after the files are copied)
global SE_inst_guard
global SE_inst_choice
-- Max запускает установщик по-разному (fileIn: run, перетаскивание: drop); в mzp.run указаны оба, повтор отсекается
if SE_inst_guard == undefined or (timeStamp() - SE_inst_guard) > 2000 do
(
	local ver = (maxVersion())[1]
	local hasCorona = (for c in textureMap.classes where (c as string) == "CoronaBitmap" collect c).count > 0
	local warn1 = ""
	local warn2 = ""
	if ver < 27000 do warn1 = "! Нужен 3ds Max 2025 или новее (PySide6)."
	if not hasCorona do warn2 = "! Corona Renderer не найден: скрипт работает только с Corona."
	-- зарегистрировать кнопку сейчас, без перезапуска Max
	local mcr = (getDir #userMacros) + "\\SafeEnvironment-SafeEnvironment.mcr"
	if doesFileExist mcr do fileIn mcr

	SE_inst_choice = 0
	rollout SE_inst_rol "SafeEnvironment"
	(
		label l1 "SafeEnvironment установлен." align:#left offset:[0,6]
		label l2 "Кнопка: Customize > Customize User Interface >" align:#left offset:[0,6]
		label l3 "Toolbars (или Menus / Quads) > категория «SafeEnvironment»," align:#left
		label l4 "перетащите «SafeEnvironment» на панель." align:#left
		label l5 warn1 align:#left offset:[0,6]
		label l6 warn2 align:#left
		button b_run "Запустить сейчас" width:130 height:26 across:3 offset:[0,10]
		button b_del "Удалить скрипт" width:130 height:26 offset:[0,10]
		button b_close "Закрыть" width:130 height:26 offset:[0,10]
		on b_run pressed do ( SE_inst_choice = 1; destroyDialog SE_inst_rol )
		on b_del pressed do ( SE_inst_choice = 2; destroyDialog SE_inst_rol )
		on b_close pressed do ( SE_inst_choice = 0; destroyDialog SE_inst_rol )
	)
	try ( destroyDialog SE_inst_rol ) catch ()
	createDialog SE_inst_rol 440 190 modal:true

	if SE_inst_choice == 1 do
		try ( macros.run "SafeEnvironment" "SafeEnvironment" ) catch ( messageBox "Не удалось запустить. Перезапустите 3ds Max и повторите." title:"SafeEnvironment" )
	if SE_inst_choice == 2 do
	(
		local un = (getDir #userScripts) + "\\SafeEnvironment\\uninstall.ms"
		if doesFileExist un then
		(
			SE_uninst_guard = undefined
			fileIn un
		)
		else messageBox "Файл удаления не найден." title:"SafeEnvironment"
	)
	SE_inst_guard = timeStamp()
)
