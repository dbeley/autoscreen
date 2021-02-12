# autoscreen

Automatically take screenshot with maim.

## Requirements

- maim

## Installation

```
git clone https://github.com/dbeley/autoscreen
cd autoscreen
chmod +x autoscreen.sh
cp systemd-service/* ~/.config/systemd/user
systemctl --user daemon-reload
systemctl --user enable --now autoscreen
systemctl --user status autoscreen
```

By default the script will run every 30 minutes. You can change it in the systemd timer file.

You can also change the active directory (default: ~/Documents/autoscreen) in the systemd service file.
