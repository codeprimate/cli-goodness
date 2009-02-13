export PATH="$PROJ_GOODNESS:$PATH"
source $PROJ_GOODNESS/projg_env.sh

#prevent error by ensuring these files exist
touch $PROJECT_FILES_PATH
touch $PROJECT_ALIASES_PATH

source $PROJ_GOODNESS/projg_aliases.sh