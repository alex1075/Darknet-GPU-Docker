#!/bin/bash
echo "Building and pushing to Dockerhub"
echo "Building image"
docker build -t alex1075/phd:darknetty . --platform linux/amd64
echo " "
echo " "
echo " "
ehco "Build complete"
echo "Pushing to Dockerhub"
docker push alex1075/phd:darknetty
echo "Push complete"

