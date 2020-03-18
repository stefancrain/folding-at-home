# Running Folding@Home in docker with GPU support

![build](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg) ![auto-update](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg?event=schedule)[![Docker Pulls](https://img.shields.io/docker/pulls/stefancrain/folding-at-home)](https://hub.docker.com/r/raspbernetes/gatekeeper)

This image is published to Docker Hub as [stefancrain/folding-at-home](https://hub.docker.com/repository/docker/stefancrain/folding-at-home).

Unofficial

## CPU only

```bash
docker run \
 -p 7396:7396 \
 stefancrain/folding-at-home:latest \
 --user=YOUR_NAME_HERE \
 --team=241985 \
 --power=full
```

## CPU + GPU

### Requirements

- [NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

```bash
docker run \
  -p 7396:7396 \
  --gpus all \
  stefancrain/folding-at-home:latest-gpu \
  --user=YOUR_NAME_HERE \
  --team=241985 \
  --power=full \
  --gpu-usage=100
```

The web console is available on port 7396.

By default this container will contribute to 241985, team name: SaveTheBoomers
