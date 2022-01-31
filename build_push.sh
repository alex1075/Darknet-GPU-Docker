#!/bin/bash
echo "Building and pushing to Dockerhub"
echo "Building image"
docker build -t alex1075/phd:darknet . --platform linux/amd64
eho "Build complete"
echo "Pushing to Dockerhub"
docker push alex1075:phd:darknet
echo "Push complete"

