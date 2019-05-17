git pull

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

docker run -it \
--rm \
-v $Project:$AppRoot \
-v $AppDir:/Applications \
-v $HOME/.hex:/root/.hex \
-v $HOME/.cache/rebar3:/root/.cache/rebar3 \
--env env=$env \
--env AppName=$AppName \
--env PORT=$PORT \
--env REPLACE_OS_VARS=true \
--env MY_NODE_NAME=$Port@$Local_IP \
--env SERVER_NAME=$Docker_name \
--env SERVER_URL="http://$Local_IP:$Port" \
--env DENGTA_URL=$DENGTA_URL \
--env SWAGGER_URL=$SWAGGER_URL \
prod_centos_hk \
sh $AppRoot/shell/$env/_build.sh
# /bin/bash
