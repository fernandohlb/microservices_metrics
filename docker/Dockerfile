FROM ubuntu

MAINTAINER Fernando H. L. Buzato


#Instala o MongoDB
RUN apt-get update

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list-3.0.list

RUN apt-get update

RUN apt-get install -y mongodb-org

RUN mkdir -p /data/db


#Instala o Java

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list

RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

RUN apt-get update

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN apt-get install oracle-java8-installer -y

EXPOSE 8091
#Supervisor Config
RUN apt-get -y install supervisor && \
  mkdir -p /var/log/supervisor && \
  mkdir -p /etc/supervisor/conf.d

ADD supervisor.conf /etc/supervisor.conf


#Faz o deploy da aplicação
VOLUME /tmp
ADD /app/imageProcess-0.0.1-SNAPSHOT.jar imageProcess.jar
RUN sh -c 'touch /imageProcess.jar'
COPY docker_services.sh /app/docker_services.sh

# default command
CMD ["supervisord", "-c", "/etc/supervisor.conf"]



#CMD ["/bin/bash", "/app/docker_services.sh"]
#CMD ["mongod"]

#ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/imageProcess.jar"]


