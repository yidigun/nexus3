# nexus oss download url is not opened.
# you should download nexus-$NEXUS_VERSION-unix.tar.gz file manually.
# see https://www.sonatype.com/products/repository-oss-download

FROM docker.io/library/centos:7

ARG IMG_NAME
ARG IMG_TAG
ARG LANG=ko_KR.UTF-8
ARG TZ=Asia/Seoul

ENV IMG_NAME=$IMG_NAME
ENV IMG_TAG=$IMG_TAG
ENV LANG=$LANG
ENV TZ=$TZ

ENV NEXUS_VERSION=$IMG_TAG
ENV INSTALL4J_JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
ENV KARAF_HOME=/usr/local/nexus

RUN if [ -n "$LANG" ]; then \
      eval `echo $LANG | \
        sed -E -e 's/([a-z]+_[a-z]+)\.([a-z0-9_-]+)/localedef -cf\2 -i\1 \1.\2/i'`; \
    fi; \
    if [ -n "$TZ" -a -f /usr/share/zoneinfo/$TZ ]; then \
      ln -sf /usr/share/zoneinfo/$TZ /etc/localtime; \
    fi; \
    yum -y install java-1.8.0-openjdk-headless && \
    yum clean all && \
    rm -rf /var/cache/yum


COPY nexus-$NEXUS_VERSION-unix.tar.gz nexus.* /tmp/
RUN (cd /usr/local; \
       mkdir -p nexus-$NEXUS_VERSION && \
       tar zxf /tmp/nexus-$NEXUS_VERSION-unix.tar.gz && \
       ln -s nexus-$NEXUS_VERSION nexus && \
       mv sonatype-work/nexus3 /nexus-data && \
       rmdir sonatype-work) && \
    cp /tmp/nexus.rc /tmp/nexus.vmoptions /usr/local/nexus/bin && \
    cp /tmp/nexus.properties /usr/local/nexus/etc && \
    groupadd -g 1000 nexus && \
    useradd -u 1000 -g nexus -d /nexus-data nexus && \
    chown -R nexus:nexus /nexus-data && \
    rm -rf /tmp/*.tar.gz /tmp/nexus.*

COPY entrypoint.sh /

WORKDIR /nexus-data

USER nexus:nexus

EXPOSE 8081/tcp
EXPOSE 5000/tcp
VOLUME /nexus-data

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "run" ]
