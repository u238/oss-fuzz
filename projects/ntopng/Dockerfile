FROM gcr.io/oss-fuzz-base/base-builder

RUN apt-get install --yes build-essential git bison flex libxml2-dev libpcap-dev libtool libtool-bin rrdtool
RUN apt-get install --yes libpcap0.8 librrd4 libzmq5 libjson-c2 libsnmp30 libmaxminddb0 libhiredis0.13 libmysqlclient20 libcurl3
RUN apt-get install --yes librrd-dev autoconf pkg-config automake autogen redis-server wget libsqlite3-dev
RUN apt-get install --yes libhiredis-dev libmaxminddb-dev libcurl4-openssl-dev libpango1.0-dev libcairo2-dev libnetfilter-queue-dev
RUN apt-get install --yes zlib1g-dev libssl-dev libcap-dev libnetfilter-conntrack-dev libreadline-dev libjson-c-dev libldap2-dev
RUN apt-get install --yes rename libsnmp-dev
RUN apt-get install --yes libmysqlclient-dev libzmq3-dev

# checkout all sources needed to build your project
RUN git clone https://github.com/ntop/ntopng.git

#COPY . ntopng
RUN git clone https://github.com/ntop/nDPI.git

# copy build script and other fuzzer files in src dir
COPY build.sh *_fuzzer.cpp $SRC/
COPY Makefile.in.patch $SRC/

# current directory for the build script
WORKDIR $SRC
