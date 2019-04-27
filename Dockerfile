FROM jrottenberg/ffmpeg:4.1-alpine

RUN apk add --no-cache bash

WORKDIR /usr/src/ffmpeg-watch-encode

COPY crontab /etc/crontabs/root

VOLUME [ "/watch", "/output", "/copy", "/logs" ]

COPY encode.sh .

ENTRYPOINT [ "crond" ]

CMD ["-f", "-d", "8"]