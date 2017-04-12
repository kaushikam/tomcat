From phusion/baseimage:v0.9.21

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN sed -i "s/#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config