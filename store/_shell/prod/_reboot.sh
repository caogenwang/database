Local_IP="$( /sbin/ifconfig -a|grep inet|grep -i 192.168|grep -v inet6|awk '{print $2}'|tr -d "addr:" )"
echo "Local_IP=$Local_IP"

Hostname="$( hostname )"
echo "Hostname=$Hostname"

Project=$0
Project="$( cd "$( dirname $Project  )" && pwd  )"
Project="$( cd "$( dirname $Project  )" && pwd  )"
Project="$( cd "$( dirname $Project  )" && pwd  )"
echo "Project=$Project"

AppDir=$0
AppDir="$( cd "$( dirname $AppDir  )" && pwd  )"
AppDir="$( cd "$( dirname $AppDir  )" && pwd  )"
AppDir="$( cd "$( dirname $AppDir  )" && pwd  )"
AppDir="$( cd "$( dirname $AppDir  )" && pwd  )"
echo "AppDir=$AppDir"

DockerAppDir=/Applications/dfs_store
App_name=dfs_store

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
-v $Project:$DockerAppDir \
-v $WorkDir/Documents:/Documents \
-v $WorkDir/System:/System \
-v /etc/localtime:/etc/localtime \
--env PORT=$Port \
--env MY_NODE_NAME=dfs_store@127.0.0.1 \
--env SERVER_NAME=$Docker_name \
--env REPLACE_OS_VARS=true \
--env MASTER_NODE=$MasterNode \
--env SERVER_URL="http://$Local_IP:$Port" \
--env DENGTA_URL="http://192.168.4.39:5600/api/services" \
prod_centos_hk \
sh $DockerAppDir/shell/prod/__reboot.sh
}

