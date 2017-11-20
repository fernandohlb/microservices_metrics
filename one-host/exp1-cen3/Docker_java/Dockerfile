FROM ubuntu

MAINTAINER Fernando H. L. Buzato

#Instala o Java

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list

RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

RUN apt-get update

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN apt-get install oracle-java8-installer -y

#Faz o deploy da aplicação
ADD imageProcess-0.0.1-SNAPSHOT.jar imageProcess.jar
RUN bash -c 'touch /imageProcess.jar'

EXPOSE 8091

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-jar","/imageProcess.jar"]  

#"-Dspring.data.mongodb.uri=mongodb://mongodb-split/image-process",




