FROM ubuntu:18.04 as base
ENV DEBIAN_FRONTEND=noninteractive \
    TINI_VERSION=v0.18.0

ARG VERSION=7.5.1
ARG VERSION_MAJOR=7.5

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      curl \
      gnupg \
      bzip2 \
      ca-certificates \
    && curl -o /tmp/fah.deb https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v${VERSION_MAJOR}/fahclient_${VERSION}_amd64.deb \
    && dpkg --force-depends --install /tmp/fah.deb \
    && gpg --keyserver hkp://ha.pool.sks-keyservers.net --recv-keys "595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7" || \
      gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7" || \
      gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7" || \
      gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7" ; \
      gpg --batch --verify /tini.asc /tini \
    && chmod +x /tini  

FROM ubuntu:18.04
LABEL maintainer="stefan.crain@gmail.com"

COPY --from=base /tini /bin/tini
COPY --from=base /usr/bin/FAH* /usr/bin/

WORKDIR /app
RUN mkdir -p /usr/share/doc/fahclient/ \
    && touch /usr/share/doc/fahclient/sample-config.xml \
    && groupadd -r fah \
    && useradd -r -g fah fah \
    && chown -R fah /app

EXPOSE 7396
USER fah

ENTRYPOINT ["/bin/tini", "--", "/usr/bin/FAHClient", "--web-allow=0/0:7396", "--allow=0/0:7396", "--smp=true"]
CMD ["--user=Anonymous", "--team=241985", "--power=full"]
