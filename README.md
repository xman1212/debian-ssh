debian-ssh
==========

Simple Debian docker images with *passwordless* SSH access and a regular user
with `sudo` rights


Usage
-----

Each Debian release corresponds to a branch, the branches differ only by
the `FROM` element in the `Dockerfile`.

To create the image `krlmlr/debian-ssh` e.g. for Debian "jessie":

    git checkout jessie
    make build

Use `make rebuild` to pull the base image and rebuild without caching.


Running
-------

Execute `make test` to create a container and fetch all environment variables
via SSH.  This requires an `.ssh/id_rsa.pub` file in your home, it will be
passed to the container via the environment variable `SSH_KEY` and installed.
The `Makefile` is configured to run the container with the limited `docker`
account, this user is allowed to run `sudo` without requiring a password.
The SSH daemon will be always run with root access.  The `debug-*` targets
can help troubleshooting any issues you might encounter.
