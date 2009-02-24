
# this addition will show the branch of a git repo in terminal prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# PS1='\u@\h \w\e[01;32m\]$( parse_git_branch )\e[00m\]\$ '

#
# vars used by the gitosis script
#
export GIT_GITOSIS_ADMIN_PATH="$GIT_GOODNESS/gitosis_path.txt"
export GIT_GITOSIS_ADMIN_MEMBERS="$GIT_GOODNESS/gitosis_members.txt"

#
# vars used by the svn2git script
#
export GIT_SVN_SERVER="$GIT_GOODNESS/svn_server.txt"
export GIT_SVN_USER_MAP="$GIT_GOODNESS/svn_users.txt"