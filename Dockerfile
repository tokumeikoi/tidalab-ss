FROM --platform=${TARGETOS}/${TARGETARCH} alpine:latest

ARG TARGETARCH
ARG OUTLINE_SS_VERSION=1.3.5
ARG PROMETHEUS_VERSION=2.31.1

WORKDIR /tidalab

RUN cd /tidalab

RUN wget https://github.com/tokumeikoi/tidalab-ss/releases/download/1.1/tidalab-ss-$TARGETARCH -O /tidalab/tidalab-ss

RUN case "${TARGETARCH}" in \
    "amd64") \
        wget "https://github.com/Jigsaw-Code/outline-ss-server/releases/download/v${OUTLINE_SS_VERSION}/outline-ss-server_${OUTLINE_SS_VERSION}_linux_x86_64.tar.gz" &&\
		tar -xzv -C /tidalab -f outline-ss-server_${OUTLINE_SS_VERSION}_linux_x86_64.tar.gz outline-ss-server \
        ;; \

    "arm64") \
        wget "https://github.com/Jigsaw-Code/outline-ss-server/releases/download/v${OUTLINE_SS_VERSION}/outline-ss-server_${OUTLINE_SS_VERSION}_linux_arm64.tar.gz" &&\
		tar -xzv -C /tidalab -f outline-ss-server_${OUTLINE_SS_VERSION}_linux_arm64.tar.gz outline-ss-server \
        ;; \
    
esac

RUN wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-$TARGETARCH.tar.gz

RUN tar -zxf prometheus-${PROMETHEUS_VERSION}.linux-$TARGETARCH.tar.gz --strip-components 1 -C /tidalab

RUN chmod +x /tidalab/*

ENTRYPOINT /tidalab/tidalab-ss -api="$API" -token="$TOKEN" -node="$NODE" -license="$LICENSE" -syncInterval="$SYNCINTERVAL"
