#################################
# Navegation
#################################
alias fhere='find . -name'
# alias .='pwd'  # impacts the bash completion
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias .....='cd ../../../../..'
alias cd..='cd ..'
alias lt='ls -lhatFG'
alias llt='ls -lhatF | less'
alias c='clear'
alias e='exit'



#################################
# File manipulation
#################################
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
function extract {
  if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
  else
	  for n in $@
	  do
	    if [ -f "$n" ] ; then
	        case "${n%,}" in
	          *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
	                       tar xvf "$n"       ;;
	          *.lzma)      unlzma ./"$n"      ;;
	          *.bz2)       bunzip2 ./"$n"     ;;
	          *.rar)       unrar x -ad ./"$n" ;;
	          *.gz)        gunzip ./"$n"      ;;
	          *.zip)       unzip ./"$n"       ;;
	          *.z)         uncompress ./"$n"  ;;
	          *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
	                       7z x ./"$n"        ;;
	          *.xz)        unxz ./"$n"        ;;
	          *.exe)       cabextract ./"$n"  ;;
	          *)
	                       echo "extract: '$n' - unknown archive method"
	                       return 1
	                       ;;
	        esac
	    else
	        echo "'$n' - file does not exist"
	        return 1
	    fi
	  done
	fi
}
function optize {
  if [[ -z "$1" || -z "$2" || -z "$3" || ! ( -e "$1" && -e "$3" ) ]]; then
    # display usage if no parameters given
    echo "Usage: optize <path/folder_name> <desired_name> <bin_path>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
  else
	  FOLDER_NAME=${1%%/*}
	  INTERNAL_BIN_PATH=${3##${FOLDER_NAME}/}
	  BIN_FILE=${3##*/}
	  sudo mv $1 /opt/$1
	 	sudo ln -s /opt/$1 /usr/local/lib/$2
	 	sudo ln -s /usr/local/lib/$2/$INTERNAL_BIN_PATH /usr/local/bin/$BIN_FILE
	fi
}



#################################
# System
#################################
# alias df='df -Tha --total'
# alias du='du -ach | sort -h'
alias free='free -mt'
# alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias ps_grep='ps aux | grep -v grep | grep'
function kill_grep(){ # kill using greep return
  ID_PROCESS=$(ps_grep $1|awk '{print $2}')
  kill -9 $ID_PROCESS
}
# function restart_linux_cam(){ sudo rmmod -v uvcvideo && sudo modprobe -v uvcvideo; }
alias restart_mac_cam='sudo killall VDCAssistant'



#################################
# Miscellaneous
#################################
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias histg='history | grep'
alias webify='mogrify -resize 690\> *.png'
alias bash_aliases='exec zsh'
alias dcomp='docker-compose'
alias grep_inside='grep -rnw . -e'
alias find_file='find . -name'
alias rm_dir='rm -Rf'
function find_rm(){ # find and remove
  find_file $1 -print0|xargs -0 rm
}
function docker_bash(){ # up the container and enter in bash of it
  docker exec -it $1 bash
}

function curl_json(){
  curl $*|python -m json.tool
}
function java_switch () { # Swith java version java_switch -v 1.7
  VERSION=$2
  [ -z "$VERSION" ] && VERSION=$1
  export JAVA_HOME=`/usr/libexec/java_home -v ${VERSION}`
  echo "JAVA_HOME:" $JAVA_HOME
  echo "java -version:"
  java -version
}



#################################
# Functions
#################################
function lovedcmd {
	history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
}
function randpw(){ LC_CTYPE=C tr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= < /dev/urandom | head -c 12 | xargs; }



#################################
# Git
#################################
alias g.a='git add'
alias g.c='git commit'
alias g.c.redu='git commit --amend' #git remake commit, contat stashed with last commit and open last comment
alias g.c.undu='git reset --soft HEAD~' #git revert last commit
alias g.g='gitg'
alias g.k='gitk'
alias g.m='git mv'
alias g.o='gource -s 0.5 --hide dirnames,filenames --follow-user alannv'
alias g.p='git push'
alias g.p.force='git push --force-with-lease'
alias g.r.c='git rm --cached'
alias g.r='git rm'
alias g.s='git status'
alias g.u='git fetch --all --prune'
alias g.pull='git pull --rebase'
alias g.push='git push'
function g.c.redu2(){ # git revert commit 'x' versions: g.c.redu2 number_value
  git rebase -i HEAD~$1
}
function g.t.d(){ # git delete tag and push this tag
  git tag -d $1;git push origin :refs/tags/$1
}
alias g.l='git log --graph --full-history --all --pretty=format:"%h%x09%d%x20%s"'
alias g.log_color='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'

#GIT-SVN
alias g.s.d='git svn dcommit'
alias g.s.t='git svn tag'
alias g.s.u='git svn rebase'

alias git=hub

#################################
#Run some script
#################################
alias r_text='subl'



#################################
#Connect
#################################
alias myip='curl http://ipecho.net/plain; echo'
alias vpn='/opt/cisco/anyconnect/bin/vpn'
alias vpnui='/opt/cisco/anyconnect/bin/vpnui'
alias c_wifi_stats='cat /proc/net/wireless'



#################################
# Open
#################################
alias o_file_aliases='subl ~/.bash_aliases'
alias o_file_hosts='subl /etc/hosts'
alias o_file_ssh='subl ~/.ssh/config'
alias o_file_aws='subl ~/.aws/credentials ~/.aws/config'



#################################
# Who
#################################
alias w_alias='cat $HOME/.bash_aliases | grep alias'
alias w_function='cat $HOME/.bash_aliases | grep function'



#################################
#python
#################################

alias p.env='p.env2'
alias p.env.activate='source ./.env/bin/activate'
alias p.env.deactivate='deactivate'
alias p.env2='virtualenv -p /usr/local/bin/python2 .env'
alias p.env3='virtualenv -p /usr/local/bin/python3 .env'
