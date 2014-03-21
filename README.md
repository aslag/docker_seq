## Demo Ideas

This project is a Docker demo with two containers. The first is *seq_http*, a tiny HTTP service (https://github.com/aslag/seq_http). *seq_test* is a container that compiles the HTTP performance testing tool `wrk` (https://github.com/wg/wrk/). After you set up the two containers, you can run start the *seq_http* test environment and run benchmarks using *seq_test*. One benchmark script uses `wrk`s LUA script feature.

If you want to investigate *seq_http* as a dev environment, see the section Dev Environment Tryout.

For more information on Docker, see http://docs.docker.io/en/latest/.

### Docker Installation

For Ubuntu, see http://docs.docker.io/en/latest/installation/ubuntulinux/. If this seems cumbersome, consider using a Digital Ocean droplet to try docker (https://www.digitalocean.com/community/articles/how-to-use-the-digitalocean-docker-application). Digital Ocean's droplets are virtual machines you can easily create and destroy for such trial projects. The cost is minimal and the service is excellent.

### Container Setup

Build each container:

    docker build --rm -t aslag/seq_http:vanilla seq_http/.

    docker build --rm -t aslag/seq_test seq_test/.

### Basic Demo

Start the seq_http container in daemon mode:

    docker run -d --name seq_http aslag/seq_http:vanilla

Execute benchmark scripts from the seq_test container:

    docker run --rm -i -t --link seq_http:service aslag/seq_test /benchmark_scripts/fib.sh 1 10 20

    docker run --rm -i -t --link seq_http:service aslag/seq_test /benchmark_scripts/count.sh 2 12 60

The benchmark scripts take args: `num_of_threads` `num_of_concurrent_connections` `test_duration`. These correspond to `wrks`' `-t` `-c` and `-d` (in seconds)

### Dev Environment Tryout

#### Container Customization

(optional) Given server ssh keys in ~/.ssh/servers/testo/, execute the following to customize the container and re-tag it `aslag/seq_http:vanilla` (note that if you have a running instance of aslag/seq_http:vanilla, you must stop and remove it first):

    tar -cf - -C ~/.ssh/servers/testo/ . | docker run -i aslag/seq_http:vanilla sh -c '(cd /etc/ssh/ && tar -xpf -)' && (CID=$( docker ps -a | grep 'aslag/seq_http' | cut -d' ' -f1 ); docker commit $CID aslag/seq_http:vanilla; docker rm $CID )

(optional) Given a client ssh pubkey in ~/.ssh/id_rsa.pub, execute the following to customize the container and tag it `aslag/seq_http:mykey`:

    cat ~/.ssh/id_rsa.pub | docker run -i aslag/seq_http:vanilla sh -c 'cat > /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys' && (CID=$( docker ps -a | grep 'aslag/seq_http' | cut -d' ' -f1 ); docker commit $CID aslag/seq_http:mykey; docker rm $CID )

Start seq_http docker container (this one assumes you've setup an SSH key and retagged the container) and invoke supervisord to start the ssh daemon:

    docker run -d --name seq_http -p 3000:3000 -p 3322:22 aslag/seq_http:mykey /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

Note the use of the '-p' switch. This forwards the host's port before the colon (3322 in one case) to the port 22 inside the container.

Note also that if you haven't set up keys (the optional steps), you'll need to use the root password to login as root over SSH. The root password is 'testo'.

#### Workstation SSHFS Setup and Mount

    cd ~/projects && git clone https://github.com/aslag/seq_http.git
    sshfs -o nonempty -o uid=$( id -u ),gid=$( id -g ) root@localhost:/seq_http seq_http -p 3322

#### Dev Workflow

SSH to the container:

    ssh -oPort=3322 root@localhost

Start the dev server:

    cd /seq_http && LEIN_ROOT=true lein ring server-headless 3000

Because the source dir is mounted with sshfs from the host system into the container, you can edit source files in the host system and they'll be available to the runtime in the container. Note also that the container is executed in development mode and will hot-reload source changes.

If you started the seq_http daemon with `-p 3000:3000` (as mentioned above) traffic originating from the host system (your workstation, probably) will be forwarded to the dev container's server. You can test that with a command like this:

    curl -i http://localhost:3000/api/count/5

### Docker Common

See all containers (running and not):

    docker ps -a

Stop and remove a container by ID:

    docker stop <running_container_id> && docker rm $_

See all images:

    docker images

Stop and remove an image:

    docker rmi <image_id>

For more information about docker commands, see: http://docs.docker.io/en/latest/reference/commandline/

### Notes
* *seq_http*'s openjdk-7-jdk depends on lots of graphical and other packages we don't need. In a local environment, it'd make sense to host a copy of a JDK and have the docker container download that rather than using the OS's package.

* Docker doesn't download packages from the net as fast as a native Linux box or SmartOS VMs do. This really doesn't matter because Docker images are built infrequently and it aggressively caches. To make use of the caching, start the *seq_test* build command after the *seq_http* build command has finished updating debian.

* I use supervisord to start the SSH service in the seq_http container when used as a dev environment. This can easily be added-to with other persistent services.

### Known Issues
* This sample hard-codes some config information (like the port 3000 used by *seq_http*). It is probably desirable to make this a configuration option.

* The SSH key setup procedure is a bit crufty and the details could be hidden in a script that does condition checking before executing. Fix that.
