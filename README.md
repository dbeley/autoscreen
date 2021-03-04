# autoscreen

Automatically take screenshots with maim.

What you can change:
- frequency: `OnCalendar` value in `systemd-service/autoscreen.timer`
- directory from where autoscreen will be run: `WorkingDirectory` value in `systemd-service/autoscreen.service`
- directory where the screenshots will be stored: `DESTINATION_DIR` variable in `autoscreen.sh`

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
