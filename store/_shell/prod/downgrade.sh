Docker_name=myProject_40
DockerAppDir=/Applications/app_root
App_name=myProject
Bin=$DockerAppDir/_build/prod/release/$App_name/bin/$App_name

Version=$1
docker exec -it $Docker_name $Bin downgrade $Version