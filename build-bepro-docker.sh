#!/bin/bash -e

# Parse command line arguments.
prune=false
push=false
for key in "$@"
do
    case $key in
        --prune) prune=true ;;
        --push) push=true ;;
    esac
done

# Read the project version.
PROJECT_VERSION="$(cat ./tensorflow_cc/PROJECT_VERSION)"

tag=ubuntu-cuda

docker build --pull -t bepro/tensorflow_cc:${tag} -f Dockerfiles/${tag} .
docker tag bepro/tensorflow_cc:${tag} bepro/tensorflow_cc:${tag}-"${PROJECT_VERSION}"

if $push
then
    docker push bepro/tensorflow_cc:${tag}
    docker push bepro/tensorflow_cc:${tag}-"${PROJECT_VERSION}"
fi

if $prune
then
    docker rmi bepro/tensorflow_cc:${tag}
    docker rmi bepro/tensorflow_cc:${tag}-"${PROJECT_VERSION}"
    docker system prune -af
fi
