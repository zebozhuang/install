##1.Configure MySQL master
    After installing mysql server, we can configure the mysql master.

###1.1　Bind Address

    Make sure that bind-address is open to mysql client
    
    ```
    bind-address=0.0.0.0
    ```

###1.2　Server Id

    Give mysql master server an server id so that the slave server can recognize it.
    ```
    server_id = 1
    ```

###1.3 Bin Log

    If slave want to replicate data from master, it must retrieve data from master's
log-bin. Master should open its log-bin. 
    
    ```
       log-bin=/data_mysql/bin-log/mysql-bin
    ```
###1.4 Sync Database
    
    We want to replcate the some of the databases so we must include them.

    ```
    binlog-do-db = database 
    binlog-do-db = database 
    binlog-ignore-db = mysql
    ```

##2.Create Replica User

###2.1 Login MySQL Master

    Open linux shell and login in MySQL
    ```
    mysql -uroot -p
    ```

###2.1 Create User

    We need to grant privileges to the slave.
    ```
    GRANT REPLICATION SLAVE ON *.* TO 'replica'@'%' IDENTIFIED BY 'password';
    FLUSH PRIVILEGES;
    ```

###2.2 Dump MySQL Master Database

    We need to dump data from database and mark the status of master.
    ```
    USE database;
    FLUSH TABLES WITH READ LOCK;
    SHOW MASTER STATUS;
    ``` 

    The master status is useful for next steps.
    +------------------+-----------+-------------------+------------------+-------------------+
    | File             | Position  | Binlog_Do_DB      | Binlog_Ignore_DB | Executed_Gtid_Set |
    +------------------+-----------+-------------------+------------------+-------------------+
    | mysql-bin.000003 | 694529034 | database          | mysql            |                   |
    +------------------+-----------+-------------------+------------------+-------------------+
    
    Dump data
    ```
    mysqldump -uroot -p --opt database > database.sql
    ```
    
    Unlock tables
    ```
    UNLOCK TABLES;
    ``` 

##3.Configure MySQL Slave

###3.1 Login Slave
    
    CREATE DATABASE database;

###3.2 Import Data

     mysql -u root -p password database < database.sql 

###3.3 Configure Slave

    ```
    server_id=2
    relay-log=/data/mysql/log/relay.log
    log_bin=/data/mysql/bin-log/mysql-bin
    binlog_do_db=database
    ```  

    Restart MySQL
    ```
    /etc/init.d/mysqld restart
    ```

###3.4 Sync Master
  
    ``` 
    CHANGE MASTER TO MASTER_HOST='12.34.56.789',MASTER_USER='replica', MASTER_PASSWORD='password', MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=694529034; 
    START SLAVE;
    ```

reference: https://www.digitalocean.com/community/tutorials/how-to-set-up-master-slave-replication-in-mysql
