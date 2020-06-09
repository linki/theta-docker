FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl \
  dumb-init

RUN curl https://cacerts.digicert.com/DigiCertSHA2SecureServerCA.crt.pem \
  -o /usr/local/share/ca-certificates/DigiCertSHA2SecureServerCA.crt && \
  update-ca-certificates

RUN mkdir -p /etc/theta

RUN curl -o /bin/theta $(curl https://mainnet-data.thetatoken.org/binary?os=linux\&name=theta)
RUN curl -o /bin/thetacli $(curl https://mainnet-data.thetatoken.org/binary?os=linux\&name=thetacli)
RUN curl -o /etc/theta/config.yaml $(curl https://mainnet-data.thetatoken.org/config?is_guardian=true)
RUN curl -o /etc/theta/snapshot $(curl https://mainnet-data.thetatoken.org/snapshot)

RUN mkdir -p /etc/theta/key/encrypted
RUN chmod 0700 /etc/theta/key/encrypted

RUN chmod +x /bin/theta /bin/thetacli
RUN chown -R 65534 /etc/theta

USER 65534
ENTRYPOINT ["dumb-init", "--", "/bin/theta", "start", "--config", "/etc/theta"]
