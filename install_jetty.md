1.Download Jetty

```
Open link:
    http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.2.12.v20150709/    

Download jetty-distribution-9.2.12.v20150709.tar.gz 
```

2.Install

```
Create jetty home folder:
    mkdir -p /usr/local/jetty

Extract the package:
    tar -xvf jetty-distribution-9.2.12.v20150709.tar.gz -C /usr/local/jetty --strip-components=1
```

3.Set the Jetty Environment

```
Open file /etc/profile and append content:

export JETTY_HOME=/usr/local/jetty
export PATH=$PATH:$JETTY_HOME/bin

Execute Linux command(just make it work):

    source /etc/profile
```
4.Jetty Document

    http://www.eclipse.org/jetty/documentation/current/

5.deploy jetty project

Create a jetty base 
```
mkidr jetty_base
cd jetty_base
java -jar $JETTY_HOME/start.jar --add-to-start=http,deploy
cp target/app.war ./root.war
java -jar $JETTY_HOME/start.jar
```

