tell application "Terminal"
	activate
	
	set scriptPath to "/Users/andy/Library/CloudStorage/Dropbox/Scripts/github/mac/setup"
	
	display dialog "Mac Setup Script" & return & return & ¬
		"This will run the interactive Mac setup script." & return & ¬
		"You'll be prompted for each application you want to install." & return & return & ¬
		"Ready to begin?" buttons {"Cancel", "Start Setup"} ¬
		default button "Start Setup" with icon note
	
	if button returned of result is "Start Setup" then
		do script scriptPath
	end if
end tell
