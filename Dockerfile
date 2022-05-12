FROM nvidia/cuda:11.5.0-cudnn8-devel-ubuntu20.04
LABEL maintainer="Alexander Hunt <alexander.hunt@ed.ac.uk>"

RUN apt-get update && apt upgrade -y

RUN apt install wget git libssl-dev zip unzip libeigen3-dev libgflags-dev libgoogle-glog-dev -y
RUN apt-get install libjpeg-dev libpng-dev libtiff-dev libopenjp2-7-dev
RUN apt-get install libavcodec-dev libavformat-dev libswscale-dev
RUN apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
RUN apt-get install libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev
RUN apt-get install libfaac-dev libvorbis-dev
RUN apt-get install libopencore-amrnb-dev libopencore-amrwb-dev
RUN apt-get install libgtk-3-dev
RUN apt-get install libtbb-dev
RUN apt-get install libprotobuf-dev protobuf-compiler
RUN apt-get install libgoogle-glog-dev libgflags-dev
RUN apt-get install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen
RUN apt-get install libgtkglext1 libgtkglext1-dev
RUN apt-get install libopenblas-dev liblapacke-dev libva-dev libopenjp2-tools libopenjpip-dec-server libopenjpip-server libqt5opengl5-dev libtesseract-dev 
WORKDIR /root/
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2.tar.gz
RUN tar -xzf cmake-3.22.2.tar.gz
RUN cd cmake-3.22.2 && ./bootstrap && make -j$(nproc) && make install
RUN cd && rm -rf cmake-3.22.2.tar.gz
RUN git clone https://ceres-solver.googlesource.com/ceres-solver && cd ceres-solver && mkdir build && cd build
RUN cd ceres-solver/build && cmake .. && make -j$(nporc) && make test && make install
RUN cd 
RUN wget https://github.com/opencv/opencv/archive/4.5.5.zip
RUN unzip 4.5.5.zip
RUN wget https://github.com/opencv/opencv_contrib/archive/refs/tags/4.5.5.tar.gz
RUN tar -xzf 4.5.5.tar.gz
RUN cd opencv-4.5.5 && mkdir build && cd build

RUN cd opencv-4.5.5 && cd build && cmake -D CMAKE_BUILD_TYPE=RELEASE \
 -D CMAKE_INSTALL_PREFIX=/usr/local \
 -D WITH_TBB=ON \
 -D ENABLE_FAST_MATH=1 \
 -D CUDA_FAST_MATH=1 \
 -D WITH_CUBLAS=1 \
 -D WITH_CUDA=ON \
 -D BUILD_opencv_cudacodec=OFF \
 -D WITH_CUDNN=ON \
 -D OPENCV_DNN_CUDA=ON \
 -D CUDA_ARCH_BIN=5.1, 8.6 \
 -D WITH_V4L=ON \
 -D WITH_QT=OFF \
 -D WITH_OPENGL=ON \
 -D WITH_GSTREAMER=ON \
 -D OPENCV_GENERATE_PKGCONFIG=ON \
 -D OPENCV_PC_FILE_NAME=opencv.pc \
 -D OPENCV_ENABLE_NONFREE=ON \
 -D INSTALL_PYTHON_EXAMPLES=OFF \
 -D INSTALL_C_EXAMPLES=OFF \
 -D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib-4.5.5/modules \
 -D BUILD_EXAMPLES=OFF  ..
RUN cd opencv-4.5.5 && cd build && cmake --build . --target install --parallel $(nproc)
RUN cd && rm -rf opencv-4.5.5.zip  4.5.5.tar.gz   

RUN git clone https://github.com/alex1075/darknet.git && cd darknet
RUN cd darknet && mkdir build_release && cd build_release && cmake  ..
# RUN cd darknet && cd build_release && cmake --build . --target install --parallel $(nproc)
ENTRYPOINT bash
