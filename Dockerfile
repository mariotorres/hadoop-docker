
# Pull base image.
FROM ubuntu:16.04

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y dialog apt-utils && \
  apt-get -y upgrade && \
  apt-get install -y build-essential openssh-server && \
  apt-get install -y software-properties-common && \
  apt-get install -y python3=3.5.1* byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# HADOOP
ADD http://www-eu.apache.org/dist/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz /root
RUN tar xvf /root/hadoop-2.7.5.tar.gz -C /root/

# JAVA
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer
RUN apt-get install -y oracle-java8-set-default

# SSH
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# SSH
EXPOSE 22
# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 10020 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 2122


CMD ["/usr/sbin/sshd", "-D"]
