From alpine:3.3

MAINTAINER Sebastian Klatt <sebastian@markow.io>
LABEL description="Caddy is a lightweight, general-purpose web server." \
      version="0.8.0"

ENV OPENSSL_VERSION 1.0.2e-r0

RUN apk upgrade --no-cache --available && \
    apk add --no-cache \
        curl \
        ca-certificates \
        "openssl>=${OPENSSL_VERSION}"

RUN mkdir /tmp/caddy && \
    curl -sL -o /tmp/caddy/caddy_linux_amd64.tar.gz "https://github.com/mholt/caddy/releases/download/v0.8.0/caddy_linux_amd64.tar.gz" && \
    tar -xzf /tmp/caddy/caddy_linux_amd64.tar.gz -C /tmp/caddy && \
    mv /tmp/caddy/caddy /usr/bin/caddy && \
    chmod 755 /usr/bin/caddy && \
    rm -rf /tmp/caddy

RUN mkdir -p /etc/caddy && \
    adduser -SD -h /etc/caddy -s /sbin/nologin caddy

VOLUME /etc/caddy
VOLUME /var/www

COPY Caddyfile /etc/caddy/

EXPOSE 80 443

USER caddy
WORKDIR /var/www

CMD ["-conf=/etc/caddy/Caddyfile"]
ENTRYPOINT ["/usr/bin/caddy", "-agree"]
