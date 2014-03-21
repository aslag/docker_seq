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
RUN apt-get update && apt-get install -y openssh-server curl git supervisor openjdk-7-jdk

#
# customization
#
RUN echo 'root:testo' | chpasswd

ADD ./host_setup /host_setup
# configure sshd via supervisor in case of dev environment
RUN /host_setup/ssh_setup.sh
RUN /host_setup/supervisor_setup.sh

#
# Leiningen
#
RUN curl -s https://raw.github.com/technomancy/leiningen/stable/bin/lein -o /usr/local/bin/lein && chmod a+x /usr/local/bin/lein

#
# build jar
#
RUN cd / && git clone https://github.com/aslag/seq_http.git && cd /seq_http && LEIN_ROOT=true lein ring uberjar

#
# copy host scripts
#
ADD ./host /host

EXPOSE 3000
CMD ["/host/exec_seq_http.sh"]
