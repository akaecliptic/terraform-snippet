#! /bin/bash

# fail fast on failure
set -e

## initialization

# update yum packages
yum upgrade -y
yum update -y

# create app dir
mkdir /app

## set up docker

# install docker
yum install -y docker

# install docker compose
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v5.0.2/docker-compose-linux-$(uname -m) -o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# add user to docker gorup and start service
usermod -a -G docker ec2-user
service docker start

## pulling configs from s3 and setting up

# don't worry about the details

## start

# login to ecr
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# run docker containers
docker compose -f /app/compose.yml up
