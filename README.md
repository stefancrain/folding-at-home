# Folding@home

![build](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg) ![auto-update](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg?event=schedule)

[![Docker Pulls](https://img.shields.io/docker/pulls/stefancrain/folding-at-home)](https://hub.docker.com/r/raspbernetes/gatekeeper)


```bash
docker run -d -p 7396:7396 --rm stefancrain/folding-at-home:7.5.1
```

GPU enabled with [NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

```bash
docker run -d -p 7396:7396 --rm --gpus all stefancrain/folding-at-home:7.5.1-cuda
```
