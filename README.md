# Folding@home

![build](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg) ![auto-update](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg?event=schedule)

[![Docker Pulls](https://img.shields.io/docker/pulls/stefancrain/folding-at-home)](https://hub.docker.com/r/raspbernetes/gatekeeper)

GPU enabled with [NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

```bash
docker run -p 7396:7396 --gpus all stefancrain/folding-at-home:7.5.1-gpu --user=YOUR_NAME_HERE --team=241985 --power=full --gpu-usage=100
```

Also available as a minimal version

```bash
docker run -p 7396:7396 stefancrain/folding-at-home:7.5.1 --user=YOUR_NAME_HERE --team=241985 --power=full
```
