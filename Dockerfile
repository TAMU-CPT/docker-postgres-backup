FROM postgres:9.6-alpine

RUN apk update && \
	apk add postgresql-client postgresql-dev

RUN mkdir /backup

VOLUME ["/backup"]

ENV CRON_TIME="0 0 * * *"

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
