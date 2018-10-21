FROM golang:1.11.1-alpine AS build

RUN apk add --no-cache ca-certificates git tzdata zip \
 && cd /usr/share/zoneinfo && zip -r -0 /zoneinfo.zip .

COPY go.mod go.sum /mstdn-ebooks/
RUN cd /mstdn-ebooks \
 && CGO_ENABLED=0 go mod download

COPY . /mstdn-ebooks
RUN cd /mstdn-ebooks \
 && CGO_ENABLED=0 go build

FROM scratch

ENV ZONEINFO /zoneinfo.zip
COPY --from=build /zoneinfo.zip /
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=build /mstdn-ebooks/mstdn-ebooks /usr/local/bin/
VOLUME /mstdn-ebooks/data
WORKDIR /mstdn-ebooks/data

CMD ["mstdn-ebooks", "-server", "https://botsin.space"]
