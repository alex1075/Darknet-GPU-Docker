ARG BASE_IMAGE=nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
FROM $BASE_IMAGE AS builder
LABEL maintainer="Alexander Hunt <alexander.hunt@ed.ac.uk>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
      && apt-get install --no-install-recommends --no-install-suggests -y gnupg2 ca-certificates \
            git build-essential libopencv-dev \
      && rm -rf /var/lib/apt/lists/*

COPY configure.sh /tmp/

ARG SOURCE_BRANCH=unspecified
ENV SOURCE_BRANCH $SOURCE_BRANCH

ARG SOURCE_COMMIT=unspecified
ENV SOURCE_COMMIT $SOURCE_COMMIT

ARG CONFIG

RUN git clone https://github.com/alex1075/darknet.git && cd darknet \
      && /tmp/configure.sh $CONFIG && make \
      && cp darknet /usr/local/bin \
      && cd .. && rm -rf darknet

FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04
LABEL maintainer="Alexander Hunt <alexander.hunt@ed.ac.uk>"

ENV DEBIAN_FRONTEND noninteractive

ARG SOURCE_BRANCH=unspecified
ENV SOURCE_BRANCH $SOURCE_BRANCH

ARG SOURCE_COMMIT=unspecified
ENV SOURCE_COMMIT $SOURCE_COMMIT

RUN apt-get update \
      && apt-get install --no-install-recommends --no-install-suggests -y libopencv-highgui4.2 \
      && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/darknet /usr/local/bin/darknet
