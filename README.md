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

## Changelog

#### 08.07.17
* Updated to use [v0.1.6-alpha](https://github.com/Tenma-Server/Tenma/releases/tag/v0.1.6-alpha).
* Now generates random SECRET_KEY for security.
* Persistent database now stored in `/files/db.sqlite3`.

#### 08.03.17
* Updated to use [v0.1.5-alpha](https://github.com/Tenma-Server/Tenma/releases/tag/v0.1.5-alpha).

#### 08.02.17
* Updated to use [v0.1.4-alpha](https://github.com/Tenma-Server/Tenma/releases/tag/v0.1.4-alpha).
* Added unrar for CBR support.

#### 08.02.17
* Updated to use [v0.1.3-alpha](https://github.com/Tenma-Server/Tenma/releases/tag/v0.1.3-alpha).

#### 07.31.17
* Updated to use [v0.1.2-alpha](https://github.com/Tenma-Server/Tenma/releases/tag/v0.1.2-alpha).

#### 07.27.17
* Updated to use [v0.1.1-alpha](https://github.com/Tenma-Server/Tenma/releases/tag/v0.1.1-alpha).

#### 07.26.17
* First version. Runs Tenma v0.1-alpha.
