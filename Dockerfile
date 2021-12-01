ARG ARCH
FROM --platform=linux/$ARCH alpine:latest
ARG ARCH
WORKDIR /tidalab

RUN cd /tidalab

RUN wget https://github.com/tokumeikoi/tidalab-ss/releases/download/1.1/tidalab-ss-$ARCH -O /tidalab/tidalab-ss

RUN if ["$ARCH" === "amd64"]; then wget "https://github.com/Jigsaw-Code/outline-ss-server/releases/download/v1.3.5/outline-ss-server_1.3.5_linux_x86_64.tar.gz"; \
	else wget "https://github.com/Jigsaw-Code/outline-ss-server/releases/download/v1.3.5/outline-ss-server_1.3.5_linux_arm64.tar.gz"; fi

RUN tar -xzv -C /tidalab -f outline-ss-server_*.tar.gz outline-ss-server

RUN wget https://github.com/prometheus/prometheus/releases/download/v2.31.1/prometheus-2.31.1.linux-$ARCH.tar.gz

RUN tar -zxf prometheus-2.31.1.linux-$ARCH.tar.gz --strip-components 1 -C /tidalab

RUN chmod +x /tidalab/*

ENTRYPOINT /tidalab/tidalab-ss -api="$API" -token="$TOKEN" -node="$NODE" -license="$LICENSE" -syncInterval="$SYNCINTERVAL"
