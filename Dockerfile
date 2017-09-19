FROM debian:stretch

ENV DOCKER_VERSION 17.06.2-ce
ENV DOCKER_CHANNEL stable
ENV DOCKER_SHA256 a15f62533e773c40029a61784a5a1c5bc7dd21e0beb5402fda109f80e1f2994d
ENV COMPOSE_VERSION 1.16.1

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	apt-utils \
	ca-certificates \
	curl \
	make \
	unzip \
	git-core \
	&& rm -rf /var/lib/apt/lists/* \
	&& echo "\nexport TERM=xterm" >> /etc/bash.bashrc

RUN set -x \
	&& curl -fSL "http://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
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
