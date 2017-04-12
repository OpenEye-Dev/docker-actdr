# docker-actdr
A dockerfile for a container that provides a simple HTTP grading interface

LICENSE: https://creativecommons.org/licenses/by-sa/4.0/legalcode
CC-4.0-SA

Author(s): [Tristan Swedish](https://www.tswedish.com)

## Getting Started

To get running right away, use the pre-built image:
~~~~
docker pull tswedish/actdr
docker run -d tswedish/actdr
export ACTDR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -ql))
~~~~

Once the image is up and running we can send it an image using curl:

~~~~
export ACTDR_INPUT_IMG=input_image.png
curl -F file=@${ACTDR_INPUT_IMG} ${ACTDR_IP}:8910/predict
~~~~

We can send png and jpg image, with any filename, specified as ${INPUT_IMG} above to the container at ip ${ACTDR_IP}. You should receive a JSON response with the prediction. If "success: false" in the returned JSON, something bad happened to the model, check that there is nothing wrong with the input file.

We could also send the request using python:

Here is an example of using the python requests library to make a post request to the service. you may need to `pip install requests`. We access the environment variable set above, except this time we relay an example "healthy" image from wikipedia. The following can be pasted into the python interpretor or run as a separate file.

~~~~
import requests
import json
from io import BytesIO
import os
url = "http://"+os.environ["ACTDR_IP"]+":8910/predict"
norm_eye_url = "https://upload.wikimedia.org/wikipedia/commons/3/37/Fundus_photograph_of_normal_right_eye.jpg?download"
norm_jpg = BytesIO(requests.get(norm_eye_url).content)
pred = json.loads(requests.post(url,files={"file": ("norm.jpg", norm_jpg)}).content)
prediction = float(pred["prediction"]) if pred["success"] else "Undetermined"
std_prediction = float(pred["prediction_std"]) if pred["success"] else "Undetermined"
print("\n  Retina health score [0-4, 0 is healthy] (std deviation): %0.02f (%0.02f)\n" % (prediction, std_prediction))
~~~~

This should print something like this:

`  Retina health score [0-4, 0 is healthy] (std deviation): 0.01 (0.07)`

Which indicates the "healthy retina" image example on Wikipedia is indeed healthy!

## Building and Installing directly

To build, run the following in the repo:
~~~~
docker build -t actdr .
~~~~

## Acknowledgements

Thanks to the wonderful [tutorial](https://aimbrain.com/blog/serving-deep-learning-models-with-nginx-torch/) by [aimbrain](https://aimbrain.com). This repo borrows heavily from [actDR](https://github.com/OpenEye-Dev/actDR) with further integration/overlap planned for the future. actDR was used to generate a [production model](https://www.zenodo.org/record/495797) made available on [zenmodo](https://www.zenodo.org). Please cite this repository if you use this work in academic work.
