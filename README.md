### build keystone images
```
docker build -f Dockerfile  -t keystone .

```
### create container from images

```
docker run  -it --privileged -e MYSQL_DB_HOST=mysqlhost  -e KEYSTONE_HOST=keystonehost   -p 5000:5000  --name samplekeystone  keystone

mysqlhost = mysql ip address or container name

keystonehost = keystone ip address or container name

```
### exec container 

```
 docker exec -it samplekeystone /bin/bash

```

### remove container 

```
docker rm -f samplekeystone

```
