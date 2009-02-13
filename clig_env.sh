# Set Environment variables
export PATH="$CLI_GOODNESS:$PATH" 
export EDITOR="mate -w" 
export CVSEDITOR="mate -w" 
export SVN_EDITOR="mate -w"

#export PS1="\\u@\h:\w$ "
export PS1='\[\033[00;32m\]\u\[\033[01m\]@\[\033[00;36m\]\h\[\033[01m\]:\[\033[00;35m\]\w\[\033[00m\]\[\033[01;33m\]`git branch 2>/dev/null|cut -f2 -d\* -s`\[\033[00m\]\$ '

#
# Bash Color Escape Codes
#

# Use any of the following escape codes between \e[ and m to colorize text in Bash:
# Black 			0;30
# Dark Gray 		1;30
# Blue 				0;34
# Light Blue 		1;34
# Green 			0;32
# Light Green 		1;32
# Cyan 				0;36
# Light Cyan 		1;36
# Red 				0;31
# Light Red 		1;31
# Purple 			0;35
# Light Purple 		1;35
# Brown 			0;33
# Yellow 			1;33
# Light Gray 		0;37
# White 			1;37