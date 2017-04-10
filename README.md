# docker-actdr
A dockerfile for a container that provides a simple HTTP grading interface

LICENSE: https://creativecommons.org/licenses/by-sa/4.0/legalcode
CC-4.0-SA

Author(s): [Tristan Swedish](www.tswedish.com)

## Getting Started

To get running right away, use the pre-built image:
~~~~
docker pull tswedish/actdr
docker run -d tswedish/actdr
~~~~

Once the image is up and running we can send it an image using curl:

~~~~
curl -F file=@input_image.png $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q)):8910/predict
~~~~

We can send png and jpg image, with any filename, specified as 'input_image.png' above. You should receive a JSON response with the prediction. If "success: false" in the returned JSON, something bad happened to the model, check that there is nothing wrong with the input file.


## Building and Installing directly

To build, run the following in the repo:
~~~~
docker build -t actdr .
~~~~

## Acknowledgements

Thanks to the wonderful [tutorial](https://aimbrain.com/blog/serving-deep-learning-models-with-nginx-torch/) by [aimbrain](https://aimbrain.com). This repo borrows heavily from [actDR](https://github.com/OpenEye-Dev/actDR) with further integration/overlap planned for the future. actDR was used to generate a [production model](https://www.zenodo.org/record/495797) made available on [zenmodo](www.zenodo.org). Please cite this repository if you use this work in academic work.
