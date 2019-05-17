oldPWD="$( pwd )"
PWD="$( cd "$( dirname $0  )" && pwd  )"
echo "PWD=$PWD"
cd $PWD && git pull && cd $oldPWD

Docker_name=build_store
DockerAppDir=/Applications/dfs_store

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

docker stop $Docker_name
docker rm $Docker_name
docker run -it \
--name $Docker_name \
--rm \
-v $Project:$DockerAppDir \
-v $AppDir:/Applications \
-v $HOME/.hex:/root/.hex \
-v $HOME/.cache/rebar3:/root/.cache/rebar3 \
prod_centos_hk \
sh $DockerAppDir/shell/prod/_build.sh
