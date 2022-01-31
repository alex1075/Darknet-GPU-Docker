#!/bin/bash

for var in cpu cpu-noopt gpu gpu-cc53 gpu-cc60 gpu-cc61 gpu-cc62 gpu-cc70 gpu-cc72 gpu-cc75 \
          cpu-cv cpu-noopt-cv gpu-cv gpu-cv-cc53 gpu-cv-cc60 gpu-cv-cc61 gpu-cv-cc62 gpu-cv-cc70 gpu-cv-cc72 gpu-cv-cc75
do
  DOCKER_REPO="alex1075/phd"
  SOURCE_BRANCH="main"
  SOURCE_COMMIT=`git ls-remote https://github.com/alex1075/darknet.git ${SOURCE_BRANCH} | awk '{ print $1 }'`
  DOCKER_TAG=$SOURCE_BRANCH-$var
  VAR=$var

  echo $DOCKER_REPO
  echo $SOURCE_BRANCH
  echo $SOURCE_COMMIT
  echo $DOCKER_TAG
  echo $VAR

echo "building gpu"
    docker build \
      --build-arg CONFIG=$VAR \
      --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
      --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
      -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile .

docker push $DOCKER_REPO:$DOCKER_TAG
done
