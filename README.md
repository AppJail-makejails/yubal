# yubal

Self-hosted YouTube Music downloader. Paste a link, get a tagged, organized library.

Playlist sync. Artist/year sorting. Duplicate detection. Media server ready.

github.com/guillevc/yubal

<img src="https://github.com/guillevc/yubal/blob/master/web/public/favicon.svg?raw=true" width="30%" height="auto" alt="yubal logo">

## How to use this Makejail

### Standalone

```console
appjail makejail \
    -j yubal \
    -f gh+AppJail-makejails/yubal \
    -o virtualnet=":<random> default" \
    -o nat \
    -o container="args:--pull"
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
      - pgid: 1000
    oci:
      environment:
        - YUBAL_PORT: 8000
        - YUBAL_TZ: America/Caracas
    options:
      - expose: '8000:8000'
      - container: 'args:--pull'
    volumes:
      - data: yubal-data
      - config: yubal-config
default_volume_type: '<volumefs>'
volumes:
  data:
    device: /var/appjail-volumes/yubal/data
  config:
    device: /var/appjail-volumes/yubal/config
```

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| yubal-config | `${puid}` | `${pgid}` | - | - | /var/db/yubal/config |
| yubal-data | `${puid}` | `${pgid}` | - | - | /var/db/yubal/data |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        PYVER: "312"
```

## Notes

1. This Makejail includes [gh+AppJail-makejails/user-mapping](https://github.com/AppJail-makejails/user-mapping).
