FROM alpine:3.8

RUN apk --update add curl ca-certificates tar && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-2.31-r0.apk && \
    apk add --allow-untrusted glibc-2.31-r0.apk

# Java Version

ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 131
ENV JAVA_VERSION_BUILD 11
ENV JAVA_PACKAGE jdk
ENV TOMCAT_VERSION_MAJOR 8
ENV TOMCAT_VERSION_MINOR 5
ENV TOMCAT_VERSION_BUILD 5

# Download and unarchive Java

RUN mkdir /opt && wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/d54c1d3a095b4ff2b6607d096fa80163/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
    tar -xzf jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz -C /opt && \
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk && \
    rm -rf /opt/jdk/*src.zip \
           /opt/jdk/lib/missioncontrol \
           /opt/jdk/lib/visualvm \
           /opt/jdk/lib/*javafx* \
           /opt/jdk/jre/lib/plugin.jar \
           /opt/jdk/jre/lib/ext/jfxrt.jar \
           /opt/jdk/jre/bin/javaws \
           /opt/jdk/jre/lib/javaws.jar \
           /opt/jdk/jre/lib/desktop \
           /opt/jdk/jre/plugin \
           /opt/jdk/jre/lib/deploy* \
           /opt/jdk/jre/lib/*javafx* \
           /opt/jdk/jre/lib/*jfx* \
           /opt/jdk/jre/lib/amd64/libdecora_sse.so \
           /opt/jdk/jre/lib/amd64/libprism_*.so \
           /opt/jdk/jre/lib/amd64/libfxplugins.so \
           /opt/jdk/jre/lib/amd64/libglass.so \
           /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
           /opt/jdk/jre/lib/amd64/libjavafx*.so \
           /opt/jdk/jre/lib/amd64/libjfx*.so && \
    wget -c https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_MAJOR}.${TOMCAT_VERSION_MINOR}.${TOMCAT_VERSION_BUILD}/bin/apache-tomcat-${TOMCAT_VERSION_MAJOR}.${TOMCAT_VERSION_MINOR}.${TOMCAT_VERSION_BUILD}.tar.gz && \
    tar -xzf apache-tomcat-${TOMCAT_VERSION_MAJOR}.${TOMCAT_VERSION_MINOR}.${TOMCAT_VERSION_BUILD}.tar.gz -C /opt && \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION_MAJOR}.${TOMCAT_VERSION_MINOR}.${TOMCAT_VERSION_BUILD} /opt/tomcat

# Set environment

ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin
ENV CATALINA_HOME /opt/tomcat

COPY config/tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
COPY config/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml

COPY webapps/ /opt/tomcat/webapps/

EXPOSE 80

CMD ["sh", "-c", "${CATALINA_HOME}/bin/catalina.sh run"]