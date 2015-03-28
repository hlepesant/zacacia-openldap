# Zacacia OpenLDAP

Zacacia is a Symfony2 base web application.
Zacacia store identity a,d other mail based object to OpenLDAP.

This LDAP objects are used by [Zarafa](http://www.zarafa.com/) 

Zarafa, The Best Open Source Email & Collaboration Software, is an Ms Exchange alternative.

This Dockerfile build the Apache Web Server need to run this appication.

## Build

...
docker build --tag="hlepesant/zacacia-openldap:latest" .
...

## Usage

```
$ docker run -p 389:389 --name ldap -d hlepesant/zacacia-openldap:latest  
```

## Data fixtures

Install nsenter(https://github.com/jpetazzo/nsenter).
Then run

```
$ docker ps
$ docker-enter <container_ID>
root@<container_ID>: /root/postbuild.sh
root@<container_ID>: exit
```
