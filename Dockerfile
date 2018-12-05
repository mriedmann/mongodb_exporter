FROM golang:alpine

ENV CGO_ENABLED=0 
ENV GOOS=linux 
ENV GOARCH=amd64 

RUN apk add --no-cache git
RUN go get -u github.com/AlekSi/gocoverutil
RUN go get -u github.com/prometheus/promu

WORKDIR /go/src/github.com/percona/mongodb_exporter
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

FROM        quay.io/prometheus/busybox:latest
MAINTAINER  Alexey Palazhchenko <alexey.palazhchenko@percona.com>

COPY --from=0 /go/bin/mongodb_exporter /bin/mongodb_exporter

EXPOSE      9216
ENTRYPOINT  [ "/bin/mongodb_exporter" ]
