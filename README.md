# Habitat package: tikv

## Description

https://github.com/pingcap/tikv but in habitat

## Usage

Needs a `--topology leader` and a `--bind pd:pd.default` or similar.

# This seems to work to start a single server.  

docker run --ulimit nofile=82920:82920 --memory-swappiness 0 \
  --sysctl net.ipv4.tcp_syncookies=0 --sysctl net.core.somaxconn=32768 \
  qubitrenegade/tikv --peer 172.17.0.3 --peer 172.17.0.5 --bind pd:pd.default

