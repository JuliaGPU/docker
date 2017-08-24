FROM nvidia/cuda:8.0-devel-ubuntu16.04

MAINTAINER Tim Besard <tim.besard@gmail.com>

WORKDIR /opt

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        gfortran \
        git \
        m4 \
        python \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/JuliaLang/julia.git && \
    cd julia && \
    git checkout v0.6.0

WORKDIR /opt/julia

RUN make all -j$(nproc) \
        MARCH=x86-64 \
        JULIA_CPU_TARGET=x86-64 && \
    rm -rf deps/scratch deps/srccache usr-staging

WORKDIR /opt/julia/usr/bin

# install packages (some will fail to build, due to no GPU available during `docker build`)
RUN ./julia -e 'Pkg.add.(["CUDAnative", "CuArrays"])' && \
    rm -rf /root/.julia/lib

ADD .juliarc.jl /root/

ENTRYPOINT ["./julia"]
