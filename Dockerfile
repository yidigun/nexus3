# nexus oss download url is not opened.
# you should download nexus-$NEXUS_VERSION-unix.tar.gz file manually.
# see https://www.sonatype.com/products/repository-oss-download

FROM yidigun/ubuntu-base:22.04

ARG IMG_NAME
ARG IMG_TAG
ARG LANG=en_US.UTF-8
ARG TZ=Etc/UTC

ENV IMG_NAME=$IMG_NAME
ENV IMG_TAG=$IMG_TAG
ENV LANG=$LANG
ENV TZ=$TZ

ENV NEXUS_VERSION=$IMG_TAG
ENV KARAF_HOME=/opt/sonatype/nexus

RUN apt-get -y update && \
    apt-get -y install openjdk-8-jre-headless

COPY nexus-$NEXUS_VERSION-unix.tar.gz nexus.* /tmp/
RUN (mkdir -p `dirname $KARAF_HOME` && \
    cd `dirname $KARAF_HOME` && \
    tar zxf /tmp/nexus-$NEXUS_VERSION-unix.tar.gz && \
    ln -s nexus-3.39.0-01 $KARAF_HOME && \
    mv sonatype-work/nexus3 /nexus-data && \
    rmdir sonatype-work) && \
    cp /tmp/nexus.rc /tmp/nexus.vmoptions $KARAF_HOME/bin && \
    cp /tmp/nexus.properties $KARAF_HOME/etc && \
    groupadd -g 1000 nexus && \
    useradd -u 1000 -g nexus -d /nexus-data nexus && \
    chown -R nexus:nexus /nexus-data && \
    rm -rf /tmp/*.tar.gz /tmp/nexus.*

COPY entrypoint.sh /
WORKDIR /nexus-data

EXPOSE 8081/tcp
EXPOSE 5000/tcp
VOLUME /nexus-data

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "run" ]
