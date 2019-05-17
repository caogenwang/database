PWD="$( cd "$( dirname $0  )" && pwd  )"
sh $PWD/build.sh

Local_IP="$( /sbin/ifconfig -a|grep inet|grep -i 192.168|grep -v inet6|awk '{print $2}'|tr -d "addr:" )"
echo "Local_IP=$Local_IP"

Hostname="$( hostname )"
echo "Hostname=$Hostname"

CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/env.sh

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
AppDir="$( cd "$( dirname $AppDir  )" && pwd  )"
echo "AppDir=$AppDir"



function create() {
Docker_name=$1
WorkDir=$2
mkdir -p $WorkDir

echo "$SERVER_URL"

docker stop $Docker_name
docker rm $Docker_name
docker run -it \
--name $Docker_name \
--restart=always \
--ulimit core=0 \
--log-driver none \
--net=host \
-v $Project:$AppRoot \
-v $AppDir:/Applications \
-v $AppDir/pdf_web:/Applications/pdf_web \
-v $WorkDir/Documents:/Documents \
-v $WorkDir/System:/System \
-v /etc/localtime:/etc/localtime \
--env Local_IP=$Local_IP \
--env REPLACE_OS_VARS=true \
prod_centos_hk \
sh $AppRoot/shell/$env/_reboot.sh
}

create $Docker_name $Project/docker-test/$Docker_name

