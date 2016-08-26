FROM ubuntu:14.04

ENV SWIFT_SNAPSHOT swift-DEVELOPMENT-SNAPSHOT-2016-07-25-a
ENV UBUNTU_VERSION ubuntu14.04
ENV UBUNTU_VERSION_NO_DOTS ubuntu1404
ENV HOME /root
ENV WORK_DIR /root
ENV LIBDISPATCH_BRANCH experimental/foundation

# Set WORKDIR
WORKDIR ${WORK_DIR}

# Linux OS utils
RUN apt-get update && apt-get install -y \
  automake \
  build-essential \
  clang \
  curl \
  gcc-4.8 \
  git \
  g++-4.8 \
  libblocksruntime-dev \
  libbsd-dev \
  libglib2.0-dev \
  libpython2.7 \
  libicu-dev \
  libkqueue-dev \
  libtool \
  lsb-core \
  openssh-client \
  vim \
  wget \
  binutils-gold \
  libcurl4-openssl-dev \
  openssl \
  libssl-dev


ADD .vim /root/.vim
ADD .vimrc /root/.vimrc

RUN echo "set -o vi" >> /root/.bashrc

# Install Swift compiler
RUN wget https://swift.org/builds/development/$UBUNTU_VERSION_NO_DOTS/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz \
  && tar xzvf $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz \
  && rm $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
ENV PATH $WORK_DIR/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr/bin:$PATH
RUN swiftc -h

#Hack to force usage of the gold linker
RUN rm /usr/bin/ld && ln -s /usr/bin/ld.gold /usr/bin/ld

# Clone and install swift-corelibs-libdispatch
RUN git clone -b $LIBDISPATCH_BRANCH https://github.com/apple/swift-corelibs-libdispatch.git \
  && cd swift-corelibs-libdispatch \
  && git submodule init \
  && git submodule update \
  && sh ./autogen.sh \
  && CFLAGS=-fuse-ld=gold ./configure --with-swift-toolchain=$WORK_DIR/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr --prefix=$WORK_DIR/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr \
  && make \
  && make install

//Done with installing swift. Should install jenkins now
RUN wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
RUN apt-get update
RUN apt-get install jenkins -y
EXPOSE 8080
CMD /usr/bin/java -jar /usr/share/jenkins/jenkins.war
