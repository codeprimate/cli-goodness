
(* Set Defaults and Loctions *)

set iTunesArtworkFolder to ((path to home folder) as text) & "Pictures:iTunes Artwork:"
-- Artwork Folder

set DefaultArtwork to ((path to home folder) as text) & "Pictures:iTunes Artwork:Default:albumArt.tif"
-- When there's no artwork or iTunes isn't running. This is a transparent TIFF.

set DefaultFolder to ((path to home folder) as text) & "Pictures:iTunes Artwork:Default:"
-- Default Folder

set FromiTunesFolder to ((path to home folder) as text) & "Pictures:iTunes Artwork:From iTunes:"
-- Where iTunes saves the Artwork

set ArtworkFromiTunes to FromiTunesFolder & "albumArt.pict" as file specification
-- The Artwork from iTunes

set AlbumArtwork to (path to home folder) & "Pictures:iTunes Artwork:albumArt.tif" as string
-- The Album Artwork

set UnixAlbumArtwork to the quoted form of POSIX path of AlbumArtwork
-- Unix path to the Album Artwork


(* Check if iTunes is running. *)

tell application "System Events"
	if exists process "iTunes" then
		try
			
			(* Get Artwork From iTunes *)
			tell application "iTunes"
				set aLibrary to name of current playlist -- Name of Current Playlist
				set aTrack to current track
				set aTrackArtwork to null
				
				(* Is there any Artwork? *)
				if (count of artwork of aTrack) ≥ 1 then
					set aTrackArtwork to data of artwork 1 of aTrack
					set fileRef to (open for access ArtworkFromiTunes with write permission)
					try
						set eof fileRef to 512
						write aTrackArtwork to fileRef starting at 513
						close access fileRef
					on error errorMsg
						try
							close access fileRef
						end try
						error errorMsg
					end try
					
					(* Convert to Tiff *)
					tell application "Finder" to set creator type of ArtworkFromiTunes to "????"
					
					tell application "Image Events"
						set theImage to open ArtworkFromiTunes
						save theImage as TIFF in iTunesArtworkFolder & "albumArt.tif" with replacing
					end tell
					
				else
					
					(* If there's no Artwork use the Blank Arwork. *)
					tell application "iTunes"
						if (count of artwork of aTrack) < 1 then
							set aTrackArtwork to DefaultArtwork
							
							
							set unixDefaultFolder to the quoted form of POSIX path of DefaultFolder
							set unixiTunesArtworkFolder to the quoted form of POSIX path of iTunesArtworkFolder
							
							do shell script "ditto -rsrc " & unixDefaultFolder & space & unixiTunesArtworkFolder
							
						end if
					end tell
				end if
			end tell
		end try
		
	else
		if (exists process "iTunes") is false then
			
			(* If itunes isn't running use the Blank Artwork *)
			tell application "Finder"
				set unixDefaultFolder to the quoted form of POSIX path of DefaultFolder
				set unixiTunesArtworkFolder to the quoted form of POSIX path of iTunesArtworkFolder
				
				do shell script "ditto -rsrc " & unixDefaultFolder & space & unixiTunesArtworkFolder
			end tell
			
		end if
	end if
end tell