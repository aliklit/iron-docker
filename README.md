# Docker + Iron.io
### Table of Contents

- [Requirements](#requirements)
- [Writing and testing a ruby code](#code)
- [Building a new image](#image)
- [Push an image to Docker Hub](#push)
- [Upload a code to Iron.io](#upload)
- [Run a task on Iron server](#queue)

<a id="requirements"></a>
### Requirements
 - Docker installed on your machine. The installation guide is [here](https://docs.docker.com/engine/installation);
 - Docker Hub account. Register [here](https://hub.docker.com/register) if you still don't have it;
 - Iron.io account (register [here](https://hud.iron.io));
 - [Install](http://dev.iron.io/worker/cli/#installing) IronWorker command line tool (IronCli)
 
<a id="code"></a>scrape
### Write and test your code
In this tutorial we will use [nokogiry](http://www.nokogiri.org/) to parse html document. Look through `scrape.rb` file in current repository. Let's run it inside the `iron/ruby` image. Execute the following command in terminal:
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

<a id="push"></a>
### Push an image to Docker Hub
Once you’ve built or created a new image you can push it to Docker Hub using the `docker push` command. This allows you to share it with others.
```
sudo docker push USERNAME/noko
```

<a id="upload"></a>
### Upload a code to Iron.io
Now we are ready to upload our ruby code to Iron and tell Iron to run it in our new image.
Navigate to iron.io [dashboard](https://hud.iron.io/dashboard) and create a project. In order to configure Iron credentials we need 2 environment variables: `IRON_PROJECT_ID` and `IRON_TOKEN`. Their values can be taken from your Iron [dashboard](https://hud.iron.io/dashboard).

<a id="package"></a>
#### Package your code
```
zip -r noko.zip scrape.rb
```

<a id="upload_command"></a>
#### Upload you code
```
iron worker upload --name noko --zip noko.zip USERNAME/noko:0.0.1 ruby scrape.rb
```

<a id="queue"></a>
### Run your code on Iron server
```
$ iron worker queue noko
----->  Configuring client
        Project 'test' with id='548f37e01b4e500005000090'
----->  Queueing task 'noko'
        Queued task with id='56f50050e5ca85000746e2bf'
        Check https://hud.iron.io/tq/projects/548f37e01b4e500005000090/jobs/56f50050e5ca85000746e2bf for more info
```
