# Docker + Iron.io
### Table of Contents

- [Requirements](#requirements)
- [Writing and testing a ruby code](#code)

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
