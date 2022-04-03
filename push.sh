#!/bin/sh

# find _dockerfiles -type f -execdir docker push jonemo/pythonnet:{}

docker push jonemo/pythonnet:python3.8.11-mono5.20-pythonnet2.5.2
docker push jonemo/pythonnet:python3.6.14-mono5.20-pythonnet2.4.0
docker push jonemo/pythonnet:python3.5.9-mono5.20-pythonnet2.4.0
docker push jonemo/pythonnet:python2.7.18-mono5.20-pythonnet2.4.0
docker push jonemo/pythonnet:python3.7.11-mono5.20-pythonnet2.4.0
docker push jonemo/pythonnet:python3.5.9-mono5.20-pythonnet2.5.2
docker push jonemo/pythonnet:python3.8.11-mono6.12-pythonnet2.5.2
docker push jonemo/pythonnet:python2.7.18-mono5.20-pythonnet2.5.2
docker push jonemo/pythonnet:python3.7.11-mono5.20-pythonnet2.5.2