# Docker Images

## Tensorflow GPU

Launch a JupyterLab with GPU support for TF.
Uses CUDA 10.0 and CUDNN7 on Ubuntu 18.04.

### Run

```bash
docker run --runtime=nvidia --rm -p 8888:8888 -v $(pwd):/docs tudders/practical:tf_gpu
```
