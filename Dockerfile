# Builder image
FROM golang:latest as builder

RUN set -x \
    && mkdir -p /go/src/github.com/pingcap/tidb/ \
    && cd /go/src/github.com/pingcap/tidb/ \
    && git clone --depth 1 --branch v1.0.2 https://github.com/pingcap/tidb.git .

RUN set -x \
    && cd /go/src/github.com/pingcap/tidb/ \
    && make

RUN chmod +x /go/src/github.com/pingcap/tidb/bin/tidb-server

# Executable image
FROM scratch

COPY --from=builder /go/src/github.com/pingcap/tidb/bin/tidb-server /tidb-server

WORKDIR /

ENTRYPOINT ["/tidb-server"]