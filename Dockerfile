FROM ubuntu:18.04

RUN apt update && \
    apt upgrade -y

# Basic tools
RUN apt install -y \
    build-essential \
    curl wget git gnupg \
    software-properties-common lsb-release \
    gcc-8 g++-8

# Install Bazel
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    apt update && \
    apt install -y bazel

# Install clang
RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 9 && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt update && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 9 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-9 9

RUN git clone https://github.com/tensorflow/runtime.git

RUN cd runtime && \
    bazel build -c opt //tools:bef_executor