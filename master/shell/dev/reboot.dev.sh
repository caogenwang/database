git pull
ENV_FILE=dev/env.dev.sh

CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/../$ENV_FILE

# sh $CurrentDir/build.$env.sh

Local_IP="$( /sbin/ifconfig -a|grep inet|grep -i 192.168|grep -v inet6|awk '{print $2}'|tr -d "addr:" )"
echo "Local_IP=$Local_IP"

Applications=$0
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
echo "Applications=$Applications"

# Version="$(cat $Applications/$AppPath/_build/$env/version)"
# tarFile=$Applications/$AppPath/_build/$env/release/$AppName/releases/$Version/$AppName.tar.gz
# if [ -f "$tarFile" ]; then
#     echo "$tarFile exist"
# else
#     echo "$tarFile not exist"
#     exit
# fi

function create() {
Docker_name=$1
WorkDir=$2
mkdir -p $WorkDir

docker stop $Docker_name
docker rm $Docker_name
docker run -it \
--name $Docker_name \
--restart=always \
--ulimit core=0 \
--log-driver none \
-p $PORT:$PORT \
-v $Applications:/Applications \
-v $Applications/pdf2htmlEX:/Applications/pdf2htmlEX \
-v $Applications/pdf2htmlEX/poppler-data:/usr/local/share/poppler \
-v /dev/shm/$Docker_name:/tmpfs \
-v $WorkDir/Documents:/Documents \
-v $WorkDir/System:/System \
-v /etc/localtime:/etc/localtime \
--env Local_IP=$Local_IP \
--env ENV_FILE=$ENV_FILE \
prod_centos_hk \
sh $AppRoot/shell/_/_reboot.sh
}

create $Docker_name $Applications/$AppPath/docker-test/$Docker_name

