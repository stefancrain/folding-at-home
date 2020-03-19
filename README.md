# Running Folding@Home in docker with GPU support

![build](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg)
![auto-update](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg?event=schedule)

![GitHub Tag](https://badgen.net/github/tag/stefancrain/folding-at-home?icon=github&label=version)
![GitHub commit activity](https://badgen.net/github/last-commit/stefancrain/folding-at-home?icon=github&label=updated)
![Docker Layers](https://badgen.net/docker/pulls/stefancrain/folding-at-home?icon=docker&label=pulls)
![Docker Size](https://badgen.net/docker/size/stefancrain/folding-at-home/latest/amd64?icon=docker&label=latest)
![Docker Stars](https://badgen.net/docker/stars/stefancrain/folding-at-home?icon=docker)

## Unofficial, Unsupported

This image is published to Docker Hub at [stefancrain/folding-at-home](https://hub.docker.com/repository/docker/stefancrain/folding-at-home) and automatically updated as the folding-at-home team releases changes.

## Support

- amd64 CPU
- Nvidia and AMD GPU
  - [A supported GPU](https://apps.foldingathome.org/GPUs.txt)
  - [NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker) - A [gist](https://gist.github.com/stefancrain/0b4fe2ae29a15427a5d7040a9f7cdb5c) from my headless ubuntu 18.04 setup
  - TODO: add AMD gist

## Deployment

### CLI docker run

```bash
docker run \
  -p 7396:7396 \
  stefancrain/folding-at-home:latest \
  --user=YOUR_NAME_HERE \
  --team=229500 \
  --power=full \
  --gpu-usage=100
```

### Docker-compose

```bash
---
version: "3"
services:
  folding-at-home:
    image: stefancrain/folding-at-home:latest
    container_name: folding-at-home
    ports:
      - 7396:7396
    restart: unless-stopped
    command: ["--user=YOUR_NAME_HERE","--team=229500","--power=full","--gpu-usage=100"]
```

### K8s

I don't currently have a K8s cluster at home, so I'm including examples of users running this image in their config.

- [onedr0p/k3s-gitops](https://github.com/onedr0p/k3s-gitops/blob/master/deployments/default/folding-at-home/folding-at-home.yaml) works great but /u/onedrop has no approved GPUs to test
- [coreweave/fah-docker](https://github.com/coreweave/fah-docker/blob/master/kubernetes/folding-at-home-deployment.yaml) (a different container) but the config to support GPU enabled docker container, untested (by me)

TODO: create k8s cluster and test!

## Customizing the Folding@home cli defaults

- The web console is available on port 7396.
- Full access to CPU and GPU
- By default this container will contribute to [Homelab - 229500](https://stats.foldingathome.org/team/229500) - Feel free to change.
- To see additional config options run the help command:

```bin
docker run --rm --entrypoint="/usr/bin/FAHClient" stefancrain/folding-at-home:latest --help
```
