FROM postgres:9.6-alpine
MAINTAINER Eric Rasche <esr@tamu.edu>

RUN apk update && \
	apk add curl wget netcat postgresql-client postgresql-dev

RUN curl https://dl.minio.io/client/mc/release/linux-amd64/mc > /usr/local/bin/mc && \
	chmod +x /usr/local/bin/mc && \
	mkdir /backup

VOLUME ["/backup"]

ENV CRON_TIME="0 0 * * *"

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
