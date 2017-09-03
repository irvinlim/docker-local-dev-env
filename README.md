# docker-local-dev-env

## What is this?

In my [blog post](https://irvinlim.com/blog/setting-up-all-your-local-dev-environments-with-docker/), I outline my personal workflow to set up your own local web development environment for _all_ your projects using Docker, [`jwilder/nginx-proxy`](https://github.com/jwilder/nginx-proxy), [Portainer](https://portainer.io/), and phpMyAdmin. 

This repository contains the scripts for the tools as well as a sample project for this particular workflow.

## Why would I need this?

This workflow aims to reduce the friction involved in setting up development environments, by compartmentalising project components with Docker Compose, while allowing other developers to utilise the same configurations without conflict by strictly enforcing host-specific and developer-specific configuration to be placed within `docker-compose.override.yml`, which should not be checked into source control.

At the same time, `nginx-proxy` provides benefits such as managing the virtual hosts for you so that you don't need to worry about setting up your own nginx instance or allocation of ports, and also instantly reloading nginx when a container is started/stopped.

Please see my [blog post](https://irvinlim.com/blog/setting-up-all-your-local-dev-environments-with-docker/) for an in-depth explanation.

## Scripts

The scripts in `scripts/` are provided to assist you to set up the tools required for this workflow.

## License

MIT
