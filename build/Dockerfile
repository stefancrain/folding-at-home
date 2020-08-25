FROM ubuntu:bionic-20200807 as fast-builder

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      curl \
      gnupg \
      bzip2 \
      ca-certificates

ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /tini
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini.asc /tini.asc
RUN  gpg --keyserver hkp://ha.pool.sks-keyservers.net --recv-keys "595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7" || \
      gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7" || \
      gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7" || \
      gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7" ; \
      gpg --batch --verify /tini.asc /tini \
    && chmod +x /tini  

ARG VERSION=7.6.17
ARG TARGETPLATFORM
RUN ARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2) \
    && FIRST=$(echo $ARCH | sed "s#amd64#64bit#g") \
    && MVERSION=$(echo "${VERSION}" | sed -E 's/\.([^.]*)$//') \
    && FAHURL="https://download.foldingathome.org/releases/beta/release/fahclient/debian-stable-${FIRST}/v${MVERSION}/fahclient_${VERSION}_${ARCH}.deb" \
    && echo "${FAHURL}" > /fah.url \
    && cat /fah.url  \
    && mkdir -p /etc/fahclient && touch /etc/fahclient/config.xml \
    && curl -o /fah.deb "${FAHURL}" \
    && DEBIAN_FRONTEND=noninteractive dpkg --force-depends --install /fah.deb

FROM ubuntu:bionic-20200807 as mini 

ARG VERSION=7.6.17
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="stefan.crain@gmail.com" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Docker folding-at-home" \
      org.label-schema.description="Unofficial Image: Folding@home is a project focused on disease research." \
      org.label-schema.url="https://foldingathome.org/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/stefancrain/folding-at-home" \
      org.label-schema.vendor="stefancrain.foldingathome.mini" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

COPY --from=fast-builder /tini /bin/tini
COPY --from=fast-builder /usr/bin/FAH* /bin/
COPY --from=fast-builder /etc/fahclient/config.xml /etc/fahclient/config.xml

WORKDIR /app

RUN mkdir -p /usr/share/doc/fahclient/ \
    && touch /usr/share/doc/fahclient/sample-config.xml \
    && groupadd -r fah \
    && useradd -r -g fah fah \
    && chown -R fah /app

EXPOSE 36330 7396
USER fah

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -f http://localhost:7396 || exit 1

ENTRYPOINT ["/bin/tini", "--", "/bin/FAHClient", "--web-allow=0/0:7396", "--allow=0/0:7396", "--smp=true"]
CMD ["--user=Anonymous", "--team=229500", "--power=full", "--cpu-usage=100"]

FROM ubuntu:bionic-20200807
COPY --from=mini / /

ARG VERSION=7.6.17
ARG TARGETPLATFORM
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="stefan.crain@gmail.com" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Docker CPU/GPU folding-at-home" \
      org.label-schema.description="Unofficial Image: Folding@home is a project focused on disease research." \
      org.label-schema.url="https://foldingathome.org/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/stefancrain/folding-at-home" \
      org.label-schema.vendor="stefancrain.foldingathome.combo" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

RUN ARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2) \
    && ARCH_URL=$(echo $ARCH | sed "s#arm64#sbsa#g" | sed "s#amd64#x86_64#g") \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
      gnupg2 \
      curl \
      ca-certificates \
    && curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/${ARCH_URL}/7fa2af80.pub | apt-key add - \
    && echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/${ARCH_URL} /" > /etc/apt/sources.list.d/cuda.list \
    && echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/${ARCH_URL} /" > /etc/apt/sources.list.d/nvidia-ml.list \
    && apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

# nvidia-container-runtime
# Add needed nvidia environment variables for https://github.com/NVIDIA/nvidia-docker
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,graphics,utility" \
    NVIDIA_VISIBLE_DEVICES="all" \
    NVIDIA_REQUIRE_CUDA="cuda>=11.0" \
    NCCL_VERSION=2.7.8

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      cuda-cudart-11-0=11.0.221-1 \
      ocl-icd-opencl-dev \
      libnccl2=$NCCL_VERSION-1+cuda11.0 \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/ /var/lib/dpkg/ /var/lib/cache/ /var/lib/log/ \
    && ln -s cuda-11.0 /usr/local/cuda \
    && rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1 
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64

EXPOSE 36330 7396
USER fah

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -f http://localhost:7396 || exit 1

ENTRYPOINT ["/bin/tini", "--", "/bin/FAHClient", "--web-allow=0/0:7396", "--allow=0/0:7396", "--smp=true"]
CMD ["--user=Anonymous", "--team=229500", "--power=full", "--gpu-usage=100", "--cpu-usage=100"]
