![PS4 Host Offline GoldHEN banner](docs/banner.png)

# Self-hosted PS4 Host Offline for GoldHEN (multiarch)

[![GHCR container images](https://img.shields.io/badge/GHCR-container%20images-2496ED?logo=docker&logoColor=white)](https://github.com/Chrisser73/ps4-host-offline-goldhen/pkgs/container/ps4-host-offline-goldhen)
[![License](https://img.shields.io/github/license/Chrisser73/ps4-host-offline-goldhen?label=license)](LICENSE)

Self-host the [PSPulse PS4 host by psx8](https://github.com/psx8/psx8.github.io) on your local network with a lightweight Nginx container. Run it on a Raspberry Pi or an amd64 machine using Docker Compose.

## At a glance

| Feature | Details |
| --- | --- |
| Platforms | `linux/arm64` (e.g. Raspberry Pi 4) and `linux/amd64` |
| Container image | `ghcr.io/chrisser73/ps4-host-offline-goldhen:latest` |
| Web access | Port **8135** on your Docker host |
| Offline cache support | AppCache `.manifest` files served as `text/cache-manifest` |
| Local builds | Fetch the latest upstream host with `start.bat` or `make start` |

## Quick start

### 1. Start the container

Install **Docker with the Compose plugin**, then run:

```sh
git clone https://github.com/Chrisser73/ps4-host-offline-goldhen.git
cd ps4-host-offline-goldhen
docker compose up -d
```

The web files are included in the image; no host directory mount is needed.

> If the GHCR package is private, authenticate Docker to GHCR before pulling, or make the package public.

### 2. Open the host on your PS4

Replace `<host-ip>` with the IP address of your Raspberry Pi or Docker host:

| Page | URL |
| --- | --- |
| Home | `http://<host-ip>:8135/` |
| Firmware 13.52 | `http://<host-ip>:8135/1352/index.html` |

**Choose the host page matching your PS4 firmware.**

> **Offline caching:** Test it on the PS4 itself. The correct manifest MIME type alone does not guarantee working offline caching. This setup does not redirect the PS4 User's Guide or change DNS settings.

To check the manifest response:

```sh
curl -I http://<host-ip>:8135/1352/cache.manifest
```

## Build locally

Use a local build to fetch the latest upstream version instead of the published image. Clone this repository as shown above, then choose your platform.

### Windows

Install **Git** and **Docker Desktop**, then run this from the repository directory (or double-click the file):

```bat
start.bat
```

### Linux / Raspberry Pi

Install **Git**, **Docker with Compose**, and **GNU Make**, then run:

```sh
make start
```

### Local build behavior

- Clones [psx8/psx8.github.io](https://github.com/psx8/psx8.github.io) into `www` on the first run.
- On later runs, fast-forwards a clean `www` checkout on `main` to the latest upstream version.
- Builds `ps4-host-local:latest` and starts it on port **8135**.
- Never overwrites existing files or local edits in `www`; the directory is ignored by this repository.
- Disables the Watchtower label through the local Compose override, preventing Watchtower from replacing the local build with the published image.

| Command | Action |
| --- | --- |
| `make setup` | Fetch or update upstream without building |
| `make build` | Fetch or update upstream and build without starting |
| `make start` | Fetch or update upstream, build, and start |

For the published image, use `docker compose up -d` instead of the local scripts.

## Updates

### Published image

Update the image and recreate the container:

```sh
docker compose pull
docker compose up -d
```

- Every push to `main` builds and publishes `latest` and a commit-SHA tag for both architectures.
- The workflow fetches the current upstream host during the build.
- Upstream changes are **not** published automatically; another push to `main` is required.
- Updating the image also updates the included web files.

Local builds with `make start` or `start.bat` fetch upstream on every run instead.

### Optional: Watchtower

The published-image service includes `com.centurylinklabs.watchtower.enable=true`.
For automatic image updates, run Watchtower separately with `--label-enable` and access to the Docker socket.
The label alone does **not** install or start Watchtower.

<details>
<summary>Maintainer notes: first publication</summary>

From the prepared Windows checkout:

1. Set your Git author identity.
2. Commit the project files (`www` and `.idea` are ignored).
3. Set the upstream tracking branch:

   ```sh
   git push -u origin main
   ```

The prepared checkout's `origin` points to `https://github.com/Chrisser73/ps4-host-offline-goldhen.git`.
GitHub then runs the image workflow. If Git asks for credentials, authenticate with your GitHub account; a password alone will not work over HTTPS.

</details>

## Credits and license

- **Upstream host, exploit code, and payloads:** [psx8/psx8.github.io](https://github.com/psx8/psx8.github.io).
- **This repository's Docker, Nginx, workflow, and documentation files:** [MIT License](LICENSE).
- **Upstream host and assets:** Not covered by this repository's MIT license. Check upstream redistribution rights before publishing an image containing those files.

> Exploit functionality and offline caching are not guaranteed. Use at your own risk.
