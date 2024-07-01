#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

cat <<\EOF >/opt/nginx-1.24.0/conf/nginx.conf
worker_processes 1;

events {
  worker_connections 1024;
}

stream {
  log_format basic '$remote_addr [$time_local] '
                   '$protocol $status $bytes_sent $bytes_received '
                   '$session_time';

  access_log logs/access.log basic;

  upstream backend {
    server 127.0.0.1:1234;
  }

  server {
    listen 1024;
    proxy_pass backend;
  }
}
EOF

date
