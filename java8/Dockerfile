FROM ubuntu:latest

MAINTAINER Christian Viola <c.gm.viola@gmail.com>

# Set locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Fix some shell stuff
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update && \
    apt-get install -y git build-essential curl wget tar unzip software-properties-common 

# Install JDK 8
RUN \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

# Install JCE 8
RUN \
    wget -c --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com; notice_preferences=2:cb8350a2759273dccf1e483791e6f8fd" \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" \
    -O /tmp/jce_policy-8.zip && \
    unzip -o -j /tmp/jce_policy-8.zip UnlimitedJCEPolicyJDK8/local_policy.jar -d $JAVA_HOME/jre/lib/security/ && \
    unzip -o -j /tmp/jce_policy-8.zip UnlimitedJCEPolicyJDK8/US_export_policy.jar -d $JAVA_HOME/jre/lib/security/ && \
    rm /tmp/jce_policy-8.zip
