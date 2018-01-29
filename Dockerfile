# SBT CLI Container
FROM openjdk:8-jdk-alpine3.7
MAINTAINER Jason McClellan <jason@jasonmcclellan.io>

RUN set -x \
    && apk --no-cache update \
    && apk --no-cache add bash \
                       ca-certificates \
                       ncurses \
                       tini

#----
# Install Scala & SBT
ARG SCALA_VERSION=2.12.4
ARG SBT_VERSION=1.1.0
RUN set -x \
    && apk --no-cache add --virtual=build-dependencies curl \
    && echo "https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz" \
    && curl -sL "https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz" | gunzip | tar -x -C /usr/local \
    && rm -f "/usr/local/scala-$SCALA_VERSION/bin/*.bat" \
    && rm -rf "/usr/local/scala-$SCALA_VERSION/doc" \
    && rm -rf "/usr/local/scala-$SCALA_VERSION/man" \
    && ln -s "/usr/local/scala-$SCALA_VERSION/bin/*" /usr/local/bin/ \
    && curl -sL "https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local \
    && rm -f "/usr/local/sbt/bin/*.bat" \
    && ln -s /usr/local/sbt/bin/sbt /usr/local/bin/sbt \
    && apk del build-dependencies

#----
# Default command options/env
ENV SBT_OPTS -Xmx1G -XX:+UseG1GC  -Xss1M -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap 
WORKDIR /workspace
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/sbt"]
