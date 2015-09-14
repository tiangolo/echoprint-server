FROM ubuntu:14.04.3
MAINTAINER Sebastian Ramirez "tiangolo@gmail.com"

ENV TOKYOCABINET_VERSION="1.4.48" \
    TOKYOTYRANT_VERSION="1.1.41"

ENV ECHOPRINT_PATH=/opt/echoprint \
    TOKYOCABINET_URL=http://fallabs.com/tokyocabinet/tokyocabinet-$TOKYOCABINET_VERSION.tar.gz \
    TOKYOTYRANT_URL=http://fallabs.com/tokyotyrant/tokyotyrant-$TOKYOTYRANT_VERSION.tar.gz

ENV TOKYOCABINET_PATH=$ECHOPRINT_PATH/tokyocabinet-$TOKYOCABINET_VERSION \
    TOKYOTYRANT_PATH=$ECHOPRINT_PATH/tokyotyrant-$TOKYOTYRANT_VERSION \
    TOKYOCABINET_LINK=$ECHOPRINT_PATH/tokyocabinet \
    TOKYOTYRANT_LINK=$ECHOPRINT_PATH/tokyotyrant

RUN apt-get update
RUN apt-get install -y \
    wget \
    zlib1g-dev \
    libbz2-dev \
    python-setuptools \
    libboost1.55-dev \
    g++ \
    openjdk-7-jdk \
    libtag1-dev \
    zlib1g-dev \
    software-properties-common \
    python-software-properties \
    make && \
    apt-get autoremove

RUN apt-get install -y git

RUN apt-add-repository -y ppa:mc3man/trusty-media && \
    apt-get update && \
    apt-get install -y \
    ffmpeg && \
    apt-get autoremove

RUN sudo easy_install web.py
RUN sudo easy_install pyechonest

RUN mkdir -p $ECHOPRINT_PATH && \
    mkdir -p /usr/local/tokyocabinet/ && \
    mkdir -p /usr/local/tokyotyrant/

WORKDIR $ECHOPRINT_PATH

RUN wget $TOKYOCABINET_URL
RUN tar xvf tokyocabinet-$TOKYOCABINET_VERSION.tar.gz
RUN ln -sT $TOKYOCABINET_PATH $TOKYOCABINET_LINK
WORKDIR $TOKYOCABINET_LINK
RUN ./configure --prefix=/usr/local/tokyocabinet/ && \
    make && \
    make install

WORKDIR $ECHOPRINT_PATH
RUN wget $TOKYOTYRANT_URL
RUN tar xvf tokyotyrant-$TOKYOTYRANT_VERSION.tar.gz
RUN ln -sT $TOKYOTYRANT_PATH $TOKYOTYRANT_LINK
WORKDIR $TOKYOTYRANT_LINK
RUN ./configure --prefix=/usr/local/tokyotyrant/ --with-tc=/usr/local/tokyocabinet/ && \
    make && \
    make install
## RUN ln -s /usr/local/tokyocabinet/lib/libtokyocabinet.so.8 /usr/local/tokyotyrant/lib

WORKDIR $ECHOPRINT_PATH
RUN git clone https://github.com/echonest/echoprint-codegen.git
WORKDIR $ECHOPRINT_PATH/echoprint-codegen/src
RUN make && \
    ln -s $ECHOPRINT_PATH/echoprint-codegen/echoprint-codegen /usr/local/bin

WORKDIR $ECHOPRINT_PATH

# RUN git clone git://github.com/echonest/echoprint-server.git
COPY ./ ./echoprint-server/

COPY start_solr.sh $ECHOPRINT_PATH/
COPY start_tokyo.sh $ECHOPRINT_PATH/
COPY start_web_api.sh $ECHOPRINT_PATH/
COPY run_all.sh $ECHOPRINT_PATH/
COPY ingest.sh $ECHOPRINT_PATH/
COPY test_codes.sh $ECHOPRINT_PATH/

EXPOSE 8080
EXPOSE 1978
EXPOSE 8502

CMD ["bash", "run_all.sh"]
