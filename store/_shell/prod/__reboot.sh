# cd /Applications/admin/apps/admin && MIX_ENV=prod mix ecto.create -r Admin.Repo 
# cd /Applications/admin/apps/admin && MIX_ENV=prod mix ecto.migrate -r Admin.Repo 

AppName=dfs_store

Version="$(cat $AppRoot/_build/prod/version)"

echo "正在解压 $Version"
tar -xf /Applications/$AppName/_build/prod/release/$AppName/releases/$Version/$AppName.tar.gz -C /Applications/$AppName/_build/prod/release/$AppName

/Applications/$AppName/_build/prod/release/$AppName/bin/$AppName foreground