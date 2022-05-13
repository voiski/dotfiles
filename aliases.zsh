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
alias bash='/usr/local/bin/bash'



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
function restart_linux_cam(){ sudo rmmod -v uvcvideo && sudo modprobe -v uvcvideo; }
alias restart_mac_cam='sudo killall VDCAssistant'
alias zreset='source ~/.zshrc'



#################################
# Miscellaneous
#################################
alias asciicast2gif='time docker run --rm -v $PWD:/data asciinema/asciicast2gif'
alias bash_aliases='exec zsh'
alias grep_inside='grep -rnw . -e'
alias mkdir='mkdir -pv'
alias rm_dir='rm -Rf'
alias webify='mogrify -resize 690\> *.png'
alias wget='wget -c'
alias brewv="curl -s https://gist.githubusercontent.com/voiski/973ec1fe0e4b05d52133c9d0438eb2de/raw//brewv.sh | bash -s"

function bash-record-asciinema(){ # bash-record-asciinema cast_name no_override:optional
	[ -z "$1" ] && echo "Usage: $0 <name>" && return 1
	local cast_file="$1"
	if [ -f $cast_file ] && [ "$2" != "" ];then
		echo "File ${cast_file} already exist!"
		return 215
	fi
	asciinema rec $cast_file -y --overwrite
	grep "." $cast_file| tail -2 | grep exit | grep 1001 &> /dev/null && return 1001 || true
}

function bash-play(){ # bash-play cast_name
	[ -z "$1" ] && echo "Usage: $0 <name>" && return 1
	local cast_file="$1"
	asciinema play --idle-time-limit=1 --speed=${2:-5} $cast_file
}

function bash-record(){ # bash-record final_gif_name speed:optional cast_file:optional
	[ -z "$1" ] && echo "Usage: $0 <name>" && return 1
	local cast_file=${3:-/tmp/$1.cast}
	(bash-record-asciinema $cast_file ${3} || [ $? = 215 ]) || return 1
	time docker run --rm -v $(dirname $cast_file):/tmp -v $PWD:/data asciinema/asciicast2gif \
		-s ${2:-10} \
		-S 1 \
		$cast_file "./$1.gif"
	# https://www.robinstewart.com/blog/2018/10/adding-a-delay-to-the-end-of-an-animated-gif/
	if command -v gifsicle &>/dev/null
	then gifsicle -U $1.gif "#0--2" -d100 "#-1" -O2 > $1-optimised.gif
	fi
}

function bash-record-svg(){ # bash-record final_gif_name speed:optional cast_file:optional
	[ -z "$1" ] && echo "Usage: $0 <name>" && return 1
	local cast_file=${3:-/tmp/$1.cast}
	(bash-record-asciinema $cast_file ${3} || [ $? = 215 ]) || return 1
	time docker run --rm -v $(dirname $cast_file):/tmp -v $PWD:/data voiski/svg-term-cli \
		--in "/tmp/$1.cast" --out "/data/$1.svg"
		# Missing speed
}

function screen-record-gif(){ # screen-record-gif in.mov speed:optional scale:optional
	[ -z "$1" ] && echo "Usage: $0 <mov name>" && return 1
	local mov_file=$1
	! [ -f "${mov_file}" ] && echo "Error: File ${mov_file} not found!" && return 1
	local rate=${2:-10}
	local scale=${3:-600}
	local gif_file=${mov_file%%.*}.gif
	local size=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 ${mov_file})
	local height=$((${scale}*${size##*x}/${size%%x*}))
	rm -f "${gif_file}"
	ffmpeg -i "${mov_file}" -s ${scale}x${height} -pix_fmt rgb24 -r ${rate} -f gif - | gifsicle --optimize=3 --delay=3 > "${gif_file}"
}

function docker_bash(){ # up the container and enter in bash of it
  docker exec -it $1 bash
}

function docker_run(){ # docker_run [yourimage] <optional:bash> # start a container with given image
	docker run --rm -it -v $(pwd):/app -w /app $*
}

function docker_log(){ # internal logs
	local pred='process matches ".*(ocker|vpnkit).*"
  || (process in {"taskgated-helper", "launchservicesd", "kernel"} && eventMessage contains[c] "docker")'
	/usr/bin/log stream --style syslog --level=debug --color=always --predicate "$pred"
}

function docker_rmi(){ # iterative docker image deletion
  function docker_df:image(){ docker system df|grep 'Images' | awk '{print $4}' }
	local before=$(docker_df:image)
	for image in $(docker images --format "[{{.ID}}]{{.Repository}}:{{.Tag}}")
	do printf "Delete ${image}?[y]" \
		&& read -r response \
		&& [ "${response}" = 'y' ] \
		&& docker rmi ${image#*]} \
		|| true
	done
	local after=$(docker_df:image)
	local saved=$((${before%GB}-${after%GB}))
	echo "
	Saved size: $(printf "%.3f" "$saved")GB
	Before: ${before}
	After: ${after}
	"
}

function docker_rmv(){ # iterative docker volume deletion
  function docker_df:volume(){ docker system df|grep 'Local Volumes' | awk '{print $5}' }
  local before=$(docker_df:volume)
  for volume in $(docker volume ls --format "{{.Name}}")
  do printf "Delete ${volume}?[y]" \
    && read -r response \
    && [ "${response}" = 'y' ] \
    && docker volume rm ${volume#*]} \
    || true
  done
  local after=$(docker_df:volume)
  local saved=$((${before%GB}-${after%GB}))
  echo "
  Saved size: $(printf "%.3f" "$saved")GB
  Before: ${before}
  After: ${after}
  "
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

function kubectl_token() { # kubectl user credentials with OIDC
  current_context=$(kubectl config current-context)
	user_id=$(kubectl config view -o jsonpath="{.contexts[?(@.name == \"${current_context}\")].context.user}")
	admin_user=$(kubectl config view -o jsonpath="{.users[?(@.name == \"${current_context}\")].user.username}")
	admin_password=$(kubectl config view -o jsonpath="{.users[?(@.name == \"${current_context}\")].user.password}")
	user_token=$(kubectl config view -o jsonpath="{.users[?(@.name == \"${user_id}\")].user.auth-provider.config.id-token}")
  echo "Current context: $current_context
  admin> user ${admin_user:-admin}: ${admin_password:-'n/a'}
  OIDC> user ${user_id}: ${user_token}
  "
}

function awstags(){ # get tags from ip
	[ -z "$1" ] && echo "Usage: $0 <ip>" && return 1
	local ip=$1
	local profile=""
	[ -z "$2" ] || profile="--profile $2"
	aws ec2 ${profile}\
		--region us-east-1 describe-instances \
		--filters Name=private-ip-address,Values=${ip} \
		| jq -r ".Reservations[0].Instances[0].Tags"
}

alias k="kubectl"

function cheat(){ # cheat https://github.com/chubin/cheat.sh
	local x=${@:2}
	curl https://cheat.sh/$1/${x/ /+}
}

#################################
# Functions
#################################
function lovedcmd {
	history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
}
function randpw(){ LC_ALL=C tr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= < /dev/urandom | head -c 12 | xargs; }



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

#################################
# Run some script
#################################
alias r_text='subl'



#################################
# Connect
#################################
alias myip='curl http://ipecho.net/plain; echo'
alias vpn='/opt/cisco/anyconnect/bin/vpn'
alias vpnui='/opt/cisco/anyconnect/bin/vpnui'
alias c_wifi_stats='cat /proc/net/wireless'



#################################
# Open
#################################
alias o_file_aliases='r_text ~/.dotfiles'
alias o_file_hosts='r_text /etc/hosts'
alias o_file_resolver='r_text /etc/resolv.conf'
alias o_file_ssh='r_text ~/.ssh/config'
alias o_file_kube='r_text ~/.kube/config'
alias o_file_aws='r_text ~/.aws/credentials ~/.aws/config'



#################################
# Who
#################################
alias w_alias='cat $HOME/.dotfiles/aliases.zsh | grep alias'
alias w_function='cat $HOME/.dotfiles/aliases.zsh | grep function'



#################################
# python
#################################

alias p.env='p.env2'
alias p.env.activate='source ./.penv/bin/activate'
alias p.env.deactivate='deactivate'
alias p.env2='virtualenv -p /usr/local/bin/python2 .penv'
alias p.env3='virtualenv -p /usr/local/bin/python3 .penv'

#################################
# file mapping
#################################
alias -s {yml,yaml}=code

#################################
# pomodoro
#################################
function pomo(){
	function _pomo_file(){
		local t=${1:-$(date +%Y%m%d)}
		echo ~/.pomo/pomo_${t}.yml
	}

	function _pomo_start_round(){
		local round=${1:-1}
		if ! [ -f ${today_pomo} ];then
			echo "date: $(date +%A\ %b.\ %e,\ %Y)" > ${today_pomo}
			echo "sessions:" >> ${today_pomo}
		fi
		echo "Starting new round ${round}"
		echo "- round `date +%H:%M`:" >> ${today_pomo}
		_pomo_start_15 short ${today_pomo}
		_pomo_start_15 short ${today_pomo}
		_pomo_start_15 short ${today_pomo}
		_pomo_start_15 LONG ${today_pomo} 15
		# 8h of work, 4 rounds is more then enough
		if [ ${round} -gt 4 ];then
			_pomo_notification "Last round, stopping..." alert Sosumi
			return 0
		fi
		(( round+=1 ))
		_pomo_start_round ${round}
	}

	function _pomo_start_15(){
		date::guard
		local break_type=$1
		local today_pomo=$2
		local break_time=${3:-5}
		local start=`date +%H:%M:%S`

		echo "  - start: ${start}" >> ${today_pomo}
		_pomo_session 25 work "New pomo starting ${start}"
		echo "    done: `date +%H:%M:%S`" >> ${today_pomo}

		_pomo_session ${break_time} "break" "Pomo done, take a ${break_type} break" alert
	}

	function _pomo_est(){
		echo "est `date -v+${1}M +'%H:%M'`"
	}

	function _pomo_session(){
		local duration=$1
		local duration_secs=$((duration*60))
		local ctx=$2
		local msg=$3
		local act=${4}

		local est=$(_pomo_est ${duration})
		_pomo_notification "${msg} - ${duration} minutes duration - ${est}" ${act} Glass

		sleep $((duration_secs-25))
		_pomo_notification "25 secs to finish ${ctx} - ${est}"
		sleep 25
	}

	function _pomo_notification(){
		local msg=${1}
		local act=${2}
		local sound=${3:-Tink}
		osascript -e "display notification \"${msg}\" with title \"Pomodoro\" sound name \"${sound}\""
		if [ "${act}" = "alert" ]
		then local r=$(osascript -e "display alert \"Pomodoro\" message \"${msg}\"")
		fi
	}

	function date::guard() {
		local current_date=$(date::string)
		if [ "${current_date}" = "${start_date}" ]
		then return
		fi
		local msg="It is now a new day[${current_date}], stopping ${start_date} pomo session..."
		_pomo_notification ${msg} alert Sosumi &
		echo ${msg}
		echo 'Existing pomo, Start a new one if you like with "pomo s"'
		exit 1
	}

	function date::string(){
		date +%b.\ %e,\ %Y
	}

	local start_date=$(date::string)
	local action=$1
	local today_pomo=$(_pomo_file ${2})
	local monthly_interruptions=~/.pomo/interruptions_`date +%Y%m_%B`.yml
	case "${action}" in
		edit|e)
			eval "${VISUAL} ${today_pomo}"
			;;
		interruption|i)
			echo "- `date`" >>! ${monthly_interruptions}
			if [ -f ${today_pomo} ] && ! tail -1 ${today_pomo} | grep interruption &>/dev/null; then
				echo "    interruption: `date +%H:%M:%S`" >> ${today_pomo}
			fi
			;;
		interruptions) [ -f ${monthly_interruptions} ] && yq e -C ${monthly_interruptions} || echo "No interruption this month!";;
		list|ls|l) ls -1 ~/.pomo/pomo_* | xargs -L 1 basename | cut -b 6-13 | xargs -I {} echo "pomo p {}";;
		start|s) echo "type fg and ctrl+c to STOP!" && _pomo_start_round &;;
		description|d)
			today_pomo=$(_pomo_file)
			shift
			local description="${@}"
			if [ -f ${today_pomo} ] && ! tail -1 ${today_pomo} | grep description &>/dev/null; then
				echo "    description: ${description}" >> ${today_pomo}
			fi
			;;
		print|p|) [ -f ${today_pomo} ] && yq e -C ${today_pomo} || echo "No pomo yet!";;
		*)
			echo 'pomo [action] [arg]
Ex:
	pomo i # registry interruptions in current round and in monthly register
	pomo interruptions # print monthly interruptions
	pomo s # start new pomodoro session stopping automatically at the 4th round
	pomo d my task # add description to the running round
	pomo l # list existing pomo sessions already giving the command for more details
	pomo # prints the current pomo session
	pomo p 20200326 # prints the given pomo session - date id
'
			;;
	esac
}

#################################
# https://opensource.com/article/18/9/tips-productivity-zsh
# alias -g G='| grep -i'
