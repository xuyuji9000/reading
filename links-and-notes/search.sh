#!/bin/sh

if [ -z "${1}" ] ; then 
    echo "Search pattern can not be empty."
    exit 1
fi

git grep -i --name-only $1
