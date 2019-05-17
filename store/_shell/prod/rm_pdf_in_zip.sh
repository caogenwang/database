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

function run() {
STORE=$1
WorkDir=$2/$1

docker run -d \
--rm \
--ulimit core=0 \
--log-driver none \
--net=host \
-v $Project:$DockerAppDir \
-v $WorkDir/Documents:/Documents \
-v /etc/localtime:/etc/localtime \
--env STORE=$STORE \
convert_pdf2html \
sh $DockerAppDir/shell/prod/task/rm_pdf_in_zip.sh
}

# run dfs_store_001 /docinfs/dev401/
# run dfs_store_002 /docinfs/dev402/
# run dfs_store_003 /docinfs/dev403/
# run dfs_store_004 /docinfs/dev404/
# run dfs_store_005 /docinfs/dev405/
# run dfs_store_006 /docinfs/dev406/
# run dfs_store_007 /docinfs/dev407/


run dfs_store_4201 /docinfs/dev4201/
run dfs_store_4202 /docinfs/dev4202/
run dfs_store_4203 /docinfs/dev4203/
run dfs_store_4204 /docinfs/dev4204/
run dfs_store_4205 /docinfs/dev4205/
run dfs_store_4206 /docinfs/dev4206/
run dfs_store_4207 /docinfs/dev4207/
run dfs_store_4208 /docinfs/dev4208/
run dfs_store_4209 /docinfs/dev4209/
run dfs_store_4210 /docinfs/dev4210/
run dfs_store_4211 /docinfs/dev4211/
