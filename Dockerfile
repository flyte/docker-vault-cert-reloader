FROM alpine:latest

RUN apk add --no-cache inotify-tools

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
