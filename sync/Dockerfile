FROM debian:bullseye-slim

RUN apt-get update
RUN apt-get -y install cron git curl jq

COPY sync-repositories.sh /sync-repositories.sh
RUN chmod +x /sync-repositories.sh

COPY crontab /etc/cron.d/sync-repositories
RUN crontab /etc/cron.d/sync-repositories

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
