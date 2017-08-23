FROM nvidia/cuda:8.0-devel-ubuntu16.04

MAINTAINER Tim Besard <tim.besard@gmail.com>

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

RUN cd julia && \
    make -j$(nproc) \
        MARCH=x86-64 \
        JULIA_CPU_TARGET=x86-64

# TODO: would be nice to Pkg.add(; build=false)
RUN julia/usr/bin/julia -e 'Pkg.add("CUDAnative")'

CMD julia/usr/bin/julia
