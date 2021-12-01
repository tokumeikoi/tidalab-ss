#!/bin/sh

docker build -t tokumeikoi/tidalab-ss:latest-amd64 --build-arg ARCH=amd64 .
docker push tokumeikoi/tidalab-ss:latest-amd64

docker build -t tokumeikoi/tidalab-ss:latest-arm64 --build-arg ARCH=arm64 .
docker push tokumeikoi/tidalab-ss:latest-arm64

docker manifest create \
tokumeikoi/tidalab-ss:latest \
--amend tokumeikoi/tidalab-ss:latest-amd64 \
--amend tokumeikoi/tidalab-ss:latest-arm64