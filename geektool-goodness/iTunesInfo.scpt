tell application "System Events"
	set powerCheck to ((application processes whose (name is equal to "iTunes")) count)
	if powerCheck = 0 then
		return ""
	end if
end tell
tell application "iTunes"
	try
		set playerstate to (get player state)
	end try
	if playerstate = paused then
		set trackPaused to " (paused)"
	else
		set trackPaused to ""
	end if
	if playerstate = stopped then
		return "Stopped"
	end if
	set trackID to the current track
	set trackName to the name of trackID
	set artistName to the artist of trackID
	set albumName to the album of trackID
	set totalData to "" & trackName & trackPaused & "
" & artistName & " - " & albumName
	return totalData
end tell