# Running Folding@Home in docker with GPU support

![build](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg) ![auto-update](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg?event=schedule)

![GitHub Tag](https://badgen.net/github/tag/stefancrain/folding-at-home)
![GitHub commit activity](https://badgen.net/github/last-commit/stefancrain/folding-at-home)
![GitHub license](https://badgen.net/github/license/stefancrain/folding-at-home)

![Docker Layers](https://badgen.net/docker/pulls/stefancrain/folding-at-home)
![Docker Size](https://badgen.net/docker/size/stefancrain/folding-at-home/latest/amd64?icon=docker&label=latest )
![Docker Size](https://badgen.net/docker/size/stefancrain/folding-at-home/latest-gpu/amd64?icon=docker&label=latest-gpu)
![Docker Stars](https://badgen.net/docker/stars/stefancrain/folding-at-home?icon=docker&label=stars )

## Unofficial, Unsupported

This image is published to Docker Hub [stefancrain/folding-at-home](https://hub.docker.com/repository/docker/stefancrain/folding-at-home) and automatically updated as folding-at-home releases changes.

## Deployment

### CPU only

```bash
docker run \
 -p 7396:7396 \
 stefancrain/folding-at-home:latest \
 --user=YOUR_NAME_HERE \
 --team=241985 \
 --power=full
```

### CPU + GPU

#### Requirements

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

### Defaults

- The web console is available on port 7396.
- By default this container will contribute to team 241985, team name: SaveTheBoomers
