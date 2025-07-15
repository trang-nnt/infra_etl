FROM openjdk:8-jre
# ----------------------------------------------------
# Install dependencies (JDBC driver, proc tools)
# ----------------------------------------------------
RUN apt-get update && apt-get install -y \
  postgresql-client \
  curl \
  procps \
  libsasl2-modules \
  libsasl2-dev \
  netcat \
  iputils-ping \
&& rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------
# Set environment for Hadoop, Hive
# ----------------------------------------------------
ENV HADOOP_VERSION=3.3.6
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/conf
ENV PATH=$PATH:$HADOOP_HOME/bin

ENV HIVE_VERSION=3.1.3
ENV HIVE_HOME=/opt/apache-hive-$HIVE_VERSION-bin
ENV HIVE_CONF_DIR=$HIVE_HOME/conf
ENV PATH=$PATH:$HIVE_HOME/bin
ENV HIVE_LOG_DIR=$HIVE_HOME/logs
ENV HIVE_AUX_JARS_PATH=$HIVE_HOME/lib

ARG POSTGRES_CONNECTOR_VERSION=42.2.18
# ----------------------------------------------------
# Install Hadoop
# ----------------------------------------------------
RUN curl -L "https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
  | tar xzf - -C /opt/ \
  && rm -rf $HADOOP_HOME/share/doc \
  && chown -R root:root $HADOOP_HOME \
  && mkdir -p $HADOOP_HOME/logs $HADOOP_CONF_DIR \
  && chmod -R 777 $HADOOP_HOME/logs $HADOOP_CONF_DIR

# ----------------------------------------------------
# Install Hive
# ----------------------------------------------------
RUN curl -L "https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz" \
  | tar xzf - -C /opt/ \
  && chown -R root:root $HIVE_HOME \
  && mkdir -p $HIVE_HOME/hcatalog/var/log $HIVE_HOME/var/log /data/hive $HIVE_CONF_DIR \
  && chmod -R 777 $HIVE_HOME/hcatalog/var/log $HIVE_HOME/var/log

# ----------------------------------------------------
# Add Hadoop S3/AWS support JARs
# ----------------------------------------------------

RUN curl -L -o $HIVE_HOME/lib/aws-java-sdk-bundle-1.11.624.jar \
      https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.624/aws-java-sdk-bundle-1.11.624.jar \
 && curl -L -o $HIVE_HOME/lib/hadoop-aws-$HADOOP_VERSION.jar \
      https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/$HADOOP_VERSION/hadoop-aws-$HADOOP_VERSION.jar \
 && curl -L -o $HIVE_HOME/lib/postgresql-${POSTGRES_CONNECTOR_VERSION}.jar \
      https://jdbc.postgresql.org/download/postgresql-${POSTGRES_CONNECTOR_VERSION}.jar

# ----------------------------------------------------
# Copy config and startup script
# ----------------------------------------------------
ADD files/hive-site.xml $HIVE_CONF_DIR/
ADD files/init-hive.sh /
RUN chmod +x /init-hive.sh

# ----------------------------------------------------
# Expose Hive Metastore + HiveServer2 ports
# ----------------------------------------------------
EXPOSE 9083 10000 10001
