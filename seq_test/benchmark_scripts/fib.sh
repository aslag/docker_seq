#!/bin/sh

wrk -t${1} -c${2} -d${3}s -s /benchmark_scripts/fib_to_88.lua http://${SERVICE_PORT_3000_TCP_ADDR}:${SERVICE_PORT_3000_TCP_PORT}
