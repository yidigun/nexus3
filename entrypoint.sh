#!/bin/sh

# System configs
LANG=${LANG:=ko_KR.UTF-8}
TZ=${TZ:-Asia/Seoul}
export LANG TZ

KARAF_HOME=${KARAF_HOME:-/opt/nexus}
JAVA_HOME=${JAVA_HOME:-`java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' | awk '{print $3}'`}
INSTALL4J_JAVA_HOME=${INSTALL4J_JAVA_HOME:-$JAVA_HOME}
export KARAF_HOME INSTALL4J_JAVA_HOME JAVA_HOME

CMD=$1; shift
case $CMD in
  start|run)
    exec $KARAF_HOME/bin/nexus run "$@"
    ;;

  sh|bash|/bin/sh|/bin/bash|/usr/bin/bash)
    exec /bin/sh "$@"
    ;;

  *)
    echo usage: "$0 { run [ args ... ] | sh [ args ... ] }"
    ;;

esac
