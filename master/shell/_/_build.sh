CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/../$ENV_FILE

configFile=$AppRoot/rel/config.exs

echo "make sure version"
cd $AppRoot && env=$env elixir rel/version_update.ex

cd $AppRoot && MIX_ENV=$env HEX_MIRROR=https://hexpm.upyun.com mix deps.get

# cd $AppRoot && MIX_ENV=$env mix ecto.create -r DfsMaster.Repo
# cd $AppRoot && MIX_ENV=$env mix ecto.migrate -r DfsMaster.Repo 

if [ -f "$configFile" ]; then
    echo "$configFile exist, no need to release.init"
    touch "$configFile"
else
    echo "mix release.init"
    mix release.init
fi

echo "start build"

MIX_ENV=$env mix release --verbose --env=prod --upgrade

Version="$(cat $AppRoot/_build/$env/version)"

echo "start copy rel to release"
mkdir -p $AppRoot/_build/$env/release/$AppName/releases/$Version/ 
cp -r $AppRoot/_build/$env/rel/$AppName/releases/$Version/$AppName.tar.gz $AppRoot/_build/$env/release/$AppName/releases/$Version/$AppName.tar.gz

