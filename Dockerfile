FROM centos:7 as bitrixenv

WORKDIR /build
ADD build.sh /build
RUN /build/build.sh

FROM node:8-alpine

EXPOSE 80

WORKDIR /opt/push-server

COPY --from=bitrixenv /opt/push-server /opt/push-server

RUN set -x && \
    apk add --update "libintl" && \
    apk add --virtual build_deps "gettext" &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

ADD run.sh /opt/push-server
ADD config.template.json /etc/push-server/

ENV LISTEN_PORT 8010
ENV LISTEN_HOSTNAME 0.0.0.0
ENV REDIS_HOST redis
ENV REDIS_PORT 6379
ENV SECURITY_KEY changeme
ENV MODE pub

ENTRYPOINT ["./run.sh"]