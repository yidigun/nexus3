FROM docker.io/library/alpine:3

# nexus oss download url is not opened.
# you should download nexus-$NEXUS_VERSION-unix.tar.gz file manually.
# see https://www.sonatype.com/products/repository-oss-download

ENV NEXUS_VERSION=3.37.1-01
ENV LANG=ko_KR.UTF-8
ENV TZ=Asia/Seoul
ENV INSTALL4J_JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV KARAF_HOME=/opt/nexus

COPY nexus-$NEXUS_VERSION-unix.tar.gz nexus.* /tmp
RUN apk update && \
    apk add tzdata openjdk8-jre-base && \
    mkdir -p /opt && \
    (cd /opt; \
       tar zxf /tmp/nexus-$NEXUS_VERSION-unix.tar.gz && \
       ln -s nexus-$NEXUS_VERSION nexus && \
       mv sonatype-work/nexus3 /nexus-data && \
       rmdir sonatype-work) && \
    cp /tmp/nexus.rc /tmp/nexus.vmoptions /opt/nexus/bin && \
    cp /tmp/nexus.properties /opt/nexus/etc && \
    addgroup -g 1000 nexus && \
    adduser -u 1000 -D -H -S -G nexus -h /nexus-data nexus && \
    chown -R nexus:nexus /nexus-data && \
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
    rm -rf /tmp/nexus*

COPY entrypoint.sh /

WORKDIR /nexus-data

USER nexus:nexus

EXPOSE 8081/tcp
VOLUME /nexus-data

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "run" ]
