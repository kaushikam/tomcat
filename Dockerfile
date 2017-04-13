From phusion/baseimage:0.9.21

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Baseimage-docker disables the SSH server by default
RUN rm -f /etc/service/sshd/down

# Set root password
RUN echo "root:secret" | chpasswd

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
RUN sed -i "s/#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config
RUN sed -i "s/#RSAAuthentication yes/RSAAuthentication yes/g" /etc/ssh/sshd_config
RUN sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
RUN sed -i "s/#AuthorizedKeysFile      .ssh\/authorized_keys/AuthorizedKeysFile      .ssh\/authorized_keys/g" /etc/ssh/sshd_config

# Install and configure JDK 8
ADD jdk-8u121-linux-x64.tar.gz /opt
ENV JAVA_HOME=/opt/jdk1.8.0_121
RUN update-alternatives --install "/usr/bin/java" "java" "$JAVA_HOME/bin/java" 1
RUN update-alternatives --install "/usr/bin/javac" "javac" "$JAVA_HOME/bin/javac" 1
RUN update-alternatives --install "/usr/bin/javaws" "javaws" "$JAVA_HOME/bin/javaws" 1

#Install and configure tomcat 8
RUN groupadd tomcat
RUN useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
ADD apache-tomcat-8.5.13.tar.gz /opt
RUN mv -v /opt/apache-tomcat-8.5.13 /opt/tomcat
RUN chgrp -R tomcat /opt/tomcat
RUN chmod -R g+r /opt/tomcat/conf
RUN chmod g+x /opt/tomcat/conf
RUN chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
RUN mkdir /etc/service/memcached
COPY memcached.sh /etc/service/memcached/run
RUN chmod +x /etc/service/memcached/run
# Baseimage-docker disables the SSH server by default
RUN rm -f /etc/service/memcached/down

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*