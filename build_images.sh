#!/bin/sh

docker build -f python3.6.4-mono5.4.1.6-pythonnet2.4.0.dev0.Dockerfile -t jonemo/pythonnet:python3.6.4-mono5.4.1.6-pythonnet2.4.0.dev0 .
docker build -f python3.6.4-mono5.2.0.224-pythonnet2.4.0.dev0.Dockerfile -t jonemo/pythonnet:python3.6.4-mono5.2.0.224-pythonnet2.4.0.dev0 .
docker build -f python3.6.4-mono4.8.0.524-pythonnet2.4.0.dev0.Dockerfile -t jonemo/pythonnet:python3.6.4-mono4.8.0.524-pythonnet2.4.0.dev0 .
docker build -f python3.6.4-mono4.8.0.524-pythonnet2.3.0.Dockerfile -t jonemo/pythonnet:python3.6.4-mono4.8.0.524-pythonnet2.3.0 .

docker build -f python2.7.14-mono4.8.0.524-pythonnet2.3.0.Dockerfile -t jonemo/pythonnet:python2.7.14-mono4.8.0.524-pythonnet2.3.0 .
docker build -f python2.7.14-mono4.8.0.524-pythonnet2.4.0.dev0.Dockerfile -t jonemo/pythonnet:python2.7.14-mono4.8.0.524-pythonnet2.4.0.dev0 .
docker build -f python2.7.14-mono5.2.0.224-pythonnet2.4.0.dev0.Dockerfile -t jonemo/pythonnet:python2.7.14-mono5.2.0.224-pythonnet2.4.0.dev0 .
docker build -f python2.7.14-mono5.4.1.6-pythonnet2.4.0.dev0.Dockerfile -t jonemo/pythonnet:python2.7.14-mono5.4.1.6-pythonnet2.4.0.dev0 .
