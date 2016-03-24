# Docker + Iron.io
### Table of Contents

- [Requirements](#requirements)
- [Writing and testing a ruby code](#code)
- [Building a new image](#image)

<a id="requirements"></a>
### Requirements
 - Docker installed on your machine. The installation guide is [here](https://docs.docker.com/engine/installation);
 - Docker Hub account. Register [here](https://hub.docker.com/register) if you still don't have it;
 - Iron.io account (register [here](https://hud.iron.io));
 - [Install](http://dev.iron.io/worker/cli/#installing) IronWorker command line tool (IronCli)
 
<a id="code"></a>
### Write and test your code
In this tutorial we will use [nokogiry](http://www.nokogiri.org/) to parse html document. Look through `scrabe.rb` file in current repository. Let's run it inside the `iron/ruby` image. Execute the following command in terminal:
```
$ sudo docker run --rm -it -v "$PWD":/worker -w /worker iron/ruby ruby scrape.rb
```
You should receive the error:
```
/usr/lib/ruby/2.2.0/rubygems/core_ext/kernel_require.rb:54:in `require': cannot load such file -- nokogiri (LoadError)
	from /usr/lib/ruby/2.2.0/rubygems/core_ext/kernel_require.rb:54:in `require'
	from scrape.rb:1:in `<main>'
```
This error message says we need nokogiri package to be installed. Let's extend `iron/ruby` image and add nokogiry, i.e. build our own image based on `iron/ruby`.

<a id="image"></a>
### Build your own image
First, create a [Dockerfile](https://github.com/aliklit/iron-docker/blob/master/Dockerfile). The first line should be `FROM iron/ruby` since we're extending `iron/ruby`. This image is built from alpine so we need to find nokogiri alpine package [here](https://pkgs.alpinelinux.org/packages?name=%25nokogiri%25&repo=all&arch=x86_64&maintainer=all) and add to Dockerfile:
`RUN apk add ruby-nokogiri`
Now we are ready to build our image using prepared [Dockerfile](https://github.com/aliklit/iron-docker/blob/master/Dockerfile). Run the following command in terminal from a directory with your Dockerfile:
```
sudo docker build -t USERNAME/noko:0.0.1 .
```
where `USERNAME` is your user name in Docker Hub, `noko` is the image name (can be anything you want) and `0.0.1` is the tag.
Let's run our test ruby script in created image:
```
sudo docker run --rm -it -v "$PWD":/worker -w /worker USERNAME/noko:0.0.1 ruby scrape.rb
```
