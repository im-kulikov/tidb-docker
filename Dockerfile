FROM golang:latest as builder

RUN set -x \
    && mkdir -p /go/src/github.com/pingcap/tidb/ \
    && cd /go/src/github.com/pingcap/tidb/ \
    && git clone --depth 1 --branch v1.0.0 https://github.com/pingcap/tidb.git .

RUN set -x \
    && cd /go/src/github.com/pingcap/tidb/ \
    && make

# Executable image
FROM scratch

COPY --from=builder /go/src/github.com/pingcap/tidb/tidb-server /tidb-server

WORKDIR /

ENTRYPOINT ["/tidb-server"]