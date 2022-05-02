FROM nginx:latest

RUN apt-get update
RUN apt-get -y install git cgit fcgiwrap python3 python3-pygments
RUN sed -i 's/pastie/friendly/' /usr/lib/cgit/filters/syntax-highlighting.py

STOPSIGNAL SIGTERM

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
