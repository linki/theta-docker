FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
  ca-certificates \
  dumb-init

ADD https://drzm1v2r1c2e3.cloudfront.net/snapshot/theta_snapshot-5999358-0xdd0f36dc67a7f15a9abf621e444245b669f15dec3da2fc2f19e2c43225b1efdb-2020-06-06 /etc/theta/snapshot
ADD https://theta-downloader.s3.amazonaws.com/config/guardian/config.yaml /etc/theta/config.yaml
ADD https://theta-downloader.s3.amazonaws.com/binary/linux/theta /bin/theta
ADD https://theta-downloader.s3.amazonaws.com/binary/linux/thetacli /bin/thetacli

RUN chmod +x /bin/theta /bin/thetacli
RUN chown 65534 /etc/theta

USER 65534
ENTRYPOINT ["dumb-init", "--", "/bin/theta", "start", "--config", "/etc/theta"]
