# yubal

Self-hosted YouTube Music downloader. Paste a link, get a tagged, organized library.

Playlist sync. Artist/year sorting. Duplicate detection. Media server ready.

github.com/guillevc/yubal

<img src="https://github.com/guillevc/yubal/blob/master/web/public/favicon.svg?raw=true" width="80%" height="auto" alt="yubal">

## How to use this Makejail

### Standalone

```console
appjail makejail \
    -j yubal \
    -f gh+AppJail-makejails/yubal \
    -o virtualnet=":<random> default" \
    -o nat
appjail start yubal
```

### Deploy using appjail-director

**.env**:

```
DIRECTOR_PROJECT=yubal
```

**appjail-director.yml**:

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:
services:
  yubal:
    name: yubal
    makejail: gh+AppJail-makejails/yubal
    arguments:
      - puid: 1000
      - guid: 1000
    oci:
      environment:
        - YUBAL_PORT: 8000
        - YUBAL_TZ: America/Caracas
    options:
      - expose: '8000:8000'
    volumes:
      - data: /app/data
      - config: /app/config
volumes:
  data:
    device: /var/appjail-volumes/yubal/data
    owner: 1000
    group: 1000
  config:
    device: /var/appjail-volumes/yubal/config
    owner: 1000
    group: 1000
```

### Arguments

* `yubal_from` (default: `ghcr.io/appjail-makejails/yubal`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `yubal_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.0
      containerfile: Containerfile.pkg
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.0"
        PYTHON_VERSION: "312"
        YUBAL_VERSION: "0.7.1"
```

## Notes

1. This Makejail includes [gh+AppJail-makejails/user-mapping](https://github.com/AppJail-makejails/user-mapping). 
