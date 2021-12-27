#!/bin/sh

# System configs
LANG=${LANG:=ko_KR.UTF-8}
TZ=${TZ:-Asia/Seoul}
JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${JAVA_VERSION:=11}-${JAVA_JVM:=hotspot}
export LANG TZ JAVA_VERSION JAVA_JVM JAVA_HOME

NEXUS_HOME=/opt/nexus

CMD=$1; shift
case $CMD in
  start|run)
    exec $NEXUS_HOME/bin/nexus run
    ;;

  status|restart)
    exec $NEXUS_HOME/bin/nexus $CMD
    ;;


  sh|bash|/bin/sh|/bin/bash|/usr/bin/bash)
    exec /bin/sh "$@"
    ;;

  *)
    echo usage: "$0 { start [ args ... ] | sh [ args ... ] }"
    ;;

esac
