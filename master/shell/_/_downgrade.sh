CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/../$ENV_FILE

Bin=$AppRoot/_build/$env/release/$App_name/bin/$App_name

Version=$1
docker exec -it $Docker_name $Bin downgrade $Version