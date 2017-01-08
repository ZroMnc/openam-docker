#!/bin/bash
#
#   Copyright 2016 Christian Viola
#
#   Onstop shop to be up and running quickly. All of these steps can be done manually but you know. 
#   just run it to:
#   - build the java8 base package
#   - download the debs
#

set -e

download_debs(){
    echo "[INFO] Please download these two files and place into folder"
    # ToDo - Script download
    echo "OpenAM - https://drive.google.com/open?id=0BzUVHsYmzWm_dGlXZll3SFdHTnc - openam13_0.1_amd64.deb"
    echo "OpenDJ - https://drive.google.com/open?id=0BzUVHsYmzWm_Z0psM2g0Ulplb1E - opendj_3.0.0-1_all.deb"
}

build_java8_image(){
    cd ../java8
    docker build -t redpanda/java8:latest .
}

main(){
    echo "[INFO] - Building the java8 base"
    build_java8_image
    echo "[INFO] - FR Packages"
    download_debs
}

main
