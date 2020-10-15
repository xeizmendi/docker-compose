FROM docker:18.06.2 as docker
FROM alpine:3.8

ENV GLIBC 2.28-r0
ENV COMPOSE_VERSION 1.23.2

RUN apk update && apk add --no-cache openssl ca-certificates curl libgcc make unzip zip git openssh-client bash parallel grep sed && \
    curl -fsSL -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    curl -fsSL -o glibc-$GLIBC.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk && \
    apk add --no-cache glibc-$GLIBC.apk && \
    ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ && \
    ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib && \
    ln -s /usr/lib/libgcc_s.so.1 /usr/glibc-compat/lib && \
    rm /etc/apk/keys/sgerrand.rsa.pub glibc-$GLIBC.apk

COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker /usr/local/bin/modprobe /usr/local/bin/modprobe
COPY --from=docker /usr/local/bin/docker-entrypoint.sh /usr/local/bin/

RUN set -x \
	&& curl -fSL https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash"]
