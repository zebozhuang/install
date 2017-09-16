#下载和安装coturnserver ice服务器
```
Wiki:
配置:https://github.com/coturn/coturn/wiki/CoturnConfig
下载:https://github.com/coturn/coturn/wiki/Downloads
```

##1.下载
```
wget http://turnserver.open-sys.org/downloads/v4.5.0.6/turnserver-4.5.0.6.tar.gz
wget https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
```
##2.安装
###2.1安装libevent
```
tar xvfz libevent-2.0.21-stable.tar.gz
cd libevent-2.0.21-stable
./configure
make
make install
```
###2.2安装turn
```
tar xvfz turnserver-4.5.0.6.tar.gz
cd turnserver-4.5.0.6
./configure
make
make install
```
###2.3配置turn
```
cd turnserver-4.5.0.6
cp examples/etc/turnserver.conf /etc/
```

