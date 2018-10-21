FROM golang:1.11.1-alpine AS build

RUN apk add --no-cache git

COPY go.mod go.sum /mstdn-ebooks/
RUN cd /mstdn-ebooks \
 && CGO_ENABLED=0 go mod download

COPY . /mstdn-ebooks
RUN cd /mstdn-ebooks \
 && CGO_ENABLED=0 go build

FROM scratch

COPY --from=build /mstdn-ebooks/mstdn-ebooks /usr/local/bin/
VOLUME /mstdn-ebooks/data
WORKDIR /mstdn-ebooks/data

CMD ["mstdn-ebooks", "-server", "https://botsin.space"]
