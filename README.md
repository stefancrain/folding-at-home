# Running Folding@Home in docker with GPU support

![build](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg) ![auto-update](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg?event=schedule)

![GitHub Tag](https://img.shields.io/github/tag/stefancrain/folding-at-home)
![GitHub commit activity](https://img.shields.io/github/last-commit/stefancrain/folding-at-home)
![GitHub license](https://img.shields.io/github/license/stefancrain/folding-at-home)


![MicroBadger Layers](https://img.shields.io/microbadger/layers/stefancrain/folding-at-home)
![MicroBadger Size](https://img.shields.io/microbadger/image-size/stefancrain/folding-at-home)
![Docker Pulls](https://img.shields.io/docker/pulls/stefancrain/folding-at-home)
![Docker Stars](https://img.shields.io/docker/stars/stefancrain/folding-at-home)

## Unofficial, Unsupported

This image is published to Docker Hub as [stefancrain/folding-at-home](https://hub.docker.com/repository/docker/stefancrain/folding-at-home).


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

- [A supported GPU](https://apps.foldingathome.org/GPUs.txt)
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
