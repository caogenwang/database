HOSTNAME="$( hostname )"
ENV_FILE=prod/env.prod.sh

CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/../$ENV_FILE

sh $CurrentDir/build.$env.sh

Local_IP="$( /sbin/ifconfig -a|grep inet|grep -i 192.168|grep -v inet6|awk '{print $2}'|tr -d "addr:" )"
echo "Local_IP=$Local_IP"

Applications=$0
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
echo "Applications=$Applications"

Version="$(cat $Applications/$AppPath/_build/$env/version)"
tarFile=$Applications/$AppPath/_build/$env/release/$AppName/releases/$Version/$AppName.tar.gz
if [ -f "$tarFile" ]; then
    echo "$tarFile exist"
else
    echo "$tarFile not exist"
    exit
fi

function create() {
Docker_name=$1
Port=$2
WorkDir=$3/$1
mkdir -p $WorkDir

docker stop $Docker_name
docker rm $Docker_name
docker run -d \
--name $Docker_name \
--restart=always \
--ulimit core=0 \
--log-driver none \
-p $Port:$Port \
-v $Applications:/Applications \
-v $WorkDir/Documents:/Documents \
-v $WorkDir/System:/System \
-v /etc/localtime:/etc/localtime \
--env PORT=$Port \
--env MY_NODE_NAME=dfs_store@127.0.0.1 \
--env SERVER_NAME=$Docker_name \
--env Local_IP=$Local_IP \
--env ENV_FILE=$ENV_FILE \
prod_centos_hk \
sh $AppRoot/shell/_/_reboot.sh
}