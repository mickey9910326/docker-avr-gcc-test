FROM alpine:3.7

ENV PATH $PATH:/usr/local/avr/bin

RUN apk add --no-cache openssl bash git gcc g++ libc-dev gmp-dev mpfr-dev mpc1-dev make cmake
RUN apk add --no-cache curl python3
# Create build folder

RUN NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && mkdir /tmp/distr && cd /tmp/distr \
#
# Download sources
#
&& wget http://ftp.acc.umu.se/mirror/gnu.org/gnu/gcc/gcc-8.1.0/gcc-8.1.0.tar.xz \
&& wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-2.0.0.tar.bz2 \
#
# Build gcc
#
&& tar -xvf gcc-8.1.0.tar.xz && cd gcc-8.1.0 \
&& mkdir build && cd build \
&& ../configure --prefix=/usr/local/avr --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 \
&& make -j${NPROC} && make install && cd ../.. \
#
# Building avr-libc
#
&& bunzip2 -c avr-libc-2.0.0.tar.bz2 | tar xf - && cd avr-libc-2.0.0 \
&& ./configure --prefix=/usr/local/avr --build=`./config.guess` --host=avr \
&& make -j${NPROC} && make install && cd ../.. \
&& rm -rf /tmp/distr \
&& apk del openssl libc-dev gmp-dev mpfr-dev mpc1-dev \
#
# Install python module
#
&& python3 -m pip install requests 