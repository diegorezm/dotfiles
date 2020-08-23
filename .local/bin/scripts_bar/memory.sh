#!/bin/bash

mem() {
        _mem=$(free -h  | awk '/^Mem.:/  {print $3 "/" $2 }')
        echo "  $_mem "
}
mem
