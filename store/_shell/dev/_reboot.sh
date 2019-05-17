CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/env.sh

cd $AppRoot/apps/dfs_master && MIX_ENV=$env mix ecto.create -r DfsMaster.Repo 
cd $AppRoot/apps/dfs_master && MIX_ENV=$env mix ecto.migrate -r DfsMaster.Repo

Version="$(cat $AppRoot/_build/$env/version)"

echo "正在解压 $Version"
tar -xf $AppRoot/_build/$env/release/$AppName/releases/$Version/$AppName.tar.gz -C $AppRoot/_build/$env/release/$AppName

$AppRoot/_build/$env/release/$AppName/bin/$AppName foreground