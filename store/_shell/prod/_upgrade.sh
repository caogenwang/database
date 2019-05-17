AppName=dfs_store
DockerAppDir=/Applications/$AppName
Bin=$DockerAppDir/_build/prod/release/$AppName/bin/$AppName
Version="$(cat $AppRoot/_build/prod/version)"

$Bin upgrade $Version