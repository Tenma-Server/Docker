# Tenma Dockerized

[Tenma](https://github.com/hmhrex/tenma) is a digital comic book server. Use this Docker image to get up and running quickly.

## Usage

`docker create --name=tenma -v </path/to/comic/library>:/tenma/files -p 8000:8000 hmhrex/tenma`

## Parameters

* `-v </path/to/comic/library>:/tenma/files` - Tenma's library directory.
* `-p <port>:8000` - This is the mapped port for http access. 8000 is recommended, although anything works here. (i.e. `localhost:8000`)

## Getting set up

1. Once you've set up your container, go to `localhost:8000`.
2. Log in with the default username and password. (_**It is recommended to change this once you are logged in.**_)
	* Username: `admin`
	* Password: `Pegasus!`
3. To import your comics, follow the instructions on the [wiki](https://github.com/hmhrex/Tenma/wiki/Importing-your-comics)

## Details

* To change your password, visit `localhost:8000/admin/auth/user/1/change/`
* Using a ComicVine API key isn't required to use Tenma, but it will vastly improve your experience.

## Versions

+ **07.26.17:** First version. Runs Tenma v0.1-alpha.
