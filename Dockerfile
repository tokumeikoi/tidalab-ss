FROM alpine:latest

WORKDIR /tidalab

RUN cd /tidalab

COPY tidalab-ss /tidalab
COPY outline-ss-server /tidalab
COPY prometheus /tidalab

RUN chmod +x /tidalab/*

ENTRYPOINT /tidalab/tidalab-ss -api="$API" -token="$TOKEN" -node="$NODE" -license="$LICENSE" -syncInterval="$SYNCINTERVAL"
