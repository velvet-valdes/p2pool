FROM ubuntu:20.04 AS build

ENV P2POOL_VERSION=1.5 P2POOL_SHA256=9b5ff8511e495d5b5118058eb9c97f2560b6dd51b815d2ae7feb635fe11233e1

RUN apt-get update && apt-get install -y wget gzip

WORKDIR /root

RUN wget https://github.com/SChernykh/p2pool/releases/download/v$P2POOL_VERSION/p2pool-v$P2POOL_VERSION-linux-x64.tar.gz && \
  echo "$P2POOL_SHA256 p2pool-v$P2POOL_VERSION-linux-x64.tar.gz" | sha256sum -c - && \
  tar -zxvf p2pool-v$P2POOL_VERSION-linux-x64.tar.gz && \
  cp ./p2pool-v$P2POOL_VERSION-linux-x64/p2pool . &&\
  rm -r p2pool-*

FROM ubuntu:20.04

RUN useradd -ms /bin/bash p2pool && mkdir -p /home/p2pool && chown -R p2pool:p2pool /home/p2pool
USER p2pool
WORKDIR /home/p2pool

COPY mini_config.json /home/p2pool/mini_config.json

COPY --chown=p2pool:p2pool --from=build /root/p2pool /home/p2pool/p2pool

EXPOSE 37888

ENTRYPOINT ["./p2pool"]
CMD ["--non-interactive", "--config", "mini_config.json", "--p2p", "0.0.0.0:37888", "--host", "10.12.35.28", "--wallet", "46pBm7UZrLYeiUbNrqRuqJhXpDPhJEoyFRu3gmcGeMS4KnTt93RSJBv3mLh8vfMESJ999fDqTxytJUxK13ztJ3FyBGZFmhr"]