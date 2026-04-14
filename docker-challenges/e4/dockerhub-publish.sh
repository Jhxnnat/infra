#!/usr/bin/bash

set -xe
echo "version/tag to push:"
read version
docker build -t jhxnnat/flask-app:$version .
docker tag jhxnnat/flask-app:$version jhxnnat/flask-app:latest
docker push jhxnnat/flask-app:$version
docker push jhxnnat/flask-app:latest

