JuliaGPU docker recipes
=======================

*Docker recipes for Julia builds with JuliaGPU packages.*

**Deprecation notice**: With Julia 0.7/1.0, installability of the GPU stack has improved, and this image isn't worth maintaining anymore.

For a list of included packaged, refer to the [REQUIRE](REQUIRE) file.


Prerequisites
-------------

* Docker
* NVIDIA drivers on your host system
* [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)


Usage
-----

Pull and start the container as follows:

```
$ docker pull maleadt/juliagpu
$ docker run --runtime=nvidia -v $PKG:/pkg -it maleadt/juliagpu
```

Replace `$PKG` with a named volume (see `docker volume create`), or the path to
a local directory. When the container starts, and `/pkg` does not contain an
initialized package installation, a pre-configured installation of the packages
as listed in the [REQUIRE](REQUIRE) file will be copied to the package directory
and configured for your system. This will take a while, but the results will be
persistent across invocations (on the condition you keep your package volume or
directory intact).

The container starts in `/data`, which you can mount in order to access files
from your host.

Note that the container has Julia as entry point, and thus can be used as if it were a
regular binary (especially powerful in combination with `$PWD` mounted as `/data`):

```
$ alias juliagpu='docker run --runtime=nvidia -v $PKG:/pkg -v $PWD:/data -it maleadt/juliagpu'

$ juliagpu -e 'println("Hello, World!")'
Hello, World!

$ echo 'println("Hello, World!")' > test.jl
$ juliagpu test.jl
Hello, World!
```


Troubleshooting
---------------

* Did you run the container with `--runtime=nvidia`?
* Some packages might support a debugging mode; run again with `DEBUG=true` and file an issue.


Development
-----------

Members of the JuliaGPU organization can force a rebuild of the image at the [JuliaGPU
CI](http://ci.maleadt.net:8010/#/builders?tags=%2BDocker). Apart from that, the image is
rebuilt weekly, including new versions of Julia and any included packages.

If you want to include a new package, create a PR modifying the REQUIRE file. Note that all
included packages need to pass tests, or the image won't be pushed.

Manual build instructions:

```
$ docker build -t maleadt/juliagpu .
$ docker push maleadt/juliagpu
```
