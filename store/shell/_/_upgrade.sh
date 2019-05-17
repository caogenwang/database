CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/../$ENV_FILE

Bin=$AppRoot/_build/$env/release/$AppName/bin/$AppName
Version="$(cat $AppRoot/_build/$env/version)"

$Bin upgrade $Version