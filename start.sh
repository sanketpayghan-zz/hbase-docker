#!/bin/bash 
source /etc/environment
/etc/init.d/ssh start
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_INSTALL=$HADOOP_HOME
hdfs namenode -format
start-dfs.sh
start-yarn.sh
/usr/local/Hbase/bin/start-hbase.sh
/usr/local/Hbase/bin/local-master-backup.sh 2 4
/usr/local/Hbase/bin/local-regionservers.sh start 2 3
$HADOOP_HOME/sbin/start-all.sh
cd /usr/local/Hbase/bin/
./local-master-backup.sh start 2
./local-regionservers.sh start 3
./hbase shell
