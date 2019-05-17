PWD="$( cd "$( dirname $0  )" && pwd  )"
sh $PWD/build.sh

PWD="$( cd "$( dirname $0  )" && pwd  )"
source $PWD/_reboot.sh

create dfs_store_4201 4401 /docinfs/dev4201
create dfs_store_4202 4402 /docinfs/dev4202
create dfs_store_4203 4403 /docinfs/dev4203
create dfs_store_4204 4404 /docinfs/dev4204
create dfs_store_4205 4405 /docinfs/dev4205
create dfs_store_4206 4406 /docinfs/dev4206
create dfs_store_4207 4407 /docinfs/dev4207
create dfs_store_4208 4408 /docinfs/dev4208
create dfs_store_4209 4409 /docinfs/dev4209
create dfs_store_4210 4410 /docinfs/dev4210
create dfs_store_4211 4411 /docinfs/dev4211

