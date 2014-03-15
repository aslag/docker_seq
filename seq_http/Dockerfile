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
RUN apt-get install -y openssh-server curl supervisor openjdk-7-jdk

#
# customization
#
RUN echo 'root:testo' | chpasswd

ADD ./host_setup /host_setup
RUN /host_setup/ssh_setup.sh
RUN /host_setup/supervisor_seq_http.sh

#
# Leiningen
#
RUN curl -s https://raw.github.com/technomancy/leiningen/stable/bin/lein -o /usr/local/bin/lein && chmod a+x /usr/local/bin/lein

#
# code
#
ADD . /src
# service started by supervisord

EXPOSE 22 3000
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
