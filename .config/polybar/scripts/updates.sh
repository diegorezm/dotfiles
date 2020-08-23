#!/bin/bash

updat () {
	checkupdates | wc -l
}

echo "$(updat)"
