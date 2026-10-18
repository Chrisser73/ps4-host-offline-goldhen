# PS4 Host Offline GoldHEN

A small Nginx image for serving the static [PSPulse PS4 host by psx8](https://github.com/psx8/psx8.github.io) on your own network. The image includes the upstream site and serves AppCache `.manifest` files as `text/cache-manifest`. Use the host page matching your PS4 firmware; for 13.52, the entry point is `/1352/index.html`.

## Run the published image on a Raspberry Pi 4 (or an amd64 machine)

Install Docker with the Compose plugin, then clone this repository:

```sh
git clone https://github.com/Chrisser73/ps4-host-offline-goldhen.git
cd ps4-host-offline-goldhen
docker compose up -d
```

Open `http://<your-pi-ip>:8135/1352/index.html` in the PS4 browser (for example, `http://192.168.178.166:8135/1352/index.html`). The home page is at `http://<your-pi-ip>:8135/`. You can check the manifest response with `curl -I http://<your-pi-ip>:8135/1352/cache.manifest`. Test offline caching on the PS4 itself; serving the correct MIME type alone does not guarantee that it will work. This setup does not redirect the PS4 User's Guide or change DNS settings.

The Compose service pulls `ghcr.io/chrisser73/ps4-host-offline-goldhen:latest` for either `linux/arm64` or `linux/amd64`. The web files are baked into the image, not mounted from the host, so image updates also update the served site. Make the GHCR package public (or authenticate Docker to GHCR) before pulling if the package is private.

## Build locally from the latest upstream version

On **Windows**, install Git and Docker Desktop, clone this repository as above, and run `start.bat` from its directory (or double-click it). On **Linux / Raspberry Pi**, install Git, Docker Compose and GNU Make, then run `make start` in the cloned repository. Either command clones [psx8/psx8.github.io](https://github.com/psx8/psx8.github.io) into `www` on first run; on later runs it fast-forwards a clean `www` checkout on `main`, builds `ps4-host-local:latest` and starts it on port 8135. Existing files or local edits in `www` are never overwritten. The local Compose override disables the Watchtower label so Watchtower cannot replace this locally built image with the published one. `www` is ignored by this repository.

Run `make setup` to fetch/update upstream without building, or `make build` to fetch/update and build without starting. For a plain published-image installation, use `docker compose up -d` instead of the local scripts.

## Build and updates

Every push to `main` builds and publishes `latest` and a commit-SHA tag for both architectures. The workflow clones the current [psx8 upstream host](https://github.com/psx8/psx8.github.io) into `www` during the build; upstream changes are **not** published automatically until another push to `main`. Local `make start` / `start.bat` fetches upstream on every run instead.

To publish this project for the first time from the prepared Windows checkout, set your Git author identity, commit the project files, and set the upstream tracking branch with `git push -u origin main`. The `origin` remote already points to `https://github.com/Chrisser73/ps4-host-offline-goldhen.git`; `www` and `.idea` are ignored. GitHub will then run the image workflow. If Git asks for credentials, authenticate with your GitHub account; a password alone will not work over HTTPS.

The Compose service carries `com.centurylinklabs.watchtower.enable=true` for Watchtower. Run Watchtower separately with `--label-enable` and access to the Docker socket if you want automatic image updates; the label alone does not install or start Watchtower. Without Watchtower, update manually with `docker compose pull && docker compose up -d`.

## Credits and license

The PS4 host, exploit code, and payloads come from [psx8/psx8.github.io](https://github.com/psx8/psx8.github.io), not this project. This repository's Docker, Nginx, workflow, and documentation files are MIT-licensed (see [LICENSE](LICENSE)); that license does **not** cover the upstream host or its assets. Check upstream redistribution rights before publishing an image containing those files. Exploit functionality and offline caching are not guaranteed; use at your own risk.
