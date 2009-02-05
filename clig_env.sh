# Set Environment variables
export PATH="$CLI_GOODNESS:$PATH" 
export EDITOR="mate -w" 
export CVSEDITOR="mate -w" 
export SVN_EDITOR="mate -w"

#export PS1="\\u@\h:\w$ "
export PS1='\[\033[00;32m\]\u\[\033[01m\]@\[\033[00;36m\]\h\[\033[01m\]:\[\033[00;35m\]\w\[\033[00m\]\[\033[01;33m\]`git branch 2>/dev/null|cut -f2 -d\* -s`\[\033[00m\]\$ '