FROM byxorna/mesos:0.22.1
MAINTAINER Gabe Conradi <gummybearx@gmail.com>

ENV CHRONOS_VERSION 2.3.4
# this changes how the chronos UI redirects
ENV CHRONOS_HOSTNAME chronos
# override this to change where chronos looks to determine mesos master
# something like zk://zk1:2181,zk2:2181,zk3:2181/mesos/devel
ENV ZK_MASTER zk://127.0.0.1:2181/mesos
# zookeeper hosts to store state in. something like zk1:port,zk2:port,zk3:port
ENV ZK_HOSTS  127.0.0.1:2181
ENV ZK_STATE_PATH /chronos/state
RUN apt-get update && \
  apt-get install -y curl \
    build-essential \
    autoconf \
    libtool \
    default-jdk \
    nodejs npm \
    maven && \
  rm -rf /var/lib/apt/cache/lists/* && \
  ln -s $(which nodejs) /usr/bin/node && \
  mkdir /chronos && \
  cd /chronos && \
  curl -L "https://github.com/mesos/chronos/archive/${CHRONOS_VERSION}.tar.gz" | tar xzv --strip-components 1 && \
  mvn clean -Dmaven.test.skip=true package && ln -s /chronos/target/chronos*.jar target/chronos.jar && \
  apt-get remove -y --auto-remove build-essential autoconf libtool maven nodejs npm
EXPOSE 8080
ADD ./start.sh /chronos/
RUN chmod +x /chronos/start.sh
ENTRYPOINT ["/chronos/start.sh"]
