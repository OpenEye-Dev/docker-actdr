FROM kaixhin/torch
WORKDIR "/root"
RUN apt-get -y update && apt-get install -y \
	wget \
	graphicsmagick \
	libgraphicsmagick-dev \
	libpcre3 \
	libpcre3-dev \
	&& rm -rf /var/lib/apt/lists/*
RUN wget https://openresty.org/download/openresty-1.11.2.2.tar.gz
RUN tar -xvf openresty-1.11.2.2.tar.gz
RUN rm openresty-1.11.2.2.tar.gz
WORKDIR "/root/openresty-1.11.2.2"
RUN ./configure --with-luajit
RUN make
RUN make install
WORKDIR "/root"
RUN mkdir serve_actdr
WORKDIR "/root/serve_actdr"
RUN wget https://www.zenodo.org/record/495797/files/prod_model.t7
RUN wget https://raw.githubusercontent.com/tswedish/fb.resnet.torch/jeepers-transforms/datasets/transforms.lua
RUN mkdir logs
RUN luarocks install graphicsmagick
COPY nginx.conf .
COPY serve.lua .
COPY start.sh .
CMD /bin/bash start.sh
