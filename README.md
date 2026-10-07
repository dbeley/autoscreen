# autoscreen

Automatically take screenshots at a random time every hour. **Wayland only**,
using [`grim`](https://git.sr.ht/~emersion/grim).

What you can change:
- frequency: `OnCalendar` value in `systemd-service/autoscreen.timer`
- directory from where autoscreen will be run: `WorkingDirectory` value in `systemd-service/autoscreen.service`
- directory where the screenshots will be stored: `DESTINATION_DIR` variable in `autoscreen.sh`
  (overridable at runtime with the `AUTOSCREEN_DESTINATION_DIR` environment variable)
- file name suffix: `AUTOSCREEN_FILENAME_SUFFIX` environment variable, inserted
  just before `autoscreen.png` (useful to tell machines/installations apart)
- output format: `AUTOSCREEN_FORMAT` environment variable — `png` (default),
  `jpeg`, `ppm`, `webp`, `avif` or `jxl`
- encoder quality: `AUTOSCREEN_QUALITY` environment variable, `0`-`100`
  (default `90`, higher is better; ignored for `png`/`ppm`)

## Requirements

- `grim`
- for `webp` / `avif` / `jxl` output: `cwebp` (libwebp), `avifenc` (libavif),
  `cjxl` (libjxl) respectively

## Installation

```
git clone https://github.com/dbeley/autoscreen
cd autoscreen
chmod +x autoscreen.sh
cp systemd-service/* ~/.config/systemd/user
systemctl --user daemon-reload
systemctl --user enable --now autoscreen.timer
systemctl --user status autoscreen
```

## Nix / NixOS

A flake is provided, exposing the package, an overlay and a Home Manager module.

Try it without installing:

```
nix run github:dbeley/autoscreen
```

### Home Manager

Add the flake as an input:

```nix
# flake.nix
inputs.autoscreen.url = "github:dbeley/autoscreen";
```

Then import the module and enable the service:

```nix
{
  imports = [ inputs.autoscreen.homeModules.default ];

  services.autoscreen = {
    enable = true;
    # destinationDir = "%h/Nextcloud/07_Images/01_autoscreen";
    # filenameSuffix = "nixos_";
    # format = "png";    # png | jpeg | ppm | webp | avif | jxl
    # quality = 90;      # 0-100, higher is better (ignored for png/ppm)
    # onCalendar = "hourly";
    # randomizedDelaySec = 3600;
  };
}
```

Note: `destinationDir` uses the systemd `%h` specifier for the user's home
directory instead of `$HOME` (systemd expands `%h` in `Environment=`, not `$HOME`).

### Formats

A PNG of a 4K screenshot is large (several MB, more on detailed content such as
games). The lossy formats are roughly an order of magnitude smaller:

| format | relative size (4K content) | notes |
|---|---|---|
| `png` | 100 % (baseline) | lossless, grim-native |
| `jxl` | ~8–10 % | best perceived quality, grim cannot emit it |
| `avif` | ~5–10 % | smallest, but visible artifacts on fine texture |
| `webp` | ~10–40 % | broadest viewer support |
| `jpeg` | ~9 % on photos, **>100 % on flat UI** | grim-native, but poor for screenshots |

`quality` is passed straight to the encoder (grim `-q`, cwebp `-q`, avifenc
`-q`, cjxl `-q`), so it means the same thing everywhere: higher is better,
`100` is lossless for `avif` and `jxl`.

### Package / overlay

```nix
# packages
nix build github:dbeley/autoscreen

# overlay
{
  inputs.autoscreen.url = "github:dbeley/autoscreen";
  nixpkgs.overlays = [ inputs.autoscreen.overlays.default ];
  # pkgs.autoscreen is then available
}
```
