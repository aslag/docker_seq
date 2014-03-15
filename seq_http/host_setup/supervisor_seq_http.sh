#!/bin/sh

cat > /etc/supervisor/conf.d/sshd.conf <<EOF
[program:sshd]
command=/usr/sbin/sshd -D
autostart=true
autrestart=true
stderr_logfile=/var/log/sshd.err.log
stdout_logfile=/var/log/sshd.out.log

[program:seq_http]
environment=
  LEIN_ROOT=true,
directory=/src/
command=/usr/local/bin/lein ring server-headless 3000
autostart=true
autrestart=true
stderr_logfile=/var/log/seq_http.err.log
stdout_logfile=/var/log/seq_http.out.log
EOF
