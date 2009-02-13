export PATH="$GIT_GOODNESS:$PATH"
source $GIT_GOODNESS/gitg_env.sh

#prevent error by ensuring these files exist
touch $GIT_GITOSIS_ADMIN_PATH
touch $GIT_GITOSIS_ADMIN_MEMBERS
touch $GIT_SVN_SERVER
touch $GIT_SVN_USER_MAP




