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

2. Configure packages

    Because Docker doesn't have access to your GPU during image build, you first need to
    configure the packages and commit the resulting image:

    ```
    nvidia-docker run -it maleadt/juliagpu -e "Pkg.build(); recompile()"
    docker commit --change='CMD ["--"]' $(docker ps -lq) local/juliagpu
    ```

    (`recompile()` as per JuliaLang/julia#16409, `["--"]` due to moby/moby#3465)


Usage
-----

The container is now ready for use:

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

```
$ docker build -t maleadt/juliagpu .
$ docker push maleadt/juliagpu
```
