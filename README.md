# yubal

Self-hosted YouTube Music downloader. Paste a link, get a tagged, organized library.

Playlist sync. Artist/year sorting. Duplicate detection. Media server ready.

github.com/guillevc/yubal

<img src="https://github.com/guillevc/yubal/blob/master/web/public/favicon.svg?raw=true" width="30%" height="auto" alt="yubal logo">

## How to use this Makejail

### Standalone

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o container="args:--pull" \
    -o expose=8000 \
    -e PUID=1000 \
    -e PGID=1000 \
    ghcr.io/appjail-makejails/yubal yubal
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
    oci:
      environment:
        - YUBAL_PORT: 8000
        - YUBAL_TZ: America/Caracas
        - PUID: 1000
        - PGID: 1000
    options:
      - expose: '8000'
      - container: 'boot args:--pull'
    volumes:
      - data: /data
      - config: /config
default_volume_type: '<volumefs>'
volumes:
  data:
    device: /var/appjail-volumes/yubal/data
  config:
    device: /var/appjail-volumes/yubal/config
```

### Arguments (stage: build)

* `yubal_from` (default: `ghcr.io/appjail-makejails/yubal`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `yubal_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-263aca83a3-data | `${PUID}` | `${PGID}` | - | - | /data |
| appjail-3e723ade99-config | `${PUID}` | `${PGID}` | - | - | /config |

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
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
