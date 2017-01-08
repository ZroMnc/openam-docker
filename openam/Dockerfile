FROM redpanda/java8:latest

MAINTAINER Christian Viola <c.gm.viola@gmail.com>

# Defines current OpenAM deb package
ENV PACKAGE openam13_0.1_amd64.deb
ENV OPENDJDEB opendj_3.0.0-1_all.deb

# Required by the init script to determine current environment

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV CATALINA_HOME /opt/tomcat

# Fix some shell stuff
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update && \
    apt-get install -y jq vim

# Ephemeral Config - Must be reworked
COPY $PACKAGE /tmp/$PACKAGE
COPY $OPENDJDEB /tmp/$OPENDJDEB
RUN dpkg -i /tmp/$PACKAGE && \
    dpkg -i /tmp/$OPENDJDEB && \
    rm /tmp/$PACKAGE
ADD openam /etc/init.d/openam
ADD opendj /usr/bin/opendj
ADD upstart /usr/bin/start

EXPOSE 8080 1389

# Launch OpenAM
CMD ["/usr/bin/start"]
