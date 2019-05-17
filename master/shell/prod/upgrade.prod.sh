HOSTNAME="$( hostname )"
ENV_FILE=prod/env.$HOSTNAME.sh

CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/../$ENV_FILE

sh $CurrentDir/build.$env.sh

docker exec -it $Docker_name sh $AppRoot/shell/_/_upgrade.sh 

