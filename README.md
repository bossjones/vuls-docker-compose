**Inspired by https://github.com/FuCrowRabbit/VulsInDockerCompose**

# Vuls in Docker-Compose

See main docs: https://vuls.io/docs/en/tutorial-docker.html

## Step1. Fetch NVD

[go-cve-dictionary](https://github.com/kotakanbe/go-cve-dictionary)

```
for i in `seq 2002 $(date +"%Y")`; do \
docker-compose run --rm go-cve-dictionary fetchnvd -years $i; \
done
```

To fetch JVN(Japanese), See [README](https://github.com/kotakanbe/go-cve-dictionary#usage-fetch-jvn-data)

## Step2. Fetch OVAL (e.g. Ubuntu 20)

[goval-dictionary](https://github.com/kotakanbe/goval-dictionary)

```
docker-compose run --rm goval-dictionary fetch ubuntu 20
```

To fetch other OVAL, See [README](https://github.com/kotakanbe/goval-dictionary#usage-fetch-oval-data-from-redhat)

## Step3. Fetch gost (e.g. Ubuntu)

[gost](https://github.com/knqyf263/gost)

```
docker-compose run --rm gost fetch ubuntu
```

To fetch Debian security tracker, See [Gost README](https://github.com/knqyf263/gost#fetch-debian)

## Step3.5. Fetch go-exploitdb

[go-exploitdb](https://github.com/vulsio/go-exploitdb)

```
docker-compose run go-exploitdb fetch exploitdb
```

To fetch deep go-exploitdb, See [this](https://github.com/vulsio/go-exploitdb#deep-fetch-and-insert-exploit)

## Step3.6. Fetch go-msfdb

[go-msfdb](https://github.com/takuzoo3868/go-msfdb)

```
docker-compose run --rm go-msfdb fetch msfdb
```

## Step4. Write Configuration

Create config.toml referring to [this](https://vuls.io/docs/en/config.toml).

```toml
[cveDict]
type = "sqlite3"
SQLite3Path = "/vuls/cve.sqlite3"

[ovalDict]
type = "sqlite3"
SQLite3Path = "/vuls/oval.sqlite3"

[gost]
type = "sqlite3"
SQLite3Path = "/vuls/gost.sqlite3"

[exploit]
type = "sqlite3"
SQLite3Path = "/vuls/go-exploitdb.sqlite3"

[metasploit]
type = "sqlite3"
SQLite3Path = "/vuls/go-msfdb.sqlite3"

[servers]

[servers.example]
host            = "example_host"
user            = "example_user"
# if ssh config file exists in .ssh, path to ssh config file in docker
sshConfigPath   = "/root/.ssh/config"
# path to ssh private key in docker
keyPath         = "/root/.ssh/id_rsa.key"
```

## Configtest

```
docker-compose run --rm vuls configtest -config=./config.toml
```

[Usage: configtest](https://vuls.io/docs/en/usage-configtest.html)

## Scan

```
docker-compose run --rm -e "TZ=Asia/Tokyo" vuls scan -config=./config.toml
```

[Usage: Scan](https://vuls.io/docs/en/usage-scan.html)

## Report

```
docker-compose run --rm vuls report -config=./config.toml -format-list
```

[Usage: Report](https://vuls.io/docs/en/usage-report.html)