# autoscreen

Automatically take screenshots with maim.

By default the timer will run the script every 15 minutes. You can change it in the systemd timer file.

You should also change the active directory (default: ~/Documents/autoscreen) in the systemd service file.

## Requirements

- maim

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
