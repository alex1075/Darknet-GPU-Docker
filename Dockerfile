FROM nvidia/cuda:11.5.0-cudnn8-devel-ubuntu20.04
LABEL maintainer="Alexander Hunt <alexander.hunt@ed.ac.uk>"

RUN apt-get update && apt upgrade -y

RUN apt install wget git libssl-dev zip unzip -y
WORKDIR /root/
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2.tar.gz
RUN tar -xzf cmake-3.22.2.tar.gz
RUN cd cmake-3.22.2 && ./bootstrap && make -j$(nproc) && make install
RUN cd && rm -rf cmake-3.22.2 cmake-3.22.2.tar.gz
RUN cd 
RUN wget https://github.com/opencv/opencv/archive/4.5.5.zip
RUN unzip 4.5.5.zip
RUN wget https://github.com/opencv/opencv_contrib/archive/refs/tags/4.5.5.tar.gz
RUN tar -xzf 4.5.5.tar.gz
RUN cd opencv-4.5.5
RUN mkdir build_release && cd build_release

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 -D WITH_CUDA=ON -D CUDA_ARCH_BIN=5.2 -D WITH_V4L=ON -D WITH_QT=OFF -D WITH_GSTREAMER=ON -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_PC_FILE_NAME=opencv.pc -D OPENCV_ENABLE_NONFREE=ON -D INSTALL_C_EXAMPLES=OFF -D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib-4.5.5/modules -D BUILD_EXAMPLES=OFF ..
RUN cmake --build . --target install --parallel $(nproc)
RUN cd && rm -rf opencv-4.5.5 opencv-4.5.5.zip  4.5.5.tar.gz opencv_contrib-4.5.5  

RUN git clone https://github.com/alex1075/darknet.git && cd darknet
RUN mkdir build_release && cd build_release
RUN cmake  ..
RUN cmake --build . --target install --parallel $(nproc)
ENTRYPOINT bash
