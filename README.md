Docker images with Python + Mono + pythonnet
============================================

Docker images with various combinations of Python, Mono, and pythonnet versions.

## Quickstart

Get a Python shell:

```
$ docker run -it --rm jonemo/pythonnet:python3.6.4-mono4.8.0.524-pythonnet2.3.0 python
Python 3.6.4 (default, Dec 21 2017, 01:35:12)
[GCC 4.9.2] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

Inside the Python shell:

```
>>> from System import Environment
>>> print(Environment.MachineName)
79000da3c53a
```

## Approach

The method for installing is slightly different for each of the three main components of this image (Python, Mono, pythonnet):
* **Python**: Because an actively maintained and "official" [Dockerhub repository](https://hub.docker.com/_/python/) covering a range of Python versions exists, these Python images are used as base images. The `-jessie` variant of the Python Docker images is used because the slimmer variants (`-slim` and `-alpine`) do not include the tooling required for the Mono and pythonnet installs later.[^mono-alpine]
* **Mono** provides [succinct documentation for installing on Debian systems](http://www.mono-project.com/download/#download-lin-debian), including [steps for installing older releases](http://www.mono-project.com/docs/getting-started/install/linux/#accessing-older-releases).
* **pythonnet** is the smallest (by contributor count) of the three project and, therefore, does not come with the luxery of comprehensive installation documentation for a wide range of platforms. Binary packages only exist for Windows, but installing pythonnet on a Linux based platform with Mono involves building from source. Gladly, the project's issue tracker contains a wealth of detailed reports of problems and solutions.


## Notes on available versions/tags

### Python

The Python versions included are a subset of those available in the [Python Dockerhub repository](https://hub.docker.com/_/python/), excluding pre-release versions.
The Python Dockerhub repository generally includes the latest stable version of every supported branch of Python (for example `3.5.4` but not `3.5.3`, and none of `3.3.x`).
Currently, there are no abbreviated version tags (e.g. `3.6` pointing at `3.6.4`) since including those would increase the maintenance effort.

### Mono

[Mono versioning](http://www.mono-project.com/docs/about-mono/versioning/) is non-obvious to the newcomer.
I make no claim to understand the details of it and use the [Mono Project's own Docker repository](https://hub.docker.com/r/library/mono/) as guidance for which versions are current.

There are no releases of Mono 4 available for Debian 8.0 (Jessie):
http://download.mono-project.com/repo/debian/dists/jessie/snapshots/
https://stackoverflow.com/questions/29982959/how-to-install-mono-4-0-1-on-debian-8

For ease of maintaining Dockerfiles for many combinations of component versions, the Dockerfile does not specify the version suffix (the `xxx` in `apt-get install mono-complete=5.4.1-xxx`).

The test suite of the `master` branch of pythonnet currently tests against Mono 5.2.x, with a note that 5.4.0 is considered "broken" by pythonnet.[^mono540broken].

### pythonnet

pythonnet 2.3.0 requires Mono >= 4.8.0[^mono480] is not compatible with Mono 5.x[^pythonnet230mono5x].

The latest code on the `master` branch of the Github repository is compatible with Mono 5.x and will be released in version 2.4.0 of pythonnet.
However, pythonnet 2.4.0 is still in development and not yet available on PyPI.

The recommended method for installing the latest source from the Git repository's `master` branch is `pip install git+https://github.com/pythonnet/pythonnet`.[^pipinstallegg]
However, a bug currently prevents this from working, which is why all tags containing `pythonnet-2.4.0.dev` perform differ in how pythonnet is fetched and built.


## Testing

The first draft of this repository (you are currently looking at it) does not include any tests or continuous integration setup.
If I decide to continue maintaining this repository, I will change this shortly.
Possible tests to run against each of the Dockerfiles generated are:
* (obviously) Does `docker build` succeed?
* The [basic Mono examples](http://www.mono-project.com/docs/getting-started/mono-basics/) recommended as install verification by their installation instructions.
* A set of Python scripts that import `pythonnet` and make primitive use of some of its features.


## Footnotes

[^mono-alpine]: https://github.com/mono/docker/issues/56
[^mono540broken]: https://github.com/pythonnet/pythonnet/commit/75e5231c15ff132e650d76859e676567c0b8b5c7
[^mono480]: https://github.com/pythonnet/pythonnet/issues/504#issuecomment-311219019
[^pipinstallegg]: https://github.com/pythonnet/pythonnet/wiki/Troubleshooting-on-Windows,-Linux,-and-OSX#2-build-and-install-from-command-line
[^pythonnet230mono5x]: https://github.com/pythonnet/pythonnet/issues/504, https://github.com/pythonnet/pythonnet/issues/470
[^pythonnet240pipinstall]: https://github.com/pythonnet/pythonnet/issues/555


Ubuntu 16 or Python 3.6??? https://github.com/pythonnet/pythonnet/issues/556
