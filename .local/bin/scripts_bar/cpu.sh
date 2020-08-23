#!/bin/bash

cpu_usage() {
        cpu=$(top -b -n1 | grep CPU |tr '\n' ' ' | awk '{print $2 + $4}')
        echo "  $cpu%"
}
cpu_usage
