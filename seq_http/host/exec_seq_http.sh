#!/bin/sh

java -jar $(ls -Art /seq_http/target/*-standalone.jar | tail -n 1)
