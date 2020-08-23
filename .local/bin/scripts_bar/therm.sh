#!/bin/bash 

termal() {
        temp=$(acpi -t | awk '{print $4}')
        [ $temp >  65 ] && echo "  $temp " || echo "  $temp "
}
termal
