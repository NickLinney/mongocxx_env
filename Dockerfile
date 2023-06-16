# Use the official Debian 11 image as the base
FROM debian:11

# Set the working directory
WORKDIR /app

# Install necessary dependencies for C++ and MongoDB
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libssl-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    mongodb-dev \
    pkg-config

# Clone the mongocxx driver repository
RUN git clone https://github.com/mongodb/mongo-cxx-driver.git --branch releases/stable --depth 1

# Build and install the mongocxx driver
WORKDIR /app/mongo-cxx-driver/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ..
RUN make -j$(nproc)
RUN make install

# Clean up unnecessary files
WORKDIR /app
RUN rm -rf mongo-cxx-driver

# Copy your C++ project files to the container
COPY . .

# Build your C++ project
RUN mkdir build && cd build && cmake .. && make

# Set the entry point for the container
CMD ["./build/your_program"]
