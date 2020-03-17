# Folding@home

```bash
docker run -d -p 7396:7396 --rm stefancrain/folding-at-home:7.5.1
```

GPU enabled with [NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

```bash
docker run -d -p 7396:7396 --rm --gpus all stefancrain/folding-at-home:7.5.1-cuda
```
