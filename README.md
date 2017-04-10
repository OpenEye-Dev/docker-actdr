# docker-actdr
A dockerfile for a container that provides a simple HTTP grading interface

LICENSE: https://creativecommons.org/licenses/by-sa/4.0/legalcode
CC-4.0-SA

Also on hub.docker.com:

To get running right away, use the pre-built image:
~~~~
docker pull tswedish/actdr
~~~~

Once the image is up and running we can send it an image using curl:

~~~~
curl -F file=@input_image.png $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q)):8910/predict
~~~~

We can send png and jpg image, with any filename, specified as 'input_image.png' above.
