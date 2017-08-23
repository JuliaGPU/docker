JuliaGPU docker recipes
=======================

*Docker recipes for Julia builds with JuliaGPU packages.*

Usage
-----

You need [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) to run this image. After
installation, pull the image using `docker pull maleadt/gpu`.

Because Docker doesn't have access to your GPU during image build, you need to configure the
packages and commit the resulting image before first use:

```
nvidia-docker run -it maleadt/juliagpu julia/usr/bin/julia -e "Pkg.build()"
docker commit --change='CMD julia/usr/bin/julia' $(docker ps -lq) maleadt/juliagpu
```

The container is now ready for use:

```
nvidia-docker run -it maleadt/juliagpu
julia> Pkg.test("CUDAnative")
```
