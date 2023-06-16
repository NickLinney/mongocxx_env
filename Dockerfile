FROM debian:buster
RUN apt update

# Install necessary dependencies for C++ and MongoDB
RUN apt install -y \
    build-essential \
    cmake \
    curl \
    wget \
    git \
    libssl-dev \
    libsasl2-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    mongodb-dev \
    pkg-config

# Clone the mongocxx driver repository
WORKDIR /opt
RUN wget https://github.com/mongodb/mongo-c-driver/releases/download/1.23.5/mongo-c-driver-1.23.5.tar.gz
  && tar xzf mongo-c-driver-1.23.5.tar.gz
  && cd mongo-c-driver-1.23.5
  && mkdir cmake-build
  && cd cmake-build
  && cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF ..
  && cmake --build .
  && cmake --build . --target install

# Build and install the mongocxx driver
WORKDIR /opt
RUN curl -OL https://github.com/mongodb/mongo-cxx-driver/releases/download/r3.7.2/mongo-cxx-driver-r3.7.2.tar.gz
  && tar -xzf mongo-cxx-driver-r3.7.2.tar.gz
  && cd mongo-cxx-driver-r3.7.2/build
  && cmake ..                                \
      -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=/usr/local
  && cmake --build . --target EP_mnmlstc_core
  && cmake --build .
  && cmake --build . --target install

# Clean up unnecessary files
WORKDIR /opt
RUN rm -rf mongo-c-driver-1.23.5
  && rm -rf mongo-cxx-driver-r3.7.2
