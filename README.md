# OpenShift Database Backup Image
Database Backup for Openshift Pods

**Atention:**

This is a experimental image for backup MySQL, PostgreSQL and MongoDB, **use at your own risk!!**

##Versions:
MySQL versions currently supported are:
* [mysql-5.5](http://dev.mysql.com/doc/refman/5.5/en/)
* [mysql-5.6](http://dev.mysql.com/doc/refman/5.6/en/)

PostgreSQL versions currently supported are:
* [postgresql-9.2](http://www.postgresql.org/docs/9.2/static/index.html)
* [postgresql-9.4](http://www.postgresql.org/docs/9.4/static/index.html)

MongoDB versions currently supported are:
* [mongodb-2.4](https://docs.mongodb.org/v2.4/)
* [mongodb-2.6](https://docs.mongodb.org/v2.6/)

##Instalation:
You can either use our image from [dockerhub](https://hub.docker.com/r/getupcloud/backup) or build at your local machine:

To use our image:
 ```
 $ docker pull getupcloud/backup:latest
 ```

To build the image:

  ```
  $ git clone https://github.com/getupcloud/backup.git
  $ cd backup
  $ docker build -t backup:latest .
  ```
  
##Requirements:
This image expects you have a Azure Storage Account, a blob container and the keys, for more information about Azure Blob Storage please see the official [documentation](https://azure.microsoft.com/en-us/documentation/articles/storage-create-storage-account/)


##Usage:

For MySQL Database pods:

  ```
  $ ./backup.sh -e mysql -k <Azure Key> -c <Azure Container> -a <Azure Storage Account Name>

  ```

For PostgreSQL Database pods:

  ```
  $ ./backup.sh -e postgresql -k <Azure Key> -c <Azure Container> -a <Azure Storage Account Name>
  ```

For MongoDB Database pods:

  ```
  $ ./backup.sh -e mongodb -k <Azure Key> -c <Azure Container> -a <Azure Storage Account Name>
  ```

