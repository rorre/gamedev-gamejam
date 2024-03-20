# unnamed VSRG

A game for Individual Game Jam CSUI 2024.

## Requirements

- Godot 4

## Building

1. Clone the project
2. You will need the latest `songs` folder. This is pushed to the repository, but if it were to crash, download [this songs.zip folder](https://d.rorre.me/7upnVPyF/songs.zip).
3. Export as usual :)

## Charting

Charting is done using osu!mania editor.

1. Set editor to 4K
2. Open your .osu file, copy anything after `[HitObjects]` to `objects.txt`
3. Run `python conv.py difficulty.json`
4. Copy `.json` file to the songs directory
5. Edit `scenes/screen/song_select.gd` to have the song/difficulty you just created
