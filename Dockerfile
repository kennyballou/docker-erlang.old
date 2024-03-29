# DOCKER-VERSION 1.9.1
FROM alpine:3.4
MAINTAINER kballou@devnulllabs.io

ENV LANG="en_US.UTF-8"
ENV OTP_VER="19.0"
ENV REBAR_VERSION="2.6.1"
ENV REBAR3_VERSION="3.2.0"

RUN apk update \
    && apk add \
       autoconf \
       bash \
       curl \
       gcc \
       libedit \
       m4 \
       make \
       musl-dev \
       ncurses-dev \
       ncurses-libs \
       ncurses-terminfo \
       ncurses-terminfo-base \
       openssl-dev \
       openssl \
       perl \
       tar \
       unixodbc-dev \
    && OTP_SRC_URL="https://github.com/erlang/otp/archive/OTP-$OTP_VER.tar.gz" \
    && OTP_SRC_SUM="107b629aa7aea1bf76df0197629a50ce4fea61143ebb0e9a1b633b1fbaf9beb7" \
    && curl -fSL "$OTP_SRC_URL" -o otp-src.tar.gz \
    && echo "${OTP_SRC_SUM}  otp-src.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/otp-src \
    && tar -zxf otp-src.tar.gz -C /usr/src/otp-src --strip-components=1 \
    && rm otp-src.tar.gz \
    && cd /usr/src/otp-src \
    && ./otp_build autoconf \
    && ./configure \
    && make -j 4 \
    && make install \
    && find /usr/local -name examples | xargs rm -rf \
    && cd /usr/src \
    && rm -rf /usr/src/otp-src \
    && REBAR_SRC_URL="https://github.com/rebar/rebar/archive/${REBAR_VERSION##*@}.tar.gz" \
    && REBAR_SRC_SUM="aed933d4e60c4f11e0771ccdb4434cccdb9a71cf8b1363d17aaf863988b3ff60" \
    && mkdir -p /usr/src/rebar-src \
    && curl -fSL "$REBAR_SRC_URL" -o rebar-src.tar.gz \
    && echo "${REBAR_SRC_SUM}  rebar-src.tar.gz" | sha256sum -c - \
    && tar -zxf rebar-src.tar.gz -C /usr/src/rebar-src --strip-components=1 \
    && rm rebar-src.tar.gz \
    && cd /usr/src/rebar-src \
    && ./bootstrap \
    && install -v ./rebar /usr/local/bin \
    && cd /usr/src \
    && rm -rf /usr/src/rebar-src \
    && REBAR3_SRC_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION##*@}.tar.gz" \
    && REBAR3_SRC_SUM="78ad27372eea6e215790e161ae46f451c107a58a019cc7fb4551487903516455" \
    && mkdir -p /usr/src/rebar3-src \
    && curl -fSL "$REBAR3_SRC_URL" -o rebar3-src.tar.gz \
    && echo "${REBAR3_SRC_SUM}  rebar3-src.tar.gz" | sha256sum -c - \
    && tar -zxf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
    && rm rebar3-src.tar.gz \
    && cd /usr/src/rebar3-src \
    && HOME=$PWD ./bootstrap \
    && install -v ./rebar3 /usr/local/bin \
    && rm -rf /usr/src/rebar3-src \
    && apk del \
       autoconf \
       bash \
       curl \
       gcc \
       m4 \
       make \
       musl-dev \
       ncurses-dev \
       openssl-dev \
       tar \
       unixodbc-dev

CMD ["erl"]
