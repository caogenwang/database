ENV_FILE=local/env.sh

CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/../$ENV_FILE

Local_IP="$( /sbin/ifconfig -a|grep inet|grep -i 192.168|grep -v inet6|awk '{print $2}'|tr -d "addr:" )"
echo "Local_IP=$Local_IP"

Applications=$0
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
echo "AppDir=$Applications"

function create() {
Docker_name=$1
WorkDir=$2
echo "WorkDir=$WorkDir"
mkdir -p $WorkDir

docker run -it \
--rm \
--ulimit core=0 \
--log-driver none \
-p $PORT:$PORT \
-v $Applications:/Applications \
-v $WorkDir/Documents:/Documents \
-v $WorkDir/System:/System \
-v /etc/:/etc/ \
-v $HOME/.hex:/root/.hex \
-v $HOME/.cache/rebar3:/root/.cache/rebar3 \
--env Local_IP=$Local_IP \
--env ENV_FILE=$ENV_FILE \
prod_centos_hk \
/bin/bash
# sh $AppRoot/shell/local/_reboot.sh
}

create $Docker_name $Applications/$AppPath/docker-test/$Docker_name

