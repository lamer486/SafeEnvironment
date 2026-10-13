-- SkyRig Studio uninstaller
global SRS_uninst_guard
if SRS_uninst_guard == undefined or (timeStamp() - SRS_uninst_guard) > 2000 do
(
	local ttl = "SkyRig Studio"
	if queryBox "Uninstall SkyRig Studio (script and button)?\n\nYour library, presets and cache in %APPDATA%\\SafeEnvironment will be kept." title:ttl do
	(
		local dir = (getDir #userScripts) + "\\SkyRigStudio"
		local mcr = (getDir #userMacros) + "\\SkyRigStudio-SkyRigStudio.mcr"
		local oldDir = (getDir #userScripts) + "\\SafeEnvironment"
		local oldMcr = (getDir #userMacros) + "\\SafeEnvironment-SafeEnvironment.mcr"
		python.Execute ("import shutil, os\nfor d in (r'" + dir + "', r'" + oldDir + "'):\n\tshutil.rmtree(d, ignore_errors=True)\nfor f in (r'" + mcr + "', r'" + oldMcr + "'):\n\tif os.path.isfile(f): os.remove(f)")
		local msg = "Uninstalled. The button disappears after 3ds Max is restarted."
		if queryBox "Also delete the library, presets and cache (%APPDATA%\\SafeEnvironment)?" title:ttl do
		(
			python.Execute "import shutil, os\nshutil.rmtree(os.path.join(os.environ.get('APPDATA',''), 'SafeEnvironment'), ignore_errors=True)"
			msg += "\nUser data deleted."
		)
		messageBox msg title:ttl
	)

	SRS_uninst_guard = timeStamp()
)
