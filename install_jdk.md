# install java

1.Download Java SDK

```
Open following link and download Java8(accept license first), remember download Linux .tar.gz package.
If your machine is based on x64 architecture, download jdk-xxx-linux-x64.tar.gz. 
If not, please download jdk-xxx-linux-i586.tar.gz.

http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

```

2.Install JDK


```
We have already downloaded the package jdk-8u111-linux-x64.tar.gz .
Put the package under the folder /usr/local/(or any other place if like).
Extract the package with the command below:

tar -xvf jdk-8u111-linux-x64.tar.gz

Get folder /usr/local/jdk1.8.0_111
```
3.Set Java Enviroment

```
Open file /etc/profile, append the content as following:

export JAVA_HOME=/usr/local/jdk1.8.0_111
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar


Execute command(make it work):

    source /etc/profile

Test java installation:

    java -version

Output:
    java version "1.8.0_111"
    Java(TM) SE Runtime Environment (build 1.8.0_111-b14)
    Java HotSpot(TM) 64-Bit Server VM (build 25.111-b14, mixed mode)
```

