# Running Folding@Home in docker with GPU support

![build](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg)
![auto-update](https://github.com/stefancrain/folding-at-home/workflows/folding-at-home/badge.svg?event=schedule)

![GitHub Tag](https://badgen.net/github/tag/stefancrain/folding-at-home?icon=github&label=version)
![GitHub commit activity](https://badgen.net/github/last-commit/stefancrain/folding-at-home?icon=github&label=updated)
![Docker Layers](https://badgen.net/docker/pulls/stefancrain/folding-at-home?icon=docker&label=pulls)
![Docker Size](https://badgen.net/docker/size/stefancrain/folding-at-home/latest/amd64?icon=docker&label=latest)
![Docker Stars](https://badgen.net/docker/stars/stefancrain/folding-at-home?icon=docker)

## Fighting COVID-19, and other diseases

TL;DR: **Folding at home** is simulating the dynamics of COVID-19 proteins to hunt for new therapeutic opportunities. This container distributes the binary in a hope to increase installs.

### FAH links

- [[FAQ] SARS-CoV-2 (COVID-19) projects and FAH](https://foldingforum.org/viewtopic.php?f=24&t=32463)
- [Coronavirus, what were doing and how you can help in simple terms](https://foldingathome.org/2020/03/15/coronavirus-what-were-doing-and-how-you-can-help-in-simple-terms/)
- [Live footage of our scientists working hard to make more work units available](https://twitter.com/foldingathome/status/1239992073664765953)

## Unofficial, Unsupported

I'm not a member of the F@H team. I actively work on issues here, and have set
this up to [automatically update](.github/workflows/schedule.yml) in my absence.
This image is published to [stefancrain/folding-at-home](https://hub.docker.com/repository/docker/stefancrain/folding-at-home)
and automatically updated as the folding-at-home team releases changes.

## Prerequisites

- CPU: amd64
- GPU: Nvidia and AMD
  - [A F@H supported GPU](https://apps.foldingathome.org/GPUs.txt)
  - [NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker) - A [gist](https://gist.github.com/stefancrain/0b4fe2ae29a15427a5d7040a9f7cdb5c) from my headless ubuntu 18.04 setup
  - TODO: add AMD gist

## Deployment

### CLI docker run

```bash
docker run \
  --name folding-at-home \
  --gpus all \
  -p 7396:7396 \
  stefancrain/folding-at-home:latest \
  --user=YOUR_NAME_HERE \
  --team=229500 \
  --power=full \
  --gpu-usage=100 \
  --cpu-usage=100
```

### Docker-compose

Docker-compose GPU access is currently blocked by upstream issue in compose
[#6691](https://github.com/docker/compose/issues/6691),
tracked in [#4](https://github.com/stefancrain/folding-at-home/issues/4).
**This will work for CPU folding only** :

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
    command: ["--user=YOUR_NAME_HERE","--team=229500","--power=full","--gpu=false","--cpu-usage=100"]
```

### K8s

I don't currently have a K8s cluster at home, so I'm including examples of users running this image in their config.

- [onedr0p/k3s-gitops](https://github.com/onedr0p/k3s-gitops/blob/fdc4be556833d3fcc4849b54cc248eb1a9c89dcc/deployments/default/folding-at-home/folding-at-home.yaml)
  works great but /u/onedrop has no approved GPUs to test
- [coreweave/fah-docker](https://github.com/coreweave/fah-docker/blob/master/kubernetes/folding-at-home-deployment.yaml)
  (a different container) but the config to support GPU enabled docker container, untested (by me)

TODO: create k8s cluster and test!

## Troubleshooting and FAQ

### nvidia-docker

> Is your `docker run` aborting with error `could not select device driver "" with capabilities: [[gpu]]`?

Please be sure you installed `nvidia-docker` as indicated in the 'Prerequisites' section above.

### Nvidia

> Does docker see all GPUs?

```bash
docker run \
 --rm \
 --gpus all \
 --entrypoint="nvidia-smi" \
 stefancrain/folding-at-home:latest
```

### FAHClient

> What are the FAHClient defaults set for this container?

- **User** : Anonymous
- **Team** : [Homelab - 229500](https://stats.foldingathome.org/team/229500) [_who?_](https://www.reddit.com/r/homelab/comments/fkyr1i/foldinghome_homelab_team_against_covid19/)
- **Power** : full (use full CPU)
- **gpu-usage** : 100%
- **cpu-usage** : 100%
- **web-allow/allow** : allow web traffic to port 7396
- **smp** : [support smp](https://foldingathome.org/2008/06/15/what-does-the-smp-core-do/)

> How do I review my FAHClient config?

```bash
docker run \
 --rm \
 --gpus all \
 --entrypoint="/usr/bin/FAHClient" \
 stefancrain/folding-at-home:latest \
 --info
```

> How can I see additional config options?

```bash
docker run \
 --rm \
 --entrypoint="/usr/bin/FAHClient" \
 stefancrain/folding-at-home:latest \
 --help
```

> How can I see my progress?

By default the container is open to local network traffic on [127.0.0.1:7396](http://127.0.0.1:7396/)
