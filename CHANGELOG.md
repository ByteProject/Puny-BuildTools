# Changelog

## 2.1 (Pillars of Creation)

* removed 'trsread' from binary distribution
* added 'trs80-tool' to binary distribution
* added Infocom's MS-DOS .z5 interpreter version 6J
* TRS-80 modules now use 'trs80-tool'to list the disk directory
* MS-DOS module now builds projects with Infocom interpreters by default (lower memory footprint)
* added OrbStack resource file '.punyorb' for MacOS hosts
* modules using Wine now disabled on MacOS (TRS80 Model 3 & 4), as Wine doesn't work in OrbStack
* updated 'installation' chapter in the documentation
* added 'limitations' chapter to the documentation

## 2.0.1 (Helix Nebula minor update)

* updated Inform compiler binary: fixing zchar_weight 1 instead of 4, plural flags, new /~n flag
* CLI feature: current git version appended to CLI version number
* introducing 'hacks' logic
* hack feature: Apple 2 module can use Infocom interpreter for .z3 target
* hacks chapter added to the documentation

## 2.0 (Helix Nebula)

* project rebranded to 'The Puny BuildTools'
* documentation has been completely rewritten
* simplified and accessible installation process
* host system now Linux 64-bit only, optimized for Debian/Ubuntu
* preconfigured to be compatible with WSL2 (Windows) and OrbStack (MacOS)
* project structure and logic completely redesigned
* version system implemented for all components and modules
* centralized interpreters and disk image templates
* former build scripts heavily improved and refactored to CLI modules
* added 'bundle.sh' release archiver
* configuration file format update
* integrated Vezza interpreter by Shawn Sijnstra as standard for a broad range of targets
* integrated Jindroush's Atari 8-bit interpreter for z5 targets
* fixed problem with Atari 8-bit games not working properly if story file too small
* Atari 8-bit XZIP target now built on improved disk image: Single-Sided, Double-Density, 180kb capacity (1050 and XF551 disk drives)
* countless interpreter and disk template updates (really, I lost track)
* default target architecture now Z-machine version 5 since all available targets do support now both .z5 and .z3: C64, Amiga, ZX Spectrum, Amstrad CPC/PCW, Atari ST, Atari 8-bit, MS-DOS, MSX, BBC Micro/Acorn Electron, C128, Plus/4, Apple II, SAM Coupe, TRS80 Model 3, TRS 80 Model 4, Mega65, classic Macintosh
* the following targets have been deprecated and considered unsupported but are still available for Z-machine v3 only: VIC20/PET, DEC Rainbow, TRS CoCo/Dragon64, Osborne1, Ti99/4a, Oric, Kaypro
* environment variables and paths sourced out in '.punyrc', '.punywsl' and '.pi6rc'
* added dedicated command-line interface 'Puny CLI'
* CLI feature: project initialization
* CLI feature: configuration file editor
* CLI feature: project compilation
* CLI feature: create optimized abbrevations for project (uses ZAbbrevMaker by Henrik Åsman)
* CLI feature: test project (compile and run)
* CLI feature: list target systems and valid build arguments
* CLI feature: version information for all bundled components and modules
* CLI feature: disk image factory
* auto-build disk images with loading screen when pixel artwork is found in the project's 'Resources' folder
* pixel artwork guide for all targets supporting loading screens
* 'An Author's Guide to the Galaxy' as a real-life example of how you would work with the Puny BuildTools
* added 'pi6', a super accessible Inform 6 compiler wrapper, preconfigured to use PunyInform as library (doesn't need a project structure)
* added updater and permissions editor 'Puny-Wan Kenobi'
* Kenobi feature: update local Puny BuildTools installation
* Kenobi feature: check if Puny BuildTools have sufficient permissions
* Kenobi feature: fix permissions of existing Puny BuildTools installations
* added 'ifftool.sh', a Commodore Amiga/MEGA65 IFF screen maker, which converts .PNG images to .IFF images in Amiga and Mega65 resolutions, can also compile .PNG images to executable Amiga binaries
* added 'cpcscr.sh', an Amstrad CPC screen maker, which converts .PNG images to CPC loading screens, palette files and BASIC loaders, using 'martine' as backend
* added 'degaspi1.sh', an Atari ST (Degas .PI1) screen maker, which converts .PNG images to Degas .PI1 format
* added 'makescr.sh' a ZX Spectrum CP/M+ loading screen maker
* 'punycustom' folder feature, which will use files placed in there in favor of Puny library files and extensions
* latest Inform compiler changes from Zarf's branch integrated
* a billion other things I am confident I forgot to mention here

## 1.5

* support for new target systems via additional build scripts: TRS-80 Model 3, TRS-80 Model 4, DEC Rainbow, Osborne 1, Kaypro
* added sanitized disk images for the new target systems
* updated readme template providing loading instructions in Releases dir
* bundled Hibernated 1 Director's Cut source is now R12
* added new targets to bundle script
* updated gitignore sample, fixed Atari 8-bit 2-disk interpreter image ignores, added DOS directory to ignored paths
* appended all.sh script with the new targets
* bumped puny command line utility in FictionTools
* documentation update

## 1.4

* added Atari 8-bit disk creator utility, which allows to bundle games using either the early Infocom interpreter (single disk) or the late Infocom interpreter (two disks) working around the constraints of Atari disks when having a large story file
* added multiple binary template files used by the Atari 8-bit disk creator utility
* added version B, E and G of the late Infocom Atari 8-bit interpreter, the creator utility uses version G by default
* the puny wrapper tool no longer auto-generates Atari 8-bit images as the target has its own build script in the Build directory now (a8bit.sh)
* updated documentation, added Atari 8-bit disk creator usage (see interpreters section)
* updated the Hibernated 1 Director's Cut sources to R10


## 1.3

* the line to include the generic abbreviations in shell.inf is no longer commented, which absolutely made no sense anyway
* moved the abbreviations wrapper script to the build directory
* added ZAbbrevMaker by Henrik Åsman @heasm66 as standard tool for generating optimized story abbreviations
* fixed an error in the H1DC source that originated from a default message suffix change in PunyInform, thanks to @spacehobo for the pull request
* upgrade to Inform 6 compiler v6.36 (dev) as the new version comes with a much better abbreviations logic

## 1.2

* appended Apple II target to z5_all.sh
* added Infocom's Apple IIe z5 interpreter
* optional interpreter Amiga Frotz (z3 and z5 capable) included
* new binary cc1541 in FictionTools

## 1.1

* added script that allows you to build a Z-machine version 5 game for all targets capable of running z5
* own DrawStatusLine routine for z5 games as Puny's routine might cause misbehavior with some of the Infocom interpreters (see shell.inf)
* added templates with Infocom's only Amiga based Z-Machine version 5 interpreter
* upgrade to Inform 6 compiler v6.36 (dev)
* documentation update

## 1.0

* initial release
