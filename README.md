# OpenAM & DJ Docker Container Setup

## What is this?
- Base for experiments around OpenAM and OpenDJ setup for Cloud deployments.
- Greenfield approach - starting from scratch
- Package testing

## Building OpenAM

> Note: please set this as a local domain to auth.terminus.net - if you don't do this, the setup will fail!

```bash
$ sudo -i
$ echo "127.0.0.1   auth.terminus.net" >> /etc/hosts
$ exit
```

### Setup Script
This script will build the java8 base package und show the package links to download.

```bash
./script/setup.sh
```
Move into the openam directory `cd ./openam` and build the OpenAM.

### Building or Download the Debian Packages

#### Download
- Part of the setup script are the download urls. Place both `*.deb` files into the openam folder.

#### Build yourself
Make sure you build the deb package first using `fpm`.

```bash
# Move into the package dir
$ cd package/build
# Place war file into packages/build/opt/tomcat/webapps/
$ cp ~/Downloads/Openam13.war packages/build/opt/tomcat/webapps/z.war
# Build the deb
$ ./run.sh
```

### Build the Base Image
This might seem an unnecessary step to but it saves some time. The base image is actually a oracle jdk java8 build based on ubuntu. The has been some news lately - can't find the reference atm.

Regardless I would recommend you either build it yourself using the commands below or just download it from my docker hub.

```bash
cd java8/
docker build -t redpanda/java8:lastest .
```

**Build Local Image AM/DJ**
```bash
$ cd openam
$ docker build --no-cache -t redpanda/openam:latest .
```
> NOTE: Make sure the `*.deb` are in this folder

## Starting the container

Run interactive:
```bash
$ docker run -it --rm -v `pwd`/config:/config \
    --hostname 'auth.terminus.net' \
    redpanda/openam:latest /bin/bash

$ /usr/bin/start
```

 Run fully automated
```bash
$ docker run -p 8080:8080--rm -v `pwd`/config:/config \
    --hostname 'auth.terminus.net' \
    redpanda/openam:latest
```

## Working with OpenAM

Now wait until you see Tomcat restarting... that's it. Once you see this in the container output OpenAM is ready for usage.
```
...
[INFO] >> Configuring OpenAM
[INFO] >> Configuring Root Realm
[INFO] >> Done!
[INFO] >> Configuring employees Realm
[INFO] >> Stopping OpenAM instance (tomcat)
[ERROR] << normal stopped failed, forcing kill:
[INFO] >> Done!
[INFO] >> Starting OpenAM instance (tomcat)
```

### Login

#### Employee Login
Open URL to login user using these credentials:
```
username: testemployee
password: iamdev@zal123
```
[http://auth.terminus.net:8080/z/XUI/#login/employees](http://auth.terminus.net:8080/z/XUI/#login/employees)

**Getting a Token**
```bash
```

#### Admin Login

```
username: amadmin
password: iamtest@zal123
```
[http://auth.terminus.net:8080/z](http://auth.terminus.net:8080/z)

## ToDo

- [] Switch base image from ubuntu to alpine (have done this already for the python version)
- [] Improve Documentation

## Little Background Information

> Note: You don't need to know this to run the container.

#### SSOConfigurator
As far as the configurator is concerned the binaries need to be placed into the build directory `opt/openam/tools/configurator`.
Optionally you can remove the sample files but thats not required.

```bash
unzip ~/SSOConfiguratorTools-13.0.0.zip -d opt/openam/tools/configurator
```
#### SSOADM
The workhorse of OpenAM is the _ssoadm_ binary which actually a collection of jars hidden in the install directory. Regardless of its origin the tool will be invoked
during the actual configuration of OpenAM and be used in batch mode. 

### Tomcat
In order to build the fpm package you need to put tomcat into the package folder. 

**Get the lastest Version**

```bash
wget --quiet --no-cookies http://apache.rediris.es/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32.tar.gz -O /tmp/tomcat.tgz
tar xzvf /tmp/tomcat.tgz -C /tmp
mv /tmp/apache-tomcat-8.0.32 /tmp/tomcat
```
**Hiding Server Information**

```bash
echo -n "Hiding server information: "
    cd $TC_INSTALLBASE/tomcat/lib && jar xf catalina.jar org/apache/catalina/util/ServerInfo.properties
    perl -pi -e 's/server.info=Apache Tomcat\/8.0.32/server.info=IAM/' org/apache/catalina/util/ServerInfo.properties
    jar uf catalina.jar org/apache/catalina/util/ServerInfo.properties
    rm -rf org
    echo "done."
```

**Remove not required files**

```bash
rm -rf /tmp/tomcat/webapps/*
rm /tmp/tomcat/temp/*
rm /tmp/tomcat/bin/*.bat
rm /tmp/tomcat/conf/tomcat-users.x*
```
**Put into directory**

```bash
cp /tmp/tomcat ~/<path-to-build-folder>/opt
```

*IMPORTANT NOTES* - please note that under '''/opt/tomcat/conf''' there are changed configuration files which are required. In case you whish to perform an update make sure these files are still used.

## OpenDJ3

### Building the Package
That is very simple - you don't. Just download it from backstage. 

### Inspecting the Base Package
It might be interesting to know that when you install the OpenDJ package that most run-time directories do not exist yet.

```bash
bin/
legal-notices/
lib/
opendj_logo.png
setup*
share/
snmp/
template/
uninstall*
upgrade*
```
When running the `setup` the file tree is extended by:
```bash
bak/
changelogDb/
classes/
config/
db/
import-tmp/
ldif/
locks/
logs/
```


## Misc

#### Using Lower Ports in Tomcat
In unix systems the use of ports under 1024 usually requires special permissions or rights. Using authbinds (http://manpages.ubuntu.com/manpages/hardy/man1/authbind.1.html).

```bash
AUTHBIND=true
```
And create a new file for this:
```bash
sudo touch /etc/authbind/byport/443
sudo chown tomcat8 /etc/authbind/byport/443
sudo chmod 500 /etc/authbind/byport/443
```

## Sources & Helpful Links

**Docker**
* https://docs.docker.com/engine/userguide/containers/dockervolumes/

**OpenAM**
* https://backstage.forgerock.com/#!/docs/openam/13/admin-guide/chap-certs-keystores 

**Init Scripts**
* https://www.linux.com/learn/tutorials/442412-managing-linux-daemons-with-init-scripts
* https://www.novell.com/coolsolutions/feature/15380.html

**JAVA**
* http://suhothayan.blogspot.de/2012/05/how-to-install-java-cryptography.html

**Tomcat**
* http://www.coderanch.com/t/648486/Tomcat/Asynchronous-logging-tomcat
* https://www.mulesoft.com/tcat/tomcat-ssl
* https://tomcat.apache.org/tomcat-8.0-doc/ssl-howto.html#Configuration
* https://tomcat.apache.org/tomcat-8.0-doc/apr.html
* http://tomcat.apache.org/native-doc/
* http://tomcat.apache.org/tomcat-8.0-doc/config/http.html#SSL_Support
* http://tomcat.apache.org/tomcat-8.0-doc/apr.html#APR_Connectors_Configuration
* http://stackoverflow.com/questions/19216979/ssl-configuration-in-tomcat-and-apr
* http://www.linuxfromscratch.org/blfs/view/7.7/postlfs/openssl.html
* https://www.feistyduck.com/books/openssl-cookbook/

**Tailing Logs**
* http://www.krenger.ch/blog/bash-wait-for-log-entry
