#!/bin/sh

cat > /etc/supervisor/conf.d/sshd.conf <<EOF
[program:sshd]
command=/usr/sbin/sshd -D
autostart=true
autrestart=true
stderr_logfile=/var/log/sshd.err.log
stdout_logfile=/var/log/sshd.out.log
EOF
