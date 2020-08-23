#!/bin/bash 
updat() {
        ch=$(checkupdates | wc -l)      
        echo "  $ch "  
} 
updat
