CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"

export env=dev
export AppName=dfs_master
export AppPath=$AppName
export Docker_name=dev_dfs_master
export SERVER_NAME=dev_dfs_master
export AppRoot=$CurrentDir/../../
export PORT=14001
export MY_NODE_NAME=$PORT@$Local_IP
export SWAGGER_URL="http://localhost:14001"
export DENGTA_URL="http://localhost:15600/api/services"
export SERVER_URL="http://$Local_IP:$PORT"
export REPLACE_OS_VARS=true 