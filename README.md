JuliaGPU docker recipes
=======================

*Docker recipes for Julia builds with JuliaGPU packages.*


Prerequisites
-------------

* Docker
* NVIDIA drivers on your host system
* [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)


Installation
------------

1. Pull the layers: `docker pull maleadt/juliagpu`

2. Initialize the container

    Because Docker doesn't have access to your GPU during image build, you first need to
    initialize the container (build dependencies, precompile packages) and commit the
    resulting image:

    ```
    nvidia-docker run -it maleadt/juliagpu
    docker commit $(docker ps -lq) local/juliagpu
    ```


Usage
-----

The container is now ready to use:

```
nvidia-docker run -it local/juliagpu
julia> Pkg.test("CUDAnative")
```

Note that the container has Julia as entry point, and thus can be used as if it were a
regular binary:

```
$ alias juliagpu='nvidia-docker run -it local/juliagpu'
$ juliagpu -e 'println("Hello, World!")'
Hello, World!
```


Development
-----------

Members of the JuliaGPU organization can force a rebuild of the image at the [JuliaGPU
CI](http://ci.maleadt.net:8010/#/builders?tags=%2BDocker). Note that all included packages
need to pass tests, or the image won't be pushed.

Manual instructions:

```
$ docker build -t maleadt/juliagpu .
$ docker push maleadt/juliagpu
```
