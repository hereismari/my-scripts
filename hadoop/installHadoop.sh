#!/bin/bash 

# for each instance install and configure hadoop
# Download hadoop
wget http://apache.mirrors.spacedump.net/hadoop/common/stable/hadoop-2.7.2.tar.gz
tar -xvf hadoop-2.7.2.tar.gz --gzip
rm hadoop-2.7.2.tar.gz 

cd ~/hadoop-2.7.2

# Set up environment variables
export HADOOP_HOME=~/hadoop-2.7.2
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_YARN_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

# Download JAVA
sudo apt-get update
sudo apt-get install --fix-missing openjdk-7-jdk

# Setting JAVA_HOME
JAVA_HOME = "/usr/lib/jvm/java-7-openjdk-amd64/"
export JAVA_HOME=$JAVA_HOME
echo "export JAVA_HOME="$JAVA_HOME >> etc/hadoop/hadoop-env.sh

# Setting HOSTNAME
vm_ip ="ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'"
sudo sh -c "echo $vm_ip $HOSTNAME >> /etc/hosts"

# SSH without password
cat /dev/zero | ssh-keygen -t rsa -q -N ""
for ip in list_of_ips; do
    cat ~/.ssh/id_rsa.pub | ssh -i cloud.key ubuntu@ip 'cat >> .ssh/authorized_keys && echo "Key copied"'
done

# Configuration 
echo "export JAVA_HOME="$JAVA_HOME >> libexec/hadoop-config.sh

echo "export JAVA_HOME="$JAVA_HOME >> etc/hadoop/yarn-env.sh
echo "export HADOOP_HOME="$HADOOP_HOME >> etc/hadoop/yarn-env.sh
echo "export HADOOP_MAPRED_HOME="$HADOOP_HOME >> etc/hadoop/yarn-env.sh
echo "export HADOOP_COMMON_HOME="$HADOOP_HOME >> etc/hadoop/yarn-env.sh
echo "export HADOOP_HDFS_HOME="$HADOOP_HOME >> etc/hadoop/yarn-env.sh
echo "export YARN_HOME="$HADOOP_HOME >> etc/hadoop/yarn-env.sh
echo "export HADOOP_CONF_DIR="$HADOOP_HOME"/etc/hadoop" >> etc/hadoop/yarn-env.sh
echo "export YARN_CONF_DIR="$HADOOP_HOME"/etc/hadoop" >> etc/hadoop/yarn-env.sh

# copy the xml files in folder in $HADOOP_CONF_DIR
cp core-site.xml $HADOOP_CONF_DIR/core-site.xml
cp hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml
cp mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml
cp yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml

# if master....
echo "slave1\nslave2\n" >> $HADOOP_CONF_DIR/slaves
