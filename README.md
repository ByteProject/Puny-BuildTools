# The Puny BuildTools

Welcome brave adventurer! If you're still into classic 8-bit / 16-bit home computers and Infocom style adventure games you may want to rest here for a while. The Puny BuildTools provide a command-line interface to [PunyInform](https://github.com/johanberntsson/PunyInform), a lightweight but powerful [Inform 6](https://github.com/DavidKinder/Inform6) library, optimized to perform well on old hardware. The Puny BuildTools assist interactive fiction authors as a project management solution for Infocom Z-machine games. They make the whole process of development fast, streamlined and accessible, from structuring your project to compilation, testing, building disk images for retro systems, converting images to pixel art compatible with classic targets and bundling your releases for distribution.

## Current version

`2.0` Helix Nebula

## Build Targets

The following targets support Z-machine version 5 (XZIP) and Z-machine version 3 (ZIP) story files:

**C64, Amiga, ZX Spectrum, Amstrad CPC/PCW, Atari ST, Atari 8-bit, MS-DOS, MSX, BBC Micro/Acorn Electron, C128, Plus/4, Apple II, SAM Coupe, TRS80 Model 3, TRS 80 Model 4, Mega65, classic Macintosh, modern PC.**

There are also a few deprecated targets available, only supporting Z-machine version 3:

**VIC20/PET, DEC Rainbow, TRS CoCo/Dragon64, Osborne1, Ti99/4a, Oric, Kaypro.**

Note that Puny BuildTools projects by default are configured to target Z-machine v5 and it's strongly recommended to keep it that way. The format is less restrictive and offers more options.

You can use the built-in feature to compile your story from source but the project workflow allows to skip this step and use any given story file.

## Host

The Puny BuildTools are designed for `Linux (64-bit)` systems. They've been developed and extensively tested on `Ubuntu` and `Debian` but any derivate of the latter should be fine. 

If you're on `Windows 10` (or later) you can run the Puny BuildTools via [WSL2](https://learn.microsoft.com/en-us/windows/wsl/about).

If you work on `MacOS`, I can't recommend [OrbStack](https://orbstack.dev/) enough. Make sure you set up an Ubuntu machine with Intel architecture.

## Installation

Below instructions are intended for `Debian` based systems like `Ubuntu` and may vary if you are using a different distro.

Open a Bash terminal. In your home directory, create a folder named `FictionTools` with `mkdir ~/FictionTools`

The Puny BuildTools require some dependencies. Install these via a single command: 

```
sudo apt update && sudo apt install frotz cpmtools dosfstools mtools git ruby imagemagick zip pipx
```
When prompted to install additional dependencies, type `Y` to confirm. Switch to the folder you created and use Git to load the newest version from GitHub:

```
cd ~/FictionTools && git clone https://github.com/ByteProject/Puny-BuildTools.git .
```

Let's use `Puny-Wan Kenobi` to make sure the Puny BuildTools have sufficient permissions to run on your system by typing:
```
cd ~/FictionTools && chmod 755 kenobi && kenobi -p
```
This may take some time. Should you ever need to fix permissions, simply run `kenobi -p` again.

Next, you need to make sure all environment variables and paths are properly set on your system. Launch `nano` to edit your Bash resource file via `nano ~/.bashrc` and add this entry:

```
source ~/FictionTools/.punyrc
```
In case you're on `Windows / WSL2`, the code needs to look like this instead:

```
source ~/FictionTools/.punyrc
source ~/FictionTools/.punywsl
```
After you've made your changes, hit `CTRL X` to exit Nano. Make sure you select `Y` when you're asked to save the modified buffer.

Another dependency is Wine, a compatibility layer that allows running Windows applications on Linux. To install Wine, type:

```
sudo apt update && sudo apt install wine
sudo dpkg --add-architecture i386
sudo apt update && sudo apt install wine32
```
It's recommended to close all Terminal windows now and then open a new Bash instance. The changes you've made to `.bashrc` have now been applied.

Next, teach `cpmtools` to handle disk images for SAM Coupe and DEC Rainbow. In your Bash prompt, type `nano ~/etc/cpmtools/diskdefs` and add the following code:

```
diskdef prodos
  seclen 512
  tracks 160
  sectrk 9
  maxdir 256
  blocksize 2048
  boottrk 1
  skew 0
  os 2.2
end

# DEC2 DEC Rainbow - SSDD 96 tpi 5.25" - 512 x 10
  diskdef dec2
  seclen 512
  tracks 80
  sectrk 10
  blocksize 2048
  maxdir 128
  skew 2
  boottrk 2
  os 2.2
end
```
For making the Amiga target work, you need to install the `amitools` Python package and its dependencies:
```
pipx install cython machine68k
pipx install git+https://github.com/cnvogelg/machine68k.git
pipx install git+https://github.com/cnvogelg/amitools.git
```
You might get a notification that no package is associated with `machine68k`, which you can ignore.

One final step remains: providing the Puny BuildTools with the path to your PunyInform installation. In case you haven't installed PunyInform yet, do so now. You'll find it [here](https://github.com/johanberntsson/PunyInform). 

Type `nano ~/FictionTools/.pi6rc` and enter the path to your PunyInform installation, then save. 

That's it. You've completed the setup.

## Working with the Puny BuildTools

This is currently work in progress. Please wait a day or two until I have everything properly documented. 

## Credits

This is still work in progress.

## Disclaimer and license

Do with the Puddle BuildTools what you want but whatever may happen as a result, the responsibility is all yours. Yes, even if a planet full of cute little kittens explodes.

I strongly encourage you to read the file `LICENSE` before you start working with the project.