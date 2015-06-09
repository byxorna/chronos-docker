FROM debian:jessie
MAINTAINER Gabe Conradi <gummybearx@gmail.com>

ENV CHRONOS_VERSION 2.3.4
ENV MAVEN_VERSION 3.2.5
ENV MESOS_VERSION 0.22.1
ENV MESOS_NATIVE_LIBRARY /usr/lib/libmesos.so
# this changes how the chronos UI redirects
ENV CHRONOS_HOSTNAME chronos
# override this to change where chronos looks to determine mesos master
ENV ZK_MASTER zk://127.0.0.1:2181/mesos
# override this with something like zk://zk1:2181,zk2:2181,zk3:2181/mesos/devel
ENV ZK_HOSTS  127.0.0.1:2181
RUN apt-get update && \
  apt-get install -y curl \
    build-essential \
    autoconf \
    libtool \
    libsvn-dev \
    libcurl4-nss-dev \
    zlib1g-dev \
    libsasl2-dev \
    libapr1-dev \
    default-jdk \
    nodejs npm \
    maven && \
  rm -rf /var/lib/apt/cache/lists/*

# nodejs is installed as nodejs, so link node to nodejs
RUN ln -s $(which nodejs) /usr/bin/node

# first, lets set up mesos
RUN mkdir /mesos && cd /mesos && curl -L "https://github.com/apache/mesos/archive/${MESOS_VERSION}.tar.gz" | tar xvz --strip-components 1 && \
  ls -la && ./bootstrap && PATH=/build/bin:$PATH ./configure --disable-python && make && make install && rm -rf /mesos && find / |grep mesos

RUN mkdir /chronos && \
  cd /chronos && \
  curl -L "https://github.com/mesos/chronos/archive/${CHRONOS_VERSION}.tar.gz" | tar xzv --strip-components 1 && \
  mvn package
EXPOSE 8080
ENTRYPOINT java -cp /chronos/target/chronos*.jar org.apache.mesos.chronos.scheduler.Main
#ENTRYPOINT ["java","-cp","/chronos/target/chronos*.jar","org.apache.mesos.chronos.scheduler.Main"]
CMD --master "${ZK_MASTER}" --zk_hosts "${ZK_HOSTS}" --hostname "${CHRONOS_HOSTNAME}"
