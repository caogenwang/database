PWD="$( cd "$( dirname $0  )" && pwd  )"
sh $PWD/build.sh

CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/env.sh

docker exec -it $Docker_name sh $AppRoot/shell/$env/_upgrade.sh 

