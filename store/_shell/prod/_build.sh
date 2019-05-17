AppName=dfs_store
AppRoot=/Applications/$AppName
configFile=$AppRoot/rel/config.exs

echo "AppRoot : $AppRoot"
echo "make sure version"
cd $AppRoot && elixir rel/version_update.ex

cd $AppRoot && MIX_ENV=prod mix deps.get
# HEX_MIRROR=https://hexpm.upyun.com mix deps.get

if [ -f "$configFile" ]; then
    echo "$configFile exist, no need to release.init"
    touch "$configFile"
else
    echo "mix release.init"
    mix release.init
fi

echo "start build"

MIX_ENV=prod mix release --verbose --env=prod --upgrade

Version="$(cat $AppRoot/_build/prod/version)"

echo "start copy rel to release"
mkdir -p $AppRoot/_build/prod/release/$AppName/releases/$Version/ && \
cp -r $AppRoot/_build/prod/rel/$AppName/releases/$Version/$AppName.tar.gz $AppRoot/_build/prod/release/$AppName/releases/$Version/$AppName.tar.gz

