# The graphscope image includes all runtime stuffs of graphscope, with analytical engine,
# learning engine and interactive engine installed.

FROM ubuntu:20.04

# Install wheel package from current directory if pass "CI=true" as build options.
# Otherwise, exec `pip install graphscope` from Pypi.
# Example:
#     sudo docker build --build-arg CI=${CI} .
ARG CI=false

# change bash as default
SHELL ["/bin/bash", "-c"]

# shanghai zoneinfo
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install python3 java8
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    cat /etc/apt/sources.list && \
    apt update -y && apt install -y \
      curl git openjdk-8-jdk python3-pip sudo && \
    apt clean && rm -fr /var/lib/apt/lists/*

# Add graphscope user with user id 1001
RUN useradd -m graphscope -u 1001 && \
    echo 'graphscope ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Change to graphscope user
USER graphscope
WORKDIR /home/graphscope

# init log directory
RUN sudo mkdir /var/log/graphscope \
  && sudo chown -R $(id -u):$(id -g) /var/log/graphscope

COPY . /home/graphscope/gs
# COPY . /home/graphscope/gs

RUN /usr/bin/python3 -m pip install -r /home/graphscope/gs/requirements.txt


ENTRYPOINT ["/usr/bin/python3", "/home/graphscope/gs/graph_proxy_ide.py"]