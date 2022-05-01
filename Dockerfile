FROM nginx:latest

RUN apt-get update
RUN apt-get -y install git cgit fcgiwrap

STOPSIGNAL SIGTERM

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
