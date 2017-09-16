#!/usr/bin/env bash

# 这个脚本是安装redis mongodb mysql openresty jdk maven jetty
#

DEFAULT_PKG_FOLDER='/pkg/'
PKG_FOLDER=''

function _makedir() {
    # create folder
    if [ -z  "$1" ]; then
        PKG_FOLDER=$DEFAULT_PKG_FOLDER
    else
        PKG_FOLDER=$1
    fi

    mkdir -p $PKG_FOLDER
    echo "Directory: ["$PKG_FOLDER"] is created."
}


function install_mongodb() {
    _makedir
    cd $PKG_FOLDER

    apt-get update -y
    apt-get install -y libssl1.0.0 libssl-dev
    ln -s /lib/x86_64-linux-gnu/libssl.so.1.0.0 /lib/x86_64-linux-gnu/libssl.so.10
    ln -s /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/libcrypto.so.10

    MONGODB_DIR='/usr/local'
    MONGODB_HOME='/usr/local/mongodb'
    PACKAGE="mongodb-linux-x86_64-ubuntu1604-3.4.4.tgz"

    if [ ! -f $PACKAGE ]; then
        wget "https://fastdl.mongodb.org/linux/"$PACKAGE
    fi

    if [ -d "$MONGODB_DIR/mongodb" ]; then
        mv $MONGODB_HOME $MONGODB_HOME_`date +"%Y_%m_%d_%H_%M_%S"`
    fi

    mkdir -p $MONGODB_HOME && tar -xvf $PACKAGE -C $MONGODB_HOME --strip-components=1


    echo '
export MONGODB_HOME=/usr/local/mongodb
export PATH=$PATH:$MONGODB_HOME/bin/
' >> /etc/profile

    source /etc/profile

    echo '
systemLog:
    # To configure the default log level for all components, use systemLog.verbosity setting.
    verbosity: 0        # 0 - 5
    # To configure the level of specific components, use the systemLog.component.<name>.verbosity settings.
    component:
        query:
            verbosity: 2
        storage:
            verbosity: 2
            journal:
                verbosity: 1
    destination: file   # file or syslog
    path: "/data/mongodb/log/mongod.log"
    logAppend: true
    logRotate: reopen
    timeStampFormat: ctime

storage:
    journal:
        enabled: true
    dbPath: /data/mongodb/data

processManagement:
    fork: true

net:
    bindIp: 127.0.0.1
    port: 29017
security:
    authorization: enabled

#setParameter:
#    enableLocalhostAuthBypass: false
' > /etc/mongod.conf

    mkdir -p /data/mongodb/log/
    mkdir -p /data/mongodb/data/

    count=`ps -ef | grep mongod | grep -v 'grep' | wc -l`
    if [ 0 == $count ]; then
        mongod -f /etc/mongod.conf
    fi
    echo "install mongodb done!"
}

function install_mysql() {
    _makedir

    cd $PKG_FOLDER

    apt-get update -y
    apt-get install -y bison openssl libncurses5-dev perl cmake

    PACKAGE_1="mysql-5.7.18.tar.gz"
    PACKAGE_2="mysql-boost-5.7.18.tar.gz"

    if [ ! -f $PACKAGE_1 ]; then
        wget "https://cdn.mysql.com//Downloads/MySQL-5.7/"$PACKAGE_1
    fi

    if [ ! -f $PACKAGE_2 ]; then
        wget "https://dev.mysql.com/get/Downloads/MySQL-5.7/"$PACKAGE_2
    fi

    tar -xvf $PACKAGE_1
    tar -xvf $PACKAGE_2

    cd mysql-5.7.18
    cmake . \
        -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
        -DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
        -DDEFAULT_CHARSET=utf8 \
        -DDEFAULT_COLLATION=utf8_general_ci \
        -DWITH_EXTRA_CHARSETS=all \
        -DWITH_MYISAM_STORAGE_ENGINE=1 \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DWITH_MEMORY_STORAGE_ENGINE=1 \
        -DWITH_READLINE=1 \
        -DENABLED_LOCAL_INFILE=1 \
        -DMYSQL_USER=mysql \
        -DWITH_BOOST=boost
        -DWITH_DEBUG=0

    make && make install

    groupadd mysql
    useradd mysql -g mysql

    mkdir -p /data/mysql/data
    mkdir -p /data/mysql/log
    mkdir -p /data/mysql/bin-log
    chown -R mysql:mysql /data/mysql

    echo '
[mysqld]
character_set_server=utf8

server_id=1
port=3306

basedir=/usr/local/mysql
datadir=/data/mysql/data
pid-file=/data/mysql/mysql.pid

log-bin=/data/mysql/bin-log/mysql-bin
sync-binlog=1

general_log=1
log-error=/data/mysql/log/error.log
general_log_file=/data/mysql/log/mysql.log
bind-address=0.0.0.0

# binlog-do-db= ...
binlog-ignore-db=mysql
innodb_buffer_pool_size=128M
query_cache_size=134217728   # 128M
query_cache_type=1
max_allowed_packet=16M       # 16M
wait_timeout=28800
interactive_timeout=28800
    ' > /etc/my.cnf

    echo 'export PATH=$PATH:/usr/local/mysql/bin/' >> /etc/profile
    source /etc/profile

    # initial mysql
    mysqld  --defaults-file=/etc/my.cnf --user=mysql --initialize
    cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld

    systemctl enable mysqld.service

    /etc/init.d/mysqld start
    echo 'install mysql done!'
}

function install_redis() {
    _makedir

    cd $PKG_FOLDER
    PACKAGE="redis-3.2.9.tar.gz"
    if [ ! -f $PACKAGE ]; then
        wget "http://download.redis.io/releases/"$PACKAGE
    fi

    tar -xvf $PACKAGE
    cd redis-3.2.9
    make && make install

    if [ -f "/etc/redis.conf" ]; then
        mv /etc/redis.conf /etc/redis.conf_`date +"%Y_%m_%d_%H_%M_%S"`
    fi
    cp redis.conf /etc/
    echo '
daemonize yes
dir /data/redis/
logfile "/data/redis/log/redis.log"
' >> /etc/redis.conf
    mkdir -p /data/redis/log
    redis-server /etc/redis.conf
}

function install_openresty() {
    _makedir
    cd $PKG_FOLDER

    apt-get update -y
    apt-get install -y libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential libgd2-xpm-dev libxml2 libxml2-dev libxslt-dev geoip-database libgeoip-dev make gcc g++

    PACKAGE="openresty-1.11.2.3.tar.gz"
    if [ ! -f "$PACKAGE" ]; then
        wget https://openresty.org/download/$PACKAGE
    fi

    mkdir ./openresty && tar -xvf $PACKAGE -C ./openresty --strip-components=1

    cd openresty && ./configure \
        --prefix=/usr/local/openresty/ \
        --with-debug --with-cc-opt='-DNGX_LUA_USE_ASSERT -DNGX_LUA_ABORT_AT_PANIC -O2' \
        --conf-path=/etc/nginx/nginx.conf \
        --with-luajit \
        --with-pcre-jit \
        --with-http_iconv_module \
        --with-http_addition_module \
        --with-http_dav_module \
        --with-http_geoip_module \
        --with-http_gzip_static_module \
        --with-http_image_filter_module \
        --with-http_realip_module \
        --with-http_stub_status_module \
        --with-http_ssl_module \
        --with-http_sub_module \
        --with-http_xslt_module \
        --with-ipv6 \
        --with-mail \
        --with-mail_ssl_module
    make && make install

    # 杀死进程
    ps -ef | grep nginx | grep -v 'grep' | awk '{print $2}' | xargs kill -9

    # 删除旧的
    if [ -f /usr/bin/nginx ]; then
        rm /usr/bin/nginx
    fi
    ln -s /usr/local/openresty/nginx/sbin/nginx /usr/bin/nginx
    nginx
}

function install_jdk() {
    _makedir
    cd $PKG_FOLDER

    if [ ! -f "jdk-8u131-linux-x64.tar.gz" ]; then
        DOWNLOAD_LINK="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz"
        wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $DOWNLOAD_LINK
    fi

    JAVA_HOME="/usr/local/jdk"
    mkdir -p $JAVA_HOME && tar -xvf jdk-8u131-linux-x64.tar.gz -C $JAVA_HOME --strip-components=1

    echo '
export JAVA_HOME=/usr/local/jdk
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
' >> /etc/profile

    source /etc/profile
    java -version
    echo "install jdk done!"
}

function install_maven() {
    _makedir
    cd $PKG_FOLDER

    wget http://apache.fayea.com/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz

    MAVEN_HOME='/usr/local/maven'
    mkdir -p $MAVEN_HOME && tar -xvf apache-maven-3.5.0-bin.tar.gz -C $MAVEN_HOME --strip-components=1

    echo '
export MAVEN_HOME=/usr/local/maven
export PATH=$PATH:$MAVEN_HOME/bin
' >> /etc/profile
    source /etc/profile
    mvn -v
    echo 'maven install done!'
}

function install_jetty() {
    _makedir
    cd $PKG_FOLDER

    wget http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.2.12.v20150709/jetty-distribution-9.2.12.v20150709.tar.gz

    JETTY_HOME="/usr/local/jetty"
    mkdir -p $JETTY_HOME && tar -xvf jetty-distribution-9.2.12.v20150709.tar.gz -C $JETTY_HOME --strip-components=1

    echo '
export JETTY_HOME=/usr/local/jetty
export PATH=$PATH:$JETTY_HOME/bin
' >> /etc/profile

    source /etc/profile

}

function install()
    for var in "$@"
    do
        if [ $var == "mongodb" ]; then
            echo "install mongodb-----"
            install_mongodb
        fi
        if [ $var == "mysql" ]; then
            echo "install mysql-------"
            install_mysql
        fi
        if [ $var == "redis" ]; then
            echo "install redis-------"
            install_redis
        fi
        if [ $var == "openresty" ]; then
            echo "install openresty---"
            install_openresty
        fi
        if [ $var == "jdk" ]; then
            echo "install jdk---------"
            install_jdk
        fi
        if [ $var == "maven" ]; then
            echo "install maven-------"
            install_maven
        fi
        if [ $var == "jetty" ]; then
            echo "install jetty-------"
            install_jetty
        fi
    done

# 安装全部
#install redis mongodb mysql openresty jdk maven jetty
# 单独安装mysql
install mysql
# 单独安装redis
#install redis
# 单独安装mongodb
#install mongodb
# 单独安装 openresty
#install openresty
# 单独安装 jdk
#install jdk
# 单独安装 maven
#install maven
# 单独安装jetty
#install jetty
