FROM ubuntu:18.04 as base
ENV DEBIAN_FRONTEND=noninteractive \
    TINI_VERSION=v0.19.0

ARG VERSION=7.6.9
ARG VERSION_MAJOR=7.6

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

FROM nvidia/opencl:runtime-ubuntu18.04

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="stefan.crain@gmail.com" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="docker gpu folding-at-home" \
      org.label-schema.description="Unofficial Image: Folding@home is a project focused on disease research." \
      org.label-schema.url="https://foldingathome.org/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/stefancrain/folding-at-home" \
      org.label-schema.vendor="stefancrain.foldingathome.gpu" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

#Add needed nvidia environment variables for https://github.com/NVIDIA/nvidia-docker
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,graphics,utility"
ENV NVIDIA_VISIBLE_DEVICES="all"

COPY --from=base /tini /bin/tini
COPY --from=base /usr/bin/FAH* /usr/bin/

WORKDIR /app

# hadolint ignore=DL3008
RUN mkdir -p /usr/share/doc/fahclient/ \
    && touch /usr/share/doc/fahclient/sample-config.xml \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
      ocl-icd-opencl-dev \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/ /var/lib/dpkg/ /var/lib/cache/ /var/lib/log/ \
    && groupadd -r fah \
    && useradd -r -g fah fah \
    && chown -R fah /app

EXPOSE 36330 7396
USER fah

ENTRYPOINT ["/bin/tini", "--", "/usr/bin/FAHClient", "--web-allow=0/0:7396", "--allow=0/0:7396", "--smp=true"]
CMD ["--user=Anonymous", "--team=229500", "--power=full", "--gpu-usage=100", "--cpu-usage=100"]
