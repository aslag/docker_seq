#!/bin/sh

wrk -t${1} -c${2} -d${3}s http://${SERVICE_PORT_3000_TCP_ADDR}:${SERVICE_PORT_3000_TCP_PORT}/api/count/50
