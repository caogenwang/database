CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/env.sh

cd $AppRoot && env=$env elixir rel/version_update.ex

cd $AppRoot && mix deps.get

cd $AppRoot && MIX_ENV=dev mix ecto.create -r DfsMaster.Repo
cd $AppRoot && MIX_ENV=dev mix ecto.migrate -r DfsMaster.Repo 

cd $AppRoot && mix phx.server