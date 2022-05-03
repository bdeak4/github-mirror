FROM nginx:latest

RUN apt-get update
RUN apt-get -y install git cgit fcgiwrap python3 python3-pygments
RUN sed -i 's/pastie/friendly/' /usr/lib/cgit/filters/syntax-highlighting.py

COPY cgitrc /etc/cgitrc
COPY style.css /usr/share/cgit/style.css
COPY head.html /usr/share/cgit/head.html

ARG GITHUB_USER
ARG BASIC_AUTH_PASSWORD
RUN if [ -n "$GITHUB_USER" ] && [ -n "$BASIC_AUTH_PASSWORD" ]; then \
        echo $GITHUB_USER:$BASIC_AUTH_PASSWORD > /etc/nginx/.htpasswd; \
    fi

STOPSIGNAL SIGTERM

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
