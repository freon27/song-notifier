
on run
	if isSpotifyPlaying() then
		set playingApp to "Spotify"
		set currentlyPlayingTrack to getCurrentlyPlayingSpotifyTrack()
	else if isItunesPlaying() then
		set playingApp to "iTunes"
		set currentlyPlayingTrack to getCurrentlyPlayingItunesTrack()
	else
		set currentlyPlayingTrack to ""
	end if
	
	updateSongRemote(currentlyPlayingTrack)
	--display notification currentlyPlayingTrack
end run




on idle
	if isSpotifyPlaying() then
		set playingApp to "Spotify"
		set currentlyPlayingTrack to getCurrentlyPlayingSpotifyTrack()
	else if isItunesPlaying() then
		set playingApp to "iTunes"
		set currentlyPlayingTrack to getCurrentlyPlayingItunesTrack()
	else
		set currentlyPlayingTrack to ""
	end if
	
	updateSongRemote(currentlyPlayingTrack)
	
	--display notification currentlyPlayingTrack
	return 3
end idle


on updateSongRemote(song)
	set weblink to "http://192.168.1.31:3000/?song="
	set encoded_song to encode_text(song & " ", true, true)
	set curl_command to "curl " & weblink & encoded_song
	do shell script curl_command
end updateSongRemote


-- Method to get the currently playing track
on getCurrentlyPlayingSpotifyTrack()
	tell application "Spotify"
		set currentArtist to artist of current track as string
		set currentTrack to name of current track as string
		
		return currentArtist & " - " & currentTrack
	end tell
end getCurrentlyPlayingSpotifyTrack

on getCurrentlyPlayingItunesTrack()
	tell application "iTunes"
		set currentArtist to artist of current track as string
		set currentTrack to name of current track as string
		
		return currentArtist & " - " & currentTrack
	end tell
end getCurrentlyPlayingItunesTrack

on isSpotifyPlaying()
	tell application "Spotify"
		if player state is playing then
			return true
		else
			return false
		end if
	end tell
end isSpotifyPlaying

on isItunesPlaying()
	tell application "iTunes"
		
		if player state is playing then
			return true
		else
			return false
		end if
	end tell
end isItunesPlaying





on encode_char(this_char)
	set the ASCII_num to (the ASCII number this_char)
	set the hex_list to {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
	set x to item ((ASCII_num div 16) + 1) of the hex_list
	set y to item ((ASCII_num mod 16) + 1) of the hex_list
	return ("%" & x & y) as string
end encode_char

-- this sub-routine is used to encode text 
on encode_text(this_text, encode_URL_A, encode_URL_B)
	set the standard_characters to "abcdefghijklmnopqrstuvwxyz0123456789"
	set the URL_A_chars to "$+!'/?;&@=#%><{}[]\"~`^\\|*"
	set the URL_B_chars to ".-_:"
	set the acceptable_characters to the standard_characters
	if encode_URL_A is false then set the acceptable_characters to the acceptable_characters & the URL_A_chars
	if encode_URL_B is false then set the acceptable_characters to the acceptable_characters & the URL_B_chars
	set the encoded_text to ""
	repeat with this_char in this_text
		if this_char is in the acceptable_characters then
			set the encoded_text to (the encoded_text & this_char)
		else
			set the encoded_text to (the encoded_text & encode_char(this_char)) as string
		end if
	end repeat
	return the encoded_text
end encode_text