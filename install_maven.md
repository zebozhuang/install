1.Download Maven

```

Open website 

    http://maven.apache.org/download.cgi

Download the latest maven(apache-maven-x.x.x-bin.tar.gz)
We download the package apache-maven-3.5.0-bin.tar.gz

2.Install 

```
Here we put the package in /usr/local when we deploy project in server.
We can put the package in our home direction such as /home/dev/(in linux) When
develop our server code. 

Extract package with the following command:

    tar -xvf apache-maven-3.5.0-bin.tar.gz 
```

3.Set the Maven Environment:

```
Open file /etc/profile and append content:

export MAVEN_HOME=/usr/local/apache-maven-3.5.0
export PATH=$PATH:$MAVEN_HOME/bin

Execute Linux command(just make it work):

    source /etc/profile
```

4.Test

```
Execute Linux command:

mvn -v

Output(See!It needs java):

Apache Maven 3.5.0 (ff8f5e7444045639af65f6095c62210b5713f426; 2017-04-04T03:39:06+08:00)
Maven home: /usr/local/apache-maven-3.5.0
Java version: 1.8.0_111, vendor: Oracle Corporation
Java home: /usr/local/jdk1.8.0_111/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "3.13.0-86-generic", arch: "amd64", family: "unix"
```

5.Set Maven Reposity

```

Maven Reposity is used to download any jar package we need in our project.
The default path of maven reposity is ~/.m2(~ means our home directory).

Open settings.xml in the folder /usr/local/apache-maven-3.5.0/conf

Find <settings> label, add <localResposity> as following:

    <localRepository>/opt/MavenRepository</localRepository>


Create folder /opt/MavenRepository:

    mkdir -p /opt/MavenRepository

```
6.Set Maven Mirrors
```
Maven Mirrors is used to download jar packages

Open settings.xml in the folder /usr/local/apache-maven-3.5.0/conf

Find label <mirrors>, add <mirror>

    <mirror>
      <id>ibiblio.org</id>
      <name>ibiblio Mirror of http://maven.ibiblio.org/maven2/</name>
      <url>http://maven.ibiblio.org/maven2/</url>
      <mirrorOf>central</mirrorOf>
    </mirror>

Copy settings.xml to /opt/MavenRepository

```
7. Maven Command
7.1 Build Project
```
    mvn package  (run test)
    OR
    mvn compile war:war (no test)
```
