
git pull

ENV_FILE=prod/env.prod.sh

CurrentDir=$0
CurrentDir="$( cd "$( dirname $CurrentDir  )" && pwd  )"
echo "CurrentDir=$CurrentDir"

source $CurrentDir/../$ENV_FILE

Applications=$0
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
Applications="$( cd "$( dirname $Applications  )" && pwd  )"
echo "Applications=$Applications"

docker run -it \
--rm \
-v $Applications:/Applications \
-v $HOME/.hex:/root/.hex \
-v $HOME/.cache/rebar3:/root/.cache/rebar3 \
--env ENV_FILE=$ENV_FILE \
prod_centos_hk \
sh $AppRoot/shell/_/_build.sh
