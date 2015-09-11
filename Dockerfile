FROM phusion/baseimage
MAINTAINER Jacob Sanford <jsanford_at_unb.ca>

ENV PHANTOMJS_VERSION 2.0
ENV CASPERJS_VERSION HEAD

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes

# Accept EULA for MS fonts
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections # Accept EULA for MS fonts

# Add repos for ttf-mscorefonts-installer
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list

# Install PhantomJS.
RUN apt-get update && \
  apt-get install -y git build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev python libx11-dev libxext-dev ttf-mscorefonts-installer

WORKDIR /root
RUN git clone git://github.com/ariya/phantomjs.git
WORKDIR /root/phantomjs
RUN git checkout ${PHANTOMJS_VERSION}
RUN ./build.sh --confirm
RUN ln -s /root/phantomjs/bin/phantomjs /usr/local/bin/phantomjs

# Install CasperJS.
WORKDIR /root
RUN git clone git://github.com/n1k0/casperjs.git
WORKDIR /root/casperjs
RUN git checkout ${CASPERJS_VERSION}
RUN ln -s /root/casperjs/bin/casperjs /usr/local/bin/casperjs

# Clean up.
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
