# Program Aliases
alias tm="mate app/ config/ db/ lib/ public/ spec/ test/"
alias edit="mate app/ config/ db/ lib/ public/ spec/ test/"

alias c="script/console"
alias tl="tail -f log/development.log"
alias mg="script/server --debugger"
alias pull="gitup"
alias push="git push"
alias commit="gitac"


#
# alias directory listing
#
alias lsl="ls -l"
alias lsa='ls -a'
alias lsal='ls -al'

#
# opens textmate with this package ready to edit
#
alias editcli='mate ~/.bash_login ~/cli-goodness'

#
# aliases for editing apache config files
#
alias httpdconf='mate /etc/apache2/httpd.conf'
alias hostconf='mate /etc/hosts'
alias vhostconf='mate /etc/apache2/extra/httpd-vhosts.conf'