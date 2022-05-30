#!/bin/sh

# try to set locale and timezone
if locale -a 2>/dev/null | grep -q "$LANG"; then
  : do nothing
else
  locale-gen $LANG 2>/dev/null
  update-locale LANG=$LANG 2>/dev/null
fi
if [ -n "$TZ" -a -f /usr/share/zoneinfo/$TZ ]; then
  ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
fi

KARAF_HOME=${KARAF_HOME:-/opt/sonatype/nexus}
JAVA_HOME=${JAVA_HOME:-`java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' | awk '{print $3}'`}
INSTALL4J_JAVA_HOME=${INSTALL4J_JAVA_HOME:-$JAVA_HOME}
export KARAF_HOME INSTALL4J_JAVA_HOME JAVA_HOME

start() {
  exec $KARAF_HOME/bin/nexus run "$@"
}

stop() {
  if [ -f /nexus-data/karaf.pid ]; then
    if kill -0 `cat /nexus-data/karaf.pid`; then
      $KARAF_HOME/bin/nexus stop
    fi
  fi
}

restart() {
  if [ -f /nexus-data/karaf.pid ]; then
    if kill -0 `cat /nexus-data/karaf.pid`; then
      $KARAF_HOME/bin/nexus restart
    else
      start
    fi
  else
    start
  fi
}

trap stop TERM
trap stop INT
trap restart HUP

mkdir -p /nexus-data && \
chown nexus:nexus /nexus-data

CMD=$1; shift
case $CMD in
  start|run)
    start
    ;;

  sh|bash|/bin/sh|/bin/bash|/usr/bin/bash)
    exec /bin/sh "$@"
    ;;

  *)
    echo usage: "$0 { run [ args ... ] | sh [ args ... ] }"
    ;;

esac
