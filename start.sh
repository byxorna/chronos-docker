#!/bin/bash
# hack to work around how ENTRYPOINT and CMD work with shell expansion (or dont). I want env vars to be used to parameterize the container
# but if someone passed a cmd string, lets just use that.

if [ $# -ne 0 ] ; then
  exec java -cp /chronos/target/chronos.jar org.apache.mesos.chronos.scheduler.Main $@
else
  exec java -cp /chronos/target/chronos.jar org.apache.mesos.chronos.scheduler.Main --master $ZK_MASTER --zk_hosts $ZK_HOSTS --hostname $CHRONOS_HOSTNAME --zk_path $ZK_STATE_PATH
fi
