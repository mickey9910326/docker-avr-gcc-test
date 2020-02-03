FROM alpine:3.7

ENV PATH $PATH:/usr/local/avr/bin

RUN apk add --no-cache openssl bash git gcc g++ libc-dev gmp-dev mpfr-dev mpc1-dev make cmake

# Create var to save the number of processing units available
RUN NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)

# Create var to gcc version to compile
RUN GCC_VERSION=8.1.0

# Create build folder
RUN mkdir /tmp/distr && cd /tmp/distr 

# Download sources
RUN wget http://ftp.gnu.org/gnu/binutils/binutils-2.30.tar.bz2 \
    && wget http://ftp.acc.umu.se/mirror/gnu.org/gnu/gcc/gcc-$(GCC_VERSION)/gcc-$(GCC_VERSION).tar.xz \
    && wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-2.0.0.tar.bz2

# Building binutils
RUN bunzip2 -c binutils-2.30.tar.bz2 | tar xf - && cd binutils-2.30 \
    && mkdir build && cd build \
    && ../configure --prefix=/usr/local/avr --target=avr --disable-nls \
    && make -j${NPROC} && make install && cd ../.. \

# Build gcc
RUN tar -xvf gcc-$(GCC_VERSION).tar.xz && cd gcc-$(GCC_VERSION) \
    && mkdir build && cd build \
    && ../configure --prefix=/usr/local/avr --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 \
    && make -j${NPROC} && make install && cd ../.. \

# Building avr-libc
RUN bunzip2 -c avr-libc-2.0.0.tar.bz2 | tar xf - && cd avr-libc-2.0.0 \
    && ./configure --prefix=/usr/local/avr --build=`./config.guess` --host=avr \
    && make -j${NPROC} && make install && cd ../..

# Remove tmp files and apk modules
RUN rm -rf /tmp/distr \
    && apk del openssl libc-dev gmp-dev mpfr-dev mpc1-dev