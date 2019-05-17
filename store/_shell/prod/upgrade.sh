PWD="$( cd "$( dirname $0  )" && pwd  )"
sh $PWD/build.sh

docker exec -it dfs_store sh /Applications/dfs_store/shell/prod/_upgrade.sh 

