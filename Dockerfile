FROM java:7-jdk

ENV MAVEN_REPOSITORY https://repo.maven.apache.org/maven2/

RUN git clone https://github.com/wikier/marmotta-virtuoso virtuoso && cd virtuoso
RUN wget http://www.topquadrant.com/repository/spin/org/topbraid/spin/1.5.0-SNAPSHOT/spin-1.5.0-20150112.084011-1.jar && wget http://opldownload.s3.amazonaws.com/uda/virtuoso/7.2/rdfproviders/sesame/27/virt_sesame2.jar && wget http://opldownload.s3.amazonaws.com/uda/virtuoso/7.2/jdbc/virtjdbc4.jar
RUN git clone https://github.com/srdc/virt-jena && cd virt-jena && mvn install && mv target/virt-jena-2.6.2-srdc.jar ../ && cd ..

RUN sed i 's/</dependencies>/<dependency>\n<groupId>tr.com.srdc</groupId>\n<artifactId>virt-jena</artifactId>\n<version>2.6.2-srdc</version>\n</dependency>\n<dependency>\n<groupId>org.topbraid</groupId>\n<artifactId>spin4</artifactId>\n<version>1.4.0</version>\n</dependency>\n</dependencies>/' backend/pom.xml



RUN mvn install:install-file -Dfile=virtjdbc4.jar -DgroupId=com.openlinksw.virtuoso -DartifactId=virtuoso-jdbc4 -Dversion=4.0.0 -Dpackaging=jar
RUN mvn install:install-file -Dfile=virt_sesame2.jar -DgroupId=com.openlinksw.virtuoso -DartifactId=virtuoso-sesame -Dversion=2.7.0 -Dpackaging=jar
RUN mvn install:install-file -Dfile=virt_jena.jar -DgroupId=com.openlinksw.virtuoso -DartifactId=virtuoso-jena -Dversion=2.6.0 -Dpackaging=jar

WORKDIR ~/virtuoso/webapp

RUN mvn install

EXPOSE 8080
EXPOSE 1111

CMD [mvn tomcat7:run]
