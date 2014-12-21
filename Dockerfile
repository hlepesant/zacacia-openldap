FROM debian:wheezy

MAINTAINER hlepesant <hugues@lepesant.com>

ENV DEBIAN_FRONTEND noninteractive

ENV SHELL /bin/bash

RUN echo 'shell /bin/bash' > ~/.screenrc

RUN echo "deb http://ftp.fr.debian.org/debian/ wheezy main contrib non-free" > /etc/apt/sources.list
RUN echo "deb-src http://ftp.fr.debian.org/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://security.debian.org/ wheezy/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://ftp.fr.debian.org/debian/ wheezy-updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://ftp.fr.debian.org/debian/ wheezy-updates main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade
RUN apt-get -y install curl sudo apt-utils net-tools procps vim ldap-utils
# RUN apt-get -y install slapd
# RUN apt-get clean


## install slapd in noninteractive mode
RUN echo 'slapd/root_password password password' | debconf-set-selections &&\
    echo 'slapd/root_password_again password password' | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils

RUN apt-get clean

## set up required inputs for configuration of slapd
## debconf-set-selections is used so that we can run dpkg-reconfigure
## noninteractively below
RUN echo "slapd slapd/no_configuration boolean false" | debconf-set-selections
RUN echo "slapd slapd/domain string zarafa.com" | debconf-set-selections
RUN echo "slapd shared/organization string 'Zarafa'" | debconf-set-selections
RUN echo "slapd slapd/password1 password secret" | debconf-set-selections
RUN echo "slapd slapd/password2 password secret" | debconf-set-selections
RUN echo "jslapd slapd/backend select HDB" | debconf-set-selections
RUN echo "slapd slapd/purge_database boolean true" | debconf-set-selections
RUN echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections
RUN echo "slapd slapd/move_old_database boolean true" | debconf-set-selections

RUN dpkg-reconfigure -f noninteractive slapd


ADD conf/zacacia.conf /root/zacacia.conf
ADD conf/schema/qmail.schema /etc/ldap/schema/qmail.schema
ADD conf/schema/zarafa.schema /etc/ldap/schema/zarafa.schema
ADD conf/schema/zacacia.schema /etc/ldap/schema/zacacia.schema
 
RUN /bin/mkdir /tmp/slapd.d
RUN /usr/sbin/slaptest -f /root/zacacia.conf -F /tmp/slapd.d/
RUN /bin/cp "/tmp/slapd.d/cn=config/cn=schema/cn={4}qmail.ldif" "/etc/ldap/slapd.d/cn=config/cn=schema"
RUN /bin/cp "/tmp/slapd.d/cn=config/cn=schema/cn={5}zarafa.ldif" "/etc/ldap/slapd.d/cn=config/cn=schema"
RUN /bin/cp "/tmp/slapd.d/cn=config/cn=schema/cn={6}zacacia.ldif" "/etc/ldap/slapd.d/cn=config/cn=schema"
RUN chown openldap:openldap '/etc/ldap/slapd.d/cn=config/cn=schema/cn={4}qmail.ldif'
RUN chown openldap:openldap '/etc/ldap/slapd.d/cn=config/cn=schema/cn={5}zarafa.ldif'
RUN chown openldap:openldap '/etc/ldap/slapd.d/cn=config/cn=schema/cn={6}zacacia.ldif'
RUN /etc/init.d/slapd stop

COPY conf/pwd.ldif /tmp/pwd.ldif
COPY conf/olcDbIndex.ldif /tmp/olcDbIndex.ldif
COPY conf/zacacia.ldif /tmp/zacacia.ldif

COPY conf/postbuild.sh /root/
RUN chmod +x /conf/postbuild.sh


# RUN /usr/bin/ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/pwd.ldif
# RUN /usr/bin/ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/olcDbIndex.ldif
# RUN /usr/bin/ldapadd -x -D  cn=admin,dc=nodomain -w sercret -f /tmp/zacacia.ldif

EXPOSE 389

COPY conf/slapd-entrypoint.sh /root/
RUN chmod +x /root/slapd-entrypoint.sh
ENTRYPOINT ["/root/slapd-entrypoint.sh"]
