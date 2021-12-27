# Nexus Repository OSS

## Nexus Repository License

See https://github.com/sonatype/nexus-public

## Dockerfile License

It's just free. (Public Domain)

See https://github.com/yidigun/nexus3

## Use Image

Prepare data volume. (set uid:gid to 1000:1000)

```shell
mkdir -p /data/nexus/data
sudo chown -R 1000:1000 /data/nexus/data
```

Create container.

```shell
docker run -d \
  --name nexus3 \
  -p 8081:8081/tcp \
  -p 5000:5000/tcp \
  -v /data/nexus/data:/nexus-data \
  docker.io/yidigun/nexus3:latest
```

Check ```admin.password``` from /nexus-data (/data/nexus/data)
and proceed web configuration via http://localhost:8081


## Building

### 1. Download nexus unix tarball

Download from https://www.sonatype.com/products/repository-oss-download

### 2. Create docker builder.

```shell
docker buildx create --name multibuilder \
  --driver docker-container \
  --platform linux/amd64,linux/arm64
```

### 3. Build using created builder.

```shell
docker buildx build \
  --builder multibuilder \
  --platform linux/amd64,linux/arm64 \
  --push \
  -t yidigun/nexus3:3.37.1-01 \
  -t yidigun/nexus3:latest \
  .
```
