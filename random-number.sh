#!/bin/bash

max=100
echo $(( `cat /dev/urandom | od -N1 -An -i` % $max ))
