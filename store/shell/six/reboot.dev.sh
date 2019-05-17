ENV_FILE=six/env.dev.sh

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

function create() {
Docker_name=$1
WorkDir=$2
sudo mkdir -p $WorkDir

docker stop $Docker_name
docker rm $Docker_name
docker run -it \
--name $Docker_name \
--restart=always \
--ulimit core=0 \
--log-driver none \
-p 18601:18601 \
-v $Applications:/Applications \
-v $Applications/pdf2htmlEX:/Applications/pdf2htmlEX \
-v $Applications/pdf2htmlEX/poppler-data:/usr/local/share/poppler \
-v /dev/shm/$Docker_name:/tmpfs \
-v $WorkDir/Documents:/Documents \
-v $WorkDir/System:/System \
-v /etc/:/etc/ \
--env Local_IP=$Local_IP \
--env ENV_FILE=$ENV_FILE \
prod_centos_hk \
sh $AppRoot/shell/_/_reboot.sh
}

create $Docker_name $Project/docker-test/$Docker_name

