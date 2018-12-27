#!/bin/bash

#dump all class names into the manifest
grep -il "@istest" ../src/classes/*.cls  | awk -F "/" ' { print $NF }' | awk -F "." ' {print $1} ' > ./ftests/resource/manifestClasses.txt