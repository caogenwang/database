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

function check() {
STORE=$1
WorkDir=$2/$1
mkdir -p $WorkDir

docker run -d \
--rm \
--ulimit core=0 \
--log-driver none \
--net=host \
-v $Project:$DockerAppDir \
-v $WorkDir/Documents:/Documents \
-v /etc/localtime:/etc/localtime \
--env STORE=$STORE \
prod_centos_hk \
elixir $DockerAppDir/shell/prod/task/check.ex
}

check dfs_store_001 /docinfs/dev001/
# check dfs_store_002 /docinfs/dev002/
# check dfs_store_003 /docinfs/dev003/
# check dfs_store_004 /docinfs/dev004/
# check dfs_store_005 /docinfs/dev005/
# check dfs_store_006 /docinfs/dev006/
# check dfs_store_007 /docinfs/dev007/

# check dfs_store_4201 /docinfs/dev4201/
# check dfs_store_4202 /docinfs/dev4202/
# check dfs_store_4203 /docinfs/dev4203/
# check dfs_store_4204 /docinfs/dev4204/
# check dfs_store_4205 /docinfs/dev4205/
# check dfs_store_4206 /docinfs/dev4206/
# check dfs_store_4207 /docinfs/dev4207/
# check dfs_store_4208 /docinfs/dev4208/
# check dfs_store_4209 /docinfs/dev4209/
# check dfs_store_4210 /docinfs/dev4210/
# check dfs_store_4211 /docinfs/dev4211/
