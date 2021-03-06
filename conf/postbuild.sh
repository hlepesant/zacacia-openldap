#!/bin/bash


if [ -f "/tmp/pwd.ldif" ]
then
	/usr/bin/ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/pwd.ldif
fi

if [ -f "/tmp/olcLog.ldif" ]
then
        touch /var/log/slapd.log
        chown openldap:openldap /var/log/slapd.log
	/usr/bin/ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/olcLog.ldif
fi

if [ -f "/tmp/olcDbIndex.ldif" ]
then
	/usr/bin/ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/olcDbIndex.ldif
fi

if [ -f "/tmp/zacacia.ldif" ]
then
	/usr/bin/ldapadd -x -D cn=admin,dc=zarafa,dc=com -w password -f /tmp/zacacia.ldif
fi
