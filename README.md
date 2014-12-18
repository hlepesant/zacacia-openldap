# Zacacia OpenLDAP

Zacacia is a Symfony2 base web application.
Zacacia store identity a,d other mail based object to OpenLDAP.

This LDAP objects are used by [Zarafa](http://www.zarafa.com/) 

Zarafa, The Best Open Source Email & Collaboration Software, is an Ms Exchange alternative.

This Dockerfile build the Apache Web Server need to run this appication.

## Usage

```
$ docker run -p 389:389 -d hlepesant/zacacia-openldap
```
