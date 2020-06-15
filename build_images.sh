#!/bin/sh

docker build -f python3.7.4-mono5.18.1-pythonnet2.4.0.Dockerfile -t python3.7.4-mono5.18.1-pythonnet2.4.0 .

pushd _dockerfiles
find . -type f -execdir docker build -f {} -t {} . \;
popd