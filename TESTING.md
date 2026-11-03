# Testing

The configurations in this repository are tested by compiling them with ESPHome in Docker. The files under test are the top-level `multi-sensor-*.yaml` files, including the `*.factory.yaml` variants. Nothing in `common/` is compiled on its own; it is built through the top-level files.

## Requirements

- Windows with PowerShell 7 (`pwsh`)
- Docker Desktop, installed and running
- Internet access (ESPHome images, external components and sound files are downloaded)

## Run from VS Code

1. Open **Terminal > Run Build Task...** (`Ctrl+Shift+B`).
2. Select **ML ESPHome: Build ESPHome test configs** (the default build task).

Other tasks (**Terminal > Run Task...**):

| Task | Purpose |
| --- | --- |
| ML ESPHome: Build ESPHome test configs | Lint/auto-fix the repository (yamllint, Ruff, file hygiene), then compile all top-level configs with ESPHome `stable`, `beta` and `dev` |
| ML ESPHome: Clear cached downloads | Remove cached ESPHome/PlatformIO data and downloaded images; use this when builds behave oddly |

## Run from a terminal

Run from the repository root:

```powershell
.\.devcontainer\build.ps1                                        # all configs, stable + beta + dev
.\.devcontainer\build.ps1 -Versions @("dev")                     # one ESPHome tag
.\.devcontainer\build.ps1 -Image ghcr.io/esphome/esphome:2026.10.1
.\.devcontainer\build.ps1 -Include "multi-sensor-pkga-ld2450*"   # only matching configs
```

`-Include` takes wildcard patterns that match the file name with or without the extension. Beta is skipped automatically when it is the same image as stable.

## How it works

- Each top-level config is copied to `.esphome/config/` for every ESPHome image. The original files are never changed.
- In the copy, the `packages: remote:` block (which normally downloads `common/*.yaml` from GitHub) is replaced by local `!include` lines, and the relative `!include` paths in the factory files are re-pointed at the repository. This means the build always tests your working tree, not what is on GitHub.
- External components referenced by `common/` (for example `sen6x` and `ld2410s`) are still fetched from GitHub at their pinned tags.
- Each ESPHome version builds in parallel in its own container, with its own cache volume. The first run downloads the toolchains and is slow; later runs are much faster.
- A status table shows progress, warnings, errors and time per version. The build fails if any config fails to compile.

## Output

Logs for the latest run are written to `.esphome/build-<version>-<date>.log`. The `.esphome/` folder is git-ignored. Staged copies are removed when the build ends.

## Troubleshooting

- `error during connect ... dockerDesktopLinuxEngine`: Docker Desktop is not running.
- A build that sits at `Fetching <commit>` or is killed with exit code 137: run **ML ESPHome: Clear cached downloads** and retry.
- Do not add new secrets to the top-level files; commented-out `!secret` lines are fine, but an active `!secret` needs a `secrets.yaml` that the build does not provide.
