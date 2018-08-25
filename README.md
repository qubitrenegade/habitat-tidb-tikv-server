# Habitat package: tikv

## Description

https://github.com/pingcap/tikv but in habitat

## Usage

Needs a `--topology leader` and a `--bind pd:pd.default` or similar.

# Start in container:

[Docker Hub](https://hub.docker.com/r/qbrd/tikv/)

Adjust peers as necessary.

The `--topology leader` appers to be optional?


```
docker run --rm --ulimit nofile=82920:82920 --memory-swappiness 0 \
  --sysctl ipv4.tcp_syncookies=0 --sysctl net.core.somaxconn=32768 \
  qbrd/tikv --peer 172.17.0.3 --peer 172.17.0.5 --bind pd:pd.default \
  --topology leader
```
