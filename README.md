# Nexus Repository OSS

## Nexus Repository License

See https://github.com/sonatype/nexus-public and https://help.sonatype.com/repomanager3/product-information/release-notes

## Dockerfile License

It's just free. (Public Domain)

See https://github.com/yidigun/nexus3

## Supported tags

Base OS is changed to [Ubuntu](https://hub.docker.com/_/ubuntu) from ```3.39.0-01```.
And default locale and timezone also changed to ```en_US.UTF-8``` and ```Etc/UTC```.

* ```3.39.0-01```, ```latest```
* ```3.38.1-01``` (not supported)
* ```3.38.1-01``` (not supported)

## Use Image

Prepare data volume. (set uid:gid to 1000:1000)

```shell
mkdir -p /data/nexus/data
sudo chown -R 1000:1000 /data/nexus/data
```

Create container. To localize for your machine, set ```LANG``` and ```TZ``` environment variables.

```shell
docker run -d \
  --name nexus3 \
  -p 8081:8081/tcp \
  -p 5000:5000/tcp \
  -e LANG=ko_KR.UTF-8 \
  -e TZ=Asia/Seoul \
  -v /data/nexus/data:/nexus-data \
  docker.io/yidigun/nexus3:latest
```

Check ```admin.password``` from /nexus-data (/data/nexus/data)
and proceed web configuration via http://localhost:8081

## Building

### 1. Download nexus unix tarball

Download from https://www.sonatype.com/products/repository-oss-download

### 2. Build using created builder.

Check downloaded version and modify TAG macro.

```shell
make TAG=3.39.0-01
```

### 3. Test image

Local build and test image. Specify /nexus-data volume, web port and repository port using TEST_ARGS macro.

```shell
mkdir nexus-data
make test TAG=3.39.0-01 TEST_ARGS="-v `pwd`/nexus-data:/nexus-data -p 8081:8081/tcp -p 5001:5001"
```
