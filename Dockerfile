FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y wget openssh-client openssh-server
RUN wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz
RUN mkdir /usr/java
RUN tar xvzf jdk-8u151-linux-x64.tar.gz -C /usr/java
ENV JAVA_HOME=/usr/java/jdk1.8.0_151/
RUN update-alternatives --install /usr/bin/java java ${JAVA_HOME%*/}/bin/java 20000
RUN update-alternatives --install /usr/bin/javac javac ${JAVA_HOME%*/}/bin/javac 20000
RUN update-alternatives --config java
RUN wget http://www-eu.apache.org/dist/hadoop/common/hadoop-2.6.5/hadoop-2.6.5.tar.gz 
RUN tar xzf hadoop-2.6.5.tar.gz
RUN mv hadoop-2.6.5 /usr/local/hadoop
########################## HBASE Setup ##############################
RUN wget http://apache.mirror.gtcomm.net/hbase/stable/hbase-1.2.6-bin.tar.gz
RUN tar -zxvf hbase-1.2.6-bin.tar.gz
RUN mv hbase-1.2.6 /usr/local/Hbase
ENV HBASE_HOME=/usr/local/Hbase
RUN echo JAVA_HOME="/usr/java/jdk1.8.0_151/" >> /etc/environment
RUN echo JAVA_HOME="/usr/java/jdk1.8.0_151/" >> $HBASE_HOME/hbase-env.sh
#RUN source /etc/environment
COPY ./hadoop-conf.sh ./hadoop-conf.sh
COPY ./start.sh ./start.sh
RUN chmod 700 hadoop-conf.sh
RUN chmod 700 start.sh
RUN ./hadoop-conf.sh
#RUN /etc/init.d/ssh start
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys
#ENV HADOOP_HOME=/usr/local/hadoop
#ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
#ENV HADOOP_COMMON_HOME=$HADOOP_HOME
#ENV HADOOP_HDFS_HOME=$HADOOP_HOME
#ENV YARN_HOME=$HADOOP_HOME
#ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
#ENV PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
#ENV HADOOP_INSTALL=$HADOOP_HOME
COPY ./core-site.xml /usr/local/hadoop/etc/hadoop/core-site.xml
COPY ./hdfs-site.xml /usr/local/hadoop/etc/hadoop/hdfs-site.xml
COPY ./mapred-site.xml /usr/local/hadoop/etc/hadoop/mapred-site.xml
COPY ./mapred-site.xml /usr/local/hadoop/etc/hadoop/mapred-site.xml
COPY ./yarn-site.xml /usr/local/hadoop/etc/hadoop/yarn-site.xml
COPY ./hbase-site.xml /usr/local/Hbase/conf/hbase-site.xml
CMD ["./start.sh"]
