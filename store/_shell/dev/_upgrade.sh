CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/env.sh

Bin=$AppRoot/_build/$env/release/$AppName/bin/$AppName
Version="$(cat $AppRoot/_build/$env/version)"

$Bin upgrade $Version