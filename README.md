# Chronos Docker Image

Docker build of chronos. Each version of chronos is tagged in a branch; `latest` is obviously latest.

## Running

The default config won't be very helpful, as it relies on a local zookeeper instance at `127.0.0.1:2181`. You can override this by setting `ZK_MASTER=zk://myzkhost:2181/mesos`, which gets passed to `chronos`'s `--master` flag. `ZK_HOSTS=127.0.0.1:2181` by default, which is passed to `--zk_hosts`.

You can change the `--hostname` chronos uses by setting the environment variable `CHRONOS_HOSTNAME=myhostname.tld` when starting the container. The container exposes port `8080`.

An example invocation would be:
```
docker run -d --name chronos -p 8080:8080 -e ZK_MASTER=zk://zk1:2181,zk2:2181,zk3:2181/mesos/devel -e ZK_HOSTS=zk1:2181,zk2:2181,zk3:2181 -e CHRONOS_HOSTNAME=chronos.iata.tumblr.net byxorna/chronos:2.3.4
```
