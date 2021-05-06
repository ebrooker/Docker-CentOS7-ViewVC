FROM centos:7

LABEL Maintainer="Ezra S. Brooker https://github.com/ebrooker" \
      Description="ViewVC 1.2.1 (CVS & SVN repository viewer) based on CentOS 7 setup"

# This setup circumvents the issues related to CentOS 8 no longer supporting Python 2,
# in particular, the subversion-python dependencies required to run Python 2 version of
# ViewVC. This will become obselete once (and if) ViewVC is ported to Python 3 and the
# Subversion 1.14 release is made available on CentOS 8. See README for more details at
# https://github.com/ebrooker/

#########################################

#------------------
# install packages
#------------------
RUN yum clean all && yum update -y && yum install -y \
    cvs \
    cvsgraph \
    fcgiwrap \
    mime-support \
    httpd \
    httpd-tools \
    subversion \
    subversion-tools \
    mod_dav_svn \
    supervisor \
    python-chardet \
    python-pygments \
    subversion-python \
    && rm -rf /var/lib/apt/lists/*


# Configure mount points for CVS and SVN repos as needed
# RUN mkdir -p /cvs && chgrp apache /cvs
RUN mkdir -p /svn && chgrp apache /svn

#---------------
# httpd server
#---------------

# Configure httpd server
COPY ./configs/httpd.conf-local /etc/httpd/conf/httpd.conf

# Configure html website w/ local html setup
COPY ./html-local/               /var/www/html
# COPY ./html-local/htaccess-local /var/www/html/.htaccess


#---------------
# svn setup
#---------------

# Configure httpd for SVN use and login
COPY ./configs/svn.conf-local  /etc/httpd/conf.d/svn.conf
COPY ./configs/svn.users-local /etc/httpd/svn.users

#---------------
# ViewVC setup
#---------------

# Configure ViewVC using pre-installed version stored in compressed file
# Currently using ViewVC version 1.2.1 (latest)
COPY ./viewvc-installed-local.tar.gz /etc/viewvc-installed.tar.gz
RUN  tar -xzvf                       /etc/viewvc-installed.tar.gz -C /etc/
COPY ./configs/viewvc.conf-local     /etc/viewvc/viewvc.conf
COPY ./configs/viewvc.conf-local     /etc/viewvc/viewvc.conf.dist

# Start up the Apache server
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]

# Nothing else left to do for now
