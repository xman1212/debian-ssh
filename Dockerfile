FROM debian:latest
#
#
#
MAINTAINER "Kirill Müller" <krlmlr+docker@mailbox.org>

# Install packages
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server sudo 

# GameServewr dep
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install vim subversion libsasl2-modules-gssapi-mit krb5-user krb5-config wget locales 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mongodb python net-tools
RUN wget -O /etc/krb5.conf http://sac.x.netease.com:8660/download/svn/krb5.conf
RUN apt-get autoremove && apt-get autoclean

# GameServewr pip pkg
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py
RUN pip install --index-url https://pip.nie.netease.com/simple/ gpost
RUN pip install requests

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
  && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config \
  && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && touch /root/.Xauthority \
  && true

## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory, but also be able to sudo
RUN useradd docker \
        && passwd -d docker \
        && mkdir /home/docker \
        && chown docker:docker /home/docker \
        && addgroup docker staff \
        && addgroup docker sudo \
        && true

# New user
RUN useradd -ms /bin/bash xiang \
        && addgroup xiang sudo \
        && addgroup xiang root \
        && passwd -d root \
        && passwd -d xiang 

# ssh
EXPOSE 22 
# db storage path: /var/lib/mongodb/

CMD ["/bin/bash", "/run.sh"]


