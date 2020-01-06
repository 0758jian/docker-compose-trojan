FROM abiosoft/caddy:builder as builder

ARG version="1.0.3"
ARG plugins="git,cors,realip,expires,cache,cloudflare"
ARG enable_telemetry="true"

# Process Wrapper
RUN go get -v github.com/abiosoft/parent

RUN VERSION=${version} PLUGINS=${plugins} ENABLE_TELEMETRY=${enable_telemetry} /bin/sh /usr/bin/builder.sh

#
# Final Stage
#
FROM alpine:3.10
LABEL maintainer "0758jian <0758jian@gmail.com>"

ARG version="1.0.3"
LABEL caddy_version="$version"

# PHP www UID and GID
ARG PUID="1000"
ARG PGID="1000"

# Let's Encrypt Agreement
ENV ACME_AGREE="false"

# Telemetry Stats
ENV ENABLE_TELEMETRY="$enable_telemetry"

RUN apk add --no-cache \
  ca-certificates \
  curl \
  git \
  mailcap \
  openssh-client \
  php7-fpm \
  tar \
  tzdata \
  libtool \
  supervisor \
  ffmpeg \
  util-linux 

# Essential PHP Extensions
RUN apk add --no-cache \
  php7-bcmath \
  php7-ctype \
  php7-curl \
  php7-dom \
  php7-exif \
  php7-fileinfo \
  php7-gd \
  php7-iconv \
  php7-json \
  php7-mbstring \
  php7-mysqli \
  php7-opcache \
  php7-openssl \
  php7-pdo \
  php7-pdo_mysql \
  php7-pdo_pgsql \
  php7-pdo_sqlite \
  php7-pgsql \
  php7-phar \
  php7-session \
  php7-simplexml \
  php7-sqlite3 \
  php7-tokenizer \
  php7-xml \
  php7-xmlreader \
  php7-xmlwriter \
  php7-zip \
  php7-redis 

# Symlink php7 to php and Symlink php-fpm7 to php-fpm
RUN ln -sf /usr/bin/php7 /usr/bin/php && ln -sf /usr/bin/php-fpm7 /usr/bin/php-fpm

# Add a PHP www instead of nobody
RUN addgroup -g ${PGID} www && \
  adduser -D -H -u ${PUID} -G www www && \
  sed -i "s|^user = .*|user = www|g" /etc/php7/php-fpm.d/www.conf && \
  sed -i "s|^group = .*|group = www|g" /etc/php7/php-fpm.d/www.conf

# Composer
RUN curl --silent --show-error --fail --location \
  --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" \
  "https://getcomposer.org/installer" \
  | php -- --install-dir=/usr/bin --filename=composer

# Install Caddy
COPY --from=builder /install/caddy /usr/bin/caddy

# Validate install
#RUN /usr/bin/caddy -version
#RUN /usr/bin/caddy -plugins

EXPOSE 80 443
WORKDIR /var/www/html

# Install Process Wrapper
COPY --from=builder /go/bin/parent /bin/parent
#add sh run crond and supervisord
RUN echo -e "#!/bin/sh \n crond -b -d 8 \n supervisord -c /etc/supervisord.conf">>/root/sr.sh && chmod +x /root/sr.sh

ENTRYPOINT ["/bin/parent", "caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE"]
