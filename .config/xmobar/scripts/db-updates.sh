#!/bin/bash 
up=$(checkupdates | wc -l)
echo $up  > /tmp/updates
echo "^c#94e2d5^"   $(cat /tmp/updates) "^d^"
