## Demo Ideas

*seq_http* is a dev environment for a tiny clojure HTTP service that generates mathematical sequences. *seq_test* is a container with a custom-compiled copy of the HTTP performance testing tool `wrk` (https://github.com/wg/wrk/). After you set up the two containers, you can run start the *seq_http* test environment and run benchmarks using *seq_test*.

If you want to investigate *seq_http* as a dev environment, follow the directions in the section Dev Environment Tryout.

### Docker Installation

For Ubuntu, see http://docs.docker.io/en/latest/installation/ubuntulinux/. For version `[YYY]` I did the following:

* TODO

### Container Setup

    docker build --rm -t aslag/seq_http:vanilla seq_http/.

    docker build --rm -t aslag/seq_test seq_test/.

### Basic Demo

    docker run -d --name seq_http -p 3322:22 aslag/seq_http:vanilla

    docker run --rm -i -t --link seq_http:service seq_test /benchmark_scripts/count.sh 2 20 10

`count.sh` takes args: `num_of_threads` `num_of_concurrent_connections` `test_duration`. These correspond to `wrks`' `-t` `-c` and `-d` (in seconds)

### Dev Environment Tryout

#### Container Customization

**Note** If you run either or both of the below options, you'll have to start the `seq_http` container with the supervisor command because committing an image saves the last-executed command and re-runs it. (TODO: find a way around this.) Starting it up might look like this:

    docker run -d --name seq_http -p 3322:22 aslag/seq_http:mykey /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

(optional) Given server ssh keys in ~/.ssh/servers/testo/, execute the following to customize the container and re-tag it aslag/seq_http:vanilla.

    tar -cf - -C ~/.ssh/servers/testo/ . | docker run -i aslag/seq_http:vanilla sh -c '(cd /etc/ssh/ && tar -xpf -)' && (CID=$( docker ps -a | grep 'aslag/seq_http' | cut -d' ' -f1 ); docker commit $CID aslag/seq_http:vanilla; docker rm $CID )

(optional) Given a client ssh pubkey in ~/.ssh/id_rsa.pub, execute the following to customize the container and tag it aslag/seq_http:mykey.

    cat ~/.ssh/id_rsa.pub | docker run -i aslag/seq_http:vanilla sh -c 'cat > /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys' && (CID=$( docker ps -a | grep 'aslag/seq_http' | cut -d' ' -f1 ); docker commit $CID aslag/seq_http:mykey; docker rm $CID )

#### Workstation SSHFS Usage

    cd ~/projects && git clone https://github.com/aslag/seq_http.git
    sshfs -o uid=$( id -u ),gid=$( id -g ) localhost:/seq_http seq_http -p 3322

### Docker Common

    docker ps -a

    docker stop <running_container> && docker rm $_

    docker images

    docker rmi <image>

### Notes
* *seq_http*'s openjdk-7-jdk depends on lots of graphical and other packages we don't need. In a local environment, it'd make sense to host a copy of a JDK and have the docker container download that rather than using the OS's package.

* Docker doesn't download packages from the net as fast as a native Linux box or SmartOS VMs do. This really doesn't matter because Docker images are built infrequently and it aggressively caches. To make use of the caching, start the *seq_test* build command after the *seq_http* build command has finished updating debian.

### Known Issues
* This sample hard-codes some config information (like the port 3000 used by *seq_http*). It is probably desirable to make this a configuration option.
