# Puddle BuildTools for PunyInform

If you're into classic 8-bit and 16-bit home computers and you love Infocom style adventure games, we already have much in common and it's likely you appreciate a build environment, allowing you to target 25 retro systems. And what about transforming a single source file to 25 ready to use disk images in under 5 seconds? You'd like that? I have good news for you because that's essentially what the Puddle BuildTools are. The build environment runs out of the box with [PunyInform](https://github.com/johanberntsson/PunyInform), a lightweight but powerful [Inform 6](https://github.com/DavidKinder/Inform6) library, optimized to perform well on old hardware. The BuildTools are modular designed, so it would be very easy to add for support other libraries and compilers like ZILF for example. The only thing you'd need is a wrapper tool like the bundled one for Puny, which you even could use as a base. Whatever you come up with, I am looking forward to your pull requests!

## Current version

The current version is `v1.4`.

## Supported targets

Commodore 64, Amstrad CPC and PCW, Spectrum +3, Spectrum Next, Commodore Amiga, Atari 8-bit, Atari ST, MS-DOS, Apple 2, BBC Micro, Acorn Electron, Commodore 128, Mega 65, TRS-80 Color Computer, Dragon64, MSX 1 and MSX 2, Oric, Commodore Plus/4, TI99/4a, Commodore VIC-20, Commodore PET, SAM Coupé, classic Macintosh.

## Host system

The Puddle BuildTools are designed to run in `WSL2` (the Windows Subsystem for Linux) on `Windows 10` (or later). And since WSL is a full-featured Linux environment, you get this running out of the box on your favorite `Linux (64-bit)` distribution as well.

Since the commandline tools included are distributed as binaries, you'd need to recompile these for making the Puddle BuildTools work on a MacOS or BSD, in theory it's possible though.

## Installation

Note that the installation requires knowledge about Unix-like operating systems. Make sure you have `WLS2` (the Windows Subystem for Linux) installed, as described in [this guide](https://docs.microsoft.com/en-us/windows/wsl/install-win10). Go for `Debian`. It is the recommended distro as it will give you a very stable system in turn. You can optionally go for `Ubuntu`, which is Debian based.

(Linux users don't need to care about WSL of course since they are already working from a Linux environment.)

Once the prerequisites are met, switch to a Bash terminal and follow these steps.

Use the APT package manager to install these dependendcies: 

```
cpmtools 2.20-2+b1 amd64
dosfstools 4.1-2 amd64
git 2.20.1-2+deb10u3 amd64
ruby 2.5.1 amd64
```

GIT clone the Puddle BuildTools repository so that you have all the content locally on your machine. This will also make it easy for you to update to new versions when they are rolled out. 

Copy the folder `FictionTools` to your home directory. Please check before if any tools in this directory clash with versions that exist locally already. Usual suspects would be the Inform6 compiler, exomizer or the ACME compiler. The FictionTools directory includes the newest versions, so wipe possibly existing older versions in other local directories at path. 

Now add the following entries to your `.bashrc` file, which you also find in your home directory.

```bash
# WSL
alias explorer='/mnt/c/windows/explorer.exe'
alias powershell='/mnt/c/windows/System32/WindowsPowerShell/v1.0/powershell.exe'
alias code='/mnt/c/Users/Stefan/AppData/Local/Programs/Microsoft\ VS\ Code/code.exe'
export windesk="/mnt/c/Users/Stefan/OneDrive/Desktop"

# add directories to path
export PATH="$HOME/FictionTools:$PATH"
export PATH="$HOME/FictionTools/amitools/bin:$PATH"
export PATH="$HOME/FictionTools/hfsutils:$PATH"
export PATH="$HOME/FictionTools/z88dk/bin:$PATH"
export PATH="$HOME/FictionTools/z88dk/lib:$PATH"
export PATH="/sbin:$PATH"
export ZCCCFG="$HOME/FictionTools/z88dk/lib/config"
```

You probably notice that the WSL entries are hardcoded paths. You need to change these for them work, unless your name also is Stefan. Note that the WSL entries are only needed in a WSL2 environment on Windows and not on a regular Linux system. 

I recommend using Visual Studio Code as your editor, as it comes with a server that allows connecting to WSL2. And it's a brilliant editor anyway. 

Next edit the file `/etc/cpmtools/diskdefs` with an editor of choice. If you want to stay in the Terminal, you may use VIM, but you can also edit it with VSCode of course. Add the following definition to the file, it's going to teach the `cpmtools` package how to handle SAM Coupé Pro-DOS disk images.

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
```

You want to make sure that you properly copied the current PunyInform release to your file system. It's recommended that you clone the repository for easy updating. 

The last thing to do is editing the `puny` wrapper program that is located in the `FictionTools` in your home directory. Again, use an editor of choice and edit this line to the path where you installed PunyInform. It's found pretty much at the beginning of the file.

```
lib=~/Projects/8bit/Z-Machine/lib/lib/
```

Leave all the other content as is. Save.

Congratulations, you completed the basic setup.

## Project config

So how do you use this now for your own projects? The first thing you need to do is making a copy of the `Build` directory that came with the BuildTools package and put that in a place (inside WSL2) where you want your projects stored. Rename the Build directory to your project's name, e.g. "MyIFGame".

Inside your freshly created project directory, you find quite a few files. Don't be overwhelmed! You'll be getting used to these in no time. For your convenience, I've added a file called `shell.inf`, which basically is a preconfigured template on steroids, an advanced starting point for a new interactive fiction piece of yours. So either rename it to your project e.g. "MyIFGame.inf" or just delete in case you don't need it. 

Open the file `configure.sh` and edit it accordingly. You might want to leave the wrapper as is. The value contained is default if you're going to use PunyInform. 

I also recommend editing the file `test.sh`. This is the script that you launch when you quickly want to test something after you changed the source code. It created z3 and z5 versions of your games and then automatically launches Frotz on Windows to test the z3 version. The path to Frotz is hardcoded and likely differs from your path, change it so that it fits. 

Last file to edit for now would be `bundle.sh`, but only if you're not inside WSL2. If you're on Linux, you might want to change the `$windesk` variable to the path of your desktop. If you are using WSL2, you already defined `$windesk` in `.bashrc` and needn't worry about it in the bundle shell script. 

## Usage

The usage is more or less easy. If you want to build a certain target, switch to your project directory (in case you're not already there) and just fire the corresponding script from Bash. So for the Commodore C64 for example it would be `c64.sh`. Make sure you've given the scripts the rights being executed as a program using CHMOD. 

**I suggest you try to build every target one by one now and see if you get a working disk image.**

Important note: by default the build / project dir is configured to use intro screens on these platforms: 

C64, Plus/4, Amiga, Atari ST, Amstrad CPC, ZX Spectrum, BBC, Acorn Electron, MS-DOS, SAM Coupé and MSX. 

I wanted to keep this in to show you how it's done. Be warned, it's a rabbit hole. When you build one of the above mentioned targets the first time, you will likely notice that the resulting disk images comes with a screen from my game Hibernated 1 Director's Cut. I've added these resources so you have a working example. If you either want to turn the intro screens off now or simply want to update them with your very own gorgeous screen, the following tutorials show you how to do it per target.

**Commodore 64**

I recommend sticking with a loading screen as it is fairly easy to create. Use [Multipaint](http://multipaint.kameli.net/) to create a C64 multicolor Koala image. Name it `loaderpic.kla` and put it in `/Interpreters/Ozmoo/OzmooLoadPic`, replacing the file that's already in there. If you really don't want to showcase a loading screen: the `test.sh` script builds a C64 disk image without screen for you.

**Amstrad CPC**

This one is harder to achieve. Create the image using Multipaint and save it as a PNG image. Open the PNG image in Photoshop or GIMP, scale it to 160x200 and create an indexed PNG image from it. You need to make sure that it's limited to the palette Amstrad CPC palette. For both Photoshop and GIMP you find palette files on the internet. Once you have a valid image you can use `png2crtc` and `dump-pal.py` to create a valid SCREEN and PAL file.

```
png2crtc MYSCREEN.PNG SCREEN 7 0
dump-pal.py MYSCREEN.PNG PAL
```
Put the files SCREEN and PAL in the `Resources` folder in the project dir, replacing the files already in there.

In case you don't want to use an intro image on the Amstrad CPC, alter the `cpc_pcw.sh` script so that the files DISC, SCREEN and PAL are not written to the disk image. Your users will then need to switch to CP/M themselves on the CPC by typing `|CPM` and the game may then be launched with `INTERPRE.COM`.  

**Plus/4 (and expanded C16)**

Use Multipaint to create a Botticelli multicolor image. Name it to `picplus4.mb` and throw it in `Resources`, replacing the file of the same name. If you want to disable the image, edit `plus4.sh` and delete this sequence from the compilation command: `-i picplus4.mb`. 

**Commodore Amiga**

Use a tool like [Grafx2](http://grafx2.chez.com/) to create a valid `.iff` file. If you really hail the past with every breath you make, you might of course do it in Deluxe Paint as well. Use an Amiga .adf disk image editor like `ADF Opus` (not included) to put the file on the `S-PIC` ADF disk image which you find in `Interpreters/Tools`. Optionally just use `xdftool` for putting the file on disk, which has been installed together with the FictionTools. Now fire up `Workbench` and open the AmigaDOS CLI and use the s-pic utility to transform your IFF image into a self-executing intro. Save the file as loader and put it on the template disk `amiga_ZIP_pic.adf` (Z-machine v3) or `amiga_Infocom_z5_pic.adf` (Z-machine v5), depending on which interpreter which you defined to use in the Amiga script. You find both templates in `Interpreters`.

In case this is too cumbersome for you, which I can totally understand, just edit the `amiga.sh` script and either replace all instances of `amiga_ZIP_pic.adf` with `amiga_ZIP.adf` or replace all instances of `amiga_Infocom_z5_pic.adf` with `amiga_Infocom_z5.adf`, again depending on the interpreter and Z-machine version (v3 or v5) you prefer. I prepared these disk images so that they go straight into your story. Learn more about the available Amiga interpreters in the interpreter section below.

**Atari ST**

Use Multipaint to create a valid `.PI1` image.  Launch your emulator of choice, Hatari is recommended, and map the directory `Interpreters/Tools/MKINTRO` as GEMDOS hard disk drive. Hatari might want to restart. If that's the case, no worries. It's fine. Make sure you've put your PI1 image somewhere in the `MKINTRO` folder. Run the MKINTRO.PRG. You are now able to creat your own Atari ST intro. Save the resulting output as `INTRO.PRG` and copy it in `Resources` replacing the file of the same name. 

In case you don't want to use an intro on the Atari ST, just delete these lines from `atari_st.sh`. 

```
mkdir AUTO
cp Resources/INTRO.PRG ./AUTO/INTRO.PRG
zip -rv ${STORY}.zip AUTO/INTRO.PRG AUTO/INTRO.PRG
```

**ZX Spectrum**
The Spectrum, provided you are going to use the interpreter George and I created, is quite the hardest one to achieve, so I suggest to not look into it. If you still want to check it out, use Multipaint to create the SCR file. The tutorial and content how to do it is available [here](https://github.com/markgbeckett/zx_spectrum_cpm/tree/main/screen_loader). The compiler necessary (z88dk) has already been installed with the FictionTools. Once done, replace the SCRLOAD.COM output file on the template disk named `Spec_SCRload.dsk` in `Interpreters` with the SCRLOAD.COM file that you created. You may use a tool like `CPCDiskXP` (not included) for that purpose. 

If you don't want to use an intro screen on the ZX Spectrum, change all references in `speccy.sh` from `Spec_SCRload.dsk` to `Spec_Infocom.dsk`.

**BBC / Acorn Electron**

This one is easy. Use [BBC Micro Image Converter](https://www.dfstudios.co.uk/software/bbc-micro-image-converter/) to create a valid image and save it as `screen.bbc`. Replace the file in `Resources` with yours.

If you don't want to use the splash image feature simply delete sequence `--splash-image screen.bbc` from the `bbc_acorn.sh` script.

**MS-DOS**

For MS-DOS, no disk is created. Instead, you find the game files in the folder `Releases/DOS`. For showing an intro screen, create a PNG image in Photoshop or GIMP with a 300x200 size, conforming to the constraints of VGA. Save it as SCREEN.PNG copy it in the DOS directory, so that it replaces the file already in there. 

In case you don't want to show an intro screen, just edit the file `PLAY.BAT` and delete the first line containing this sequence `viewer.exe screen.png`.

**MSX**

The MSX, once again, is very easy. Just create MSX Mode 2 image with Multipaint. Save it as `LPIC.SC2` and drop it in `Resources`, where it's going to replace the already existing file. 

For the MSX, unfortunately there is no easy way to disable the intro screen feature. I would need to setup a completely new template disk at some point down the road. I surely will, but for now you're stuck with it. But who doesn't like screens anyway? 

**SAM Coupé**

The SAM Coupé requires a SCREEN and PAL file to work. In the `Interpreters/Tools` directory you find a guide, which [@SamsterDave](https://twitter.com/SamsterDave) kindly provided. Once you followed these steps, replace the SCREEN and PAL file on the `SAM_image.cpm` template disk found in `Interpreters` with your own creations. 

If you don't intend to use an intro screen on the SAM, just edit `sam_coupe.sh` and replace all occurances of `SAM_image.cpm` with `SAM_Coupe.cpm`. You may then start the game with `INTERPR.COM`.

**So much for the intro / loading screens.**

When all targets compile to your satisfaction, you may use the `all.sh` script to compile all targets at once. This is the advertised "from source to 25 ready-to-use disk images in 5 seconds" feature. After compilation, run the `bundle.sh` to create .ZIP file containing all targets and additional content such as documentation, ready for distribution. By default it's going to be placed on your desktop. Be sure to check `bundle.sh` if there are any files you don't want to have in, or maybe you want to add something. The script is fairly easy to customize to suite your needs. The bundled files `readme.txt` and `licenses.txt` are found in the `Releases` dir and may be altered to suite your needs. You need to keep the Pro-DOS license information in though, as that is a requirement for you to distribute the operating system with your game. The SAM Coupé version is Pro-DOS based.

**Is there something else to know?** 

Note that one target don't have its own script. The ZX Spectrum Next has native Z-machine support built-in, so you just put the z3 or z5 file on a SD card and you're able to play it, hence no script for the Next.

## Going Z-machine v5 only as a design choice

You might want to say now that targeting 25 systems is great, but what if I want to write a Z-machine version 5 game which, based on the [Z-machine specs](http://inform-fiction.org/zmachine/standards/z1point0/appd.html), would be an understandable design choice? Your story file may be much larger, you may include a ton of objects more in comparsion to z3, dictionary words are stored with a length of 9 characters, you may draw your own status line, absolutely everything is improved and less constrained with z5, giving you the freedom to fully focus on writing rather than counting bytes. The downside is that not every platform is capable of running a Z-machine v5 game, not only because of the lack of the proper interpreter but also in terms of performance. Still, you can target a fair good amount of machines if you want to go z5 for your game and choose freedom over system availability. 

**What systems may I target with z5?**

Commodore 64, Commodore Amiga, Atari ST, Spectrum Next, MS-DOS, BBC Micro, Acorn Electron, Apple II, Commodore 128, Mega 65, Commodore Plus/4, classic Macintosh.

Just in case you're counting now... that's 12 of 25.

**How do I target z5?**

Please keep in mind that this feature is meant for people whose story file will exceed the constraints of z3 so they intentionally choose to create a z5 game. Please **do not** alter the single build scripts in your project directory, like `amiga.sh` for example. Instead, you compile all your targets at once with just one script which is called `z5_all.sh`. So if you want to alter something, e.g. adding a loader image for example, do it in `z5_all.sh` instead.

## Creating a modern PC version

I've added a script that allows you to generate a modern PC version (using Parchment). I't a Powershell script and I have only tested it under Windows, but Powershell also exists for Linux, so it might work for you. It invokes Andrew Plotkin's `ifsitegen.py` which uses an existing Inform 7 installation and ideally an updated Parchment somewhere in the Inform 7 resources. In my humble opinion generating modern PC versions is beyond the scope of this project but since I already had something, I wanted to include it anyway. If you're only distributing the Z-machine files for modern computers, nuke the script and delete any references from the `bundle.sh` that add the `Modern` folder located in the `Releases` dir, which is where the `modern.ps1` will produce its output files.

## Testing games / configuring emulators

You probably will be disappointed now but I am not able to help you in setting up 25 emulators. I am also not able to teach you how to work with a certain 8-bit or 16-bit home computer. I hope you understand that this would go far beyond the scope of this project. If you need a starting point, just look at the `readme.txt` file you find in `Releases` as it comes at least with instructions how to load the game on every target.

## Hibernated 1 Director's Cut

What you also find in the project directory is the source of my award-winning game `Hibernated 1 Director's Cut`. The Hibernated 1 source code is provided for personal, educational use only. You can read it, and copy the programming techniques, but you can't make derivative games. 

## Interpreters

One thing to mention in advance: when targeting 25 classic systems at once, you have to go for the smallest common denominator, which means when using the BuildTools, your game design needs to conform to the constraints of Z-machine version 3, so the story file for instance may not exceed 128k. The BuildTools auto-generate a z5 story only for a few interpreters but mostly for cosmetical reasons. You could however do something fancy and enable UNDO for the z5 targets, see H1DC sources to learn how I did it.

Here is a quick reference of the interpreters used. 

**C64, C128, Plus/4, Mega65**

Ozmoo by Fredrik Ramsberg and Johan Berntsson.

**Apple II**

Infocom interpreter, version K.

**MS-DOS**

Frotz, originally by Stefan Jokisch, DOS port maintained by David Griffith. The BuildTools create a z5 story file for this interpreter.

**Atari 8-bit**

Various Infocom interpreters. By default, the BuildTools use the early Atari 8-bit interpreter, which expects both interpreter and story on a single disk. While this works well, it can become a problem when your game makes use of the full 128k a Z-machine version 3 game may hold, thus exceeding the size of a regular Atari 8-bit disk image (either 90k or 130k), because it's always story file plus interpreter. Infocom addressed the issue a long time ago by creating a two disk interpreter for the Atari 8-bit. It expects an altered story file with a different header and the story split at a certain offset for it to work.

The BuildTools recover the ability to target the late Atari 8-bit Infocom interpreters (version B - G), so that the constraints of the Atari 8-bit disk won't affect you, and more importantly your game design. By default, the `a8bit.sh` build script bundles the early interpreter but you can invoke it with flag `-2` to create a two disk distribution using the final Atari 8-bit interpreter Infocom released, which is version G. The Atari build script has a disk creator utility embedded, which takes care of patching your story file, splitting it at the defined offset and then creating the two disks which allow you to play the game. In the build directory, fire the script like this `a8bit.sh -2` and the magic will happen. You may also want to change `all.sh` by adding the `-2` flag and please consider editing `bundle.sh` so that you make sure it will zip both disk files. 

The BuildTools create Atari 8-bit disk images that work on FujiNet, SIO2SD and real hardware. Many thanks to Thomas Cherryhomes for his support.

**BBC Micro / Acorn Electron**

Ozmoo for Acorn by Steven Flintham.

**Commodore Amiga**

You may choose here between Z-machine v3 and v5. 

The recommended z3 interpreter is ZIP by Mark Howell, the author of the Amiga port though is unknown. I stumbled upon this specific version on an old Amiga FTP server and from what I saw it's not preserved elsewhere. It's notably the only Amiga ZIP version I found that works without issues on all hardware, from the Amiga 500 to the 4000. It's also the only one I saw with a custom (black/white) color scheme. This is a free interpreter so the BuildTools are configured to use it by default. You can however select Infocom's z3 interpreter as well. 

If you choose z5 for the Amiga, then Infocom's interpreter is the default. But it's not a friend of Puny's way to draw the statusline. So if you intentionally want to use z5 because of the advanced features, have a look at the `DrawStatusLine` code I've added to the `shell.inf` file and learn how to make the interpreter work for Puny z5 games. Apart from that it's a very nice interpreter. 

You could also use Amiga Frotz, but I actually found it not working well on old machines so I am not recommending it. It has less columns than Infocom's interpreter and a few other issues. Nevertheless I am providing disk images for it, too. 

Please have a look at the names of the Amiga interpreter disk images in the `Interpreters` directory and rename the values in the `amiga.sh` script accordingly. Please also make sure to edit the `#compile` and `#prepare story` parts of the script to the values seen below for z5 interpreter usage.

```shell
#compile
${WRAPPER} -5 ${STORY}.inf

#prepare story 
cp ${STORY}.z5 Story.Data
```

Note that if you use the `z5_all.sh` script, the Amiga target gets compiled to Z-machine version 5 regardless of what you have specified in the `amiga.sh` script. `z5_all.sh` only compiles z5 capable targets and since you have more options on the Amiga, it automatically applies z5, which hopefully makes sense.  

**Amstrad CPC / PCW**

Infocom interpreter, modified to load a generic STORY.DAT file. What's unique here is that the interpreter is a combined binary that works on both the Amstrad CPC and the PCW. No, that's not usual and very impressive.

**MSX 1 / MSX 2**

This interpreter comes from Brazil. The author is unknown to me. It plays in 40 columns mode on a MSX 1 machine and in 80 columns mode on a MSX 2 machine. Technically a great and very impressive interpreter but I had to hack the binary very badly to fix a few bugs and wordings.

**Classic Macintosh** 

MaxZip by Andrew Plotkin aka Zarf. You need at least System 7 to make this interpreter run.

**SAM Coupé**

Interpreter by an unknown author. It is configured for Pro-DOS, the CP/M compatible operating system for the SAM by Chris Pile. 

**Spectrum +3**

Interpreter by Infocom and George Beckett. It was a long road to this one. You notably need Locomotive CP/M Plus for running it. We basically took one of Infocom's CP/M interpreters as the base. In the Deadline era, Infocom spread a little configuration source with their CP/M game versions, allowing you to alter certain settings of the interpreter and recompile so that it runs on your specific CP/M system. The compiler that comes with Locomotive CP/M Plus understands intel bytecode, so we were able to recompile an interpreter for the ZX Spectrum. And it performs way better than any other interpreter we've seen on that machine.

**Oric Atmos & Telestrat**

PInforic by Jose-Maria Enguita and Fabrice Frances.

**Atari ST**

Infocom interpreter. This is Z-machine version 5, so the BuildTools create a z5 story file for this target.

**TI99/4a**

Master's Interpreter by Barry Boone. This version is from 1988 and runs just perfectly in 40 columns as well as in 80 columns with one of the hardware enhancements.

**TRS Coco**

Infocom interpreter. This is version D without the infamous Tandy bit. It's not based on the sources that Professor Moriarty shared and preserved, these were version C. 

**Dragon64**

Interpreter by a person called Pere. I stumbled upon this in a Spanish forum.

**Commodore VIC-20 & PET**

Interpreters by Edilbert Kirk.

## Credits

Countless people have contributed directly or indirectly to this project. While I am not able to name them all, I'd like to thank you from the bottom of my heart. Without you lighting my path, none of this would exist now. Special thanks to Infocom for being a constant inspiration, to Graham Nelson for his work on Inform 6, to Fredrik Ramsberg and Johan Berntsson for creating PunyInform, to Andrew Plotkin for all he does for the community. I'd also like to thank Hugo Labrande, who was so kind to act a beta tester for the Puddle BuildTools.

This release is dedicated to John Wilson, better known as Rochdale Balrog, legendary founder of Zenobi Software. In the shimmering, glowing night sky that was the vibrant UK adventure scene, you were the North Star. And even though you may be gone now, your light still shines for us, guides us. Until we meet again at the end of time.

## Disclaimer and license

Do with the Puddle BuildTools what you want but whatever may happen as a result, the responsibility is all yours. Yes, even if a planet full of cute little kittens explodes.

I strongly encourage you to read the file `LICENSE` before you start working with the project.