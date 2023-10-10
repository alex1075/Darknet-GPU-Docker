FROM nvidia/cuda:11.7.1-devel-ubuntu20.04
LABEL maintainer="Alexander Hunt <alexander.hunt@ed.ac.uk>"
LABEL description="Docker image setup to use Darknet with Cuda 11.7.1, Cudnn 8 and OpenCV 4.6.0 on Ubuntu 20.04"
RUN apt update && apt upgrade -y
RUN apt install libcudnn8* wget unzip -y
RUN apt install python3 python-is-python3 python3-pip -y
RUN apt install wget git libssl-dev zip unzip libeigen3-dev libgflags-dev libgoogle-glog-dev -y
RUN apt-get install libjpeg-dev libpng-dev libtiff-dev libopenjp2-7-dev -y
RUN apt-get install libavcodec-dev libavformat-dev libswscale-dev -y
RUN apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev -y
RUN apt-get install libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev -y
RUN apt-get install libfaac-dev libvorbis-dev -y
RUN apt-get install libopencore-amrnb-dev libopencore-amrwb-dev -y
RUN apt-get install libgtk-3-dev -y 
RUN apt-get install libtbb-dev -y 
RUN apt-get install libprotobuf-dev protobuf-compiler -y
RUN apt-get install libgoogle-glog-dev libgflags-dev -y
RUN apt-get install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen -y
RUN apt-get install libgtkglext1 libgtkglext1-dev -y
RUN apt-get install libopenblas-dev liblapacke-dev libva-dev libopenjp2-tools libopenjpip-dec-server libopenjpip-server libqt5opengl5-dev libtesseract-dev -y 
WORKDIR /root/
RUN apt install cmake
RUN cd 
RUN pip3 install --upgrade pip
RUN pip3 install numpy
RUN git clone https://github.com/opencv/opencv.git
RUN wget https://github.com/opencv/opencv_contrib.git
RUN cd opencv && cd build && cmake -D CMAKE_BUILD_TYPE=RELEASE \
 -D CMAKE_INSTALL_PREFIX=/usr/local \
 -D WITH_TBB=ON \
 -D ENABLE_FAST_MATH=1 \
 -D CUDA_FAST_MATH=1 \
 -D WITH_CUBLAS=1 \
 -D WITH_CUDA=ON \
 -D BUILD_opencv_cudacodec=OFF \
 -D WITH_CUDNN=ON \
 -D OPENCV_DNN_CUDA=ON \
 -D CUDA_ARCH_BIN=8.6 \
 -D WITH_V4L=ON \
 -D WITH_QT=OFF \
 -D WITH_OPENGL=ON \
 -D WITH_GSTREAMER=ON \
 -D OPENCV_GENERATE_PKGCONFIG=ON \
 -D OPENCV_PC_FILE_NAME=opencv.pc \
 -D OPENCV_ENABLE_NONFREE=ON \
 -D INSTALL_PYTHON_EXAMPLES=OFF \
 -D INSTALL_C_EXAMPLES=OFF \
 -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-4.6.0/modules \
 -D BUILD_EXAMPLES=OFF  ..
RUN cd opencv && cd build && cmake --build . --target install --parallel $(nproc)

RUN git clone https://github.com/AlexeyAB/darknet && cd darknet && mkdir build_release && cd build_release
RUN cd darknet/build_release && cmake .. && make -j$(nproc)
CMD ["bash"]



