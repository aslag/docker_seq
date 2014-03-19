FROM tianon/debian:jessie
MAINTAINER aslag <aslag@tehlulz.com>

# Hack for initctl, cf. https://github.com/dotcloud/docker/issues/1024
RUN apt-mark hold initscripts sysvinit-core udev plymouth mountall
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -fs /bin/true /sbin/initctl

#
# update
#
RUN apt-get update && apt-get -yq upgrade

#
# install this container's packages
#
RUN apt-get update && apt-get install -y git build-essential libssl-dev

#
# customization
#
ADD ./host_setup /host_setup
RUN /host_setup/install_wrk.sh

#
# copy benchmark scripts
#
ADD ./benchmark_scripts /benchmark_scripts
