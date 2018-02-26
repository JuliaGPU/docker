JuliaGPU docker recipes
=======================

*Docker recipes for Julia builds with JuliaGPU packages.*

**Build status**: [![][buildbot-img]][buildbot-url]

[buildbot-img]: http://ci.maleadt.net/shields/build.php?builder=Docker&branch=latest
[buildbot-url]: http://ci.maleadt.net/shields/url.php?builder=Docker&branch=latest

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
$ docker run --runtime=nvidia -it maleadt/juliagpu
```

The container will perform first time setup, and prompt you to commit the result:

```
INFO: Performing first time setup
...
INFO: Done! Now commit this using:
      $ docker commit CONTAINER_ID local/juliagpu
      and use the local/juliagpu tag instead.
```

Commit and use that result as prompted:

```
$ docker commit CONTAINER_ID local/juliagpu
$ docker run --runtime=nvidia -it local/juliagpu
julia> ...
```

Note that the container has Julia as entry point, and thus can be used as if it were a
regular binary:

```
$ alias juliagpu='docker run --runtime=nvidia -it local/juliagpu'
$ juliagpu -e 'println("Hello, World!")'
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
