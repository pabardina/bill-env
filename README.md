Bill Env
=========

# Requirements

* Docker
* Make

# What it does:

* Create a folder in ~/my-git-repos to share with docker container
* Build Docker image
* Launch a container and mount docker socket (Yes docker in docker)

# How to use

* `make run` build image if needed, start container and launch a shell in the container.
* `make shell` launch a shell in the container (it starts the container if it is stopped).
* `make exec cmd=ls` execute a command in the container.
* `make clean` remove everything
* `make help`

# Getting started

* `make run`
