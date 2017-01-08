#!/bin/bash

echo "REMOVING OLD PACKAGE"
if test -f openam13_0.1_amd64.deb; then
    rm openam13_0.1_amd64.deb
fi
echo "BUILDING NOW"
fpm -t deb -m "c.gm.viola@zalando.de" -s dir -n openam13 --version 0.1 \
    --url https://github.com/cgmv/openam-docker --license MIT \
    --vendor "Christian Viola" --category admin --deb-priority optional \
    --architecture amd64 \
    --description "Basic Package to prebuild forgerocks openam13 together with apache tomcat8 - NOTE: Oracle JDK8 is required for this package to run properly" .
echo "COPY TO OPENAM FOLDER"
cp openam13_0.1_amd64.deb ../../openam/
