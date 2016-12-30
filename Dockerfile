FROM debian:jessie

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.12.5
ENV DOCKER_SHA256 0058867ac46a1eba283e2441b1bb5455df846144f9d9ba079e97655399d4a2c6
ENV COMPOSE_VERSION 1.9.0

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	apt-utils \
	ca-certificates \
	curl \
	make \
	&& rm -rf /var/lib/apt/lists/* \
	&& echo "\nexport TERM=xterm" >> /etc/bash.bashrc

RUN set -x \
	&& curl -fSL "http://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
	&& echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz \
	&& docker -v

RUN set -x \
	&& curl -fSL http://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose

COPY docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["sh"]
