FROM nvidia/cuda:8.0-cudnn7-devel-ubuntu16.04

MAINTAINER Tim Besard <tim.besard@gmail.com>


## checkout

WORKDIR /opt

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
                    # basic stuff
                    build-essential ca-certificates \
                    # Julia
                    cmake curl gfortran git m4 python \
                    # GPUArrays
                    libclfft-bin libclblas-bin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/JuliaLang/julia.git && \
    cd julia && \
    git checkout v0.6.0


## build

WORKDIR /opt/julia

RUN make all -j$(nproc) \
        MARCH=x86-64 \
        JULIA_CPU_TARGET=x86-64 && \
    rm -rf deps/scratch deps/srccache usr-staging


## packages

WORKDIR /opt/julia/usr/bin

RUN ./julia -e "Pkg.init()"

ADD REQUIRE /root/.julia/v0.6

# install packages (some will fail to build, due to no GPU available during `docker build`)
RUN ./julia -e 'Pkg.resolve()' && \
    rm -rf /root/.julia/lib

COPY juliarc.jl /root/.juliarc.jl

ENTRYPOINT ["./julia"]
