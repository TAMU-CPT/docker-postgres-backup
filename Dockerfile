FROM postgres:9.6-alpine
MAINTAINER Eric Rasche <esr@tamu.edu>

RUN apk update && \
	apk add curl wget postgresql-client postgresql-dev

RUN mkdir /backup

VOLUME ["/backup"]

ENV CRON_TIME="0 0 * * *"

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
