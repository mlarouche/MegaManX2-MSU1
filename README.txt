Mega Man X2 MSU-1 hack
Version 1.0
by DarkShock and Exort

This hack adds CD quality audio to Mega Man X2 using the MSU-1 chip invented by byuu.
The hack has been tested on SD2SNES and higan 094. The patched ROM needs to be named mmx2_msu1.sfc.

Note they are two IPS patches:
- mmx2_msu1_emulator.ips is the one to use for proper volume in emulators.
- mmx2_msu1.ips is for the SD2SNES

===============
= Using higan =
===============
1. Patch the ROM
2. Launch it using higan
3. Go to %USERPROFILE%\Emulation\Super Famicom\mmx2_msu1.sfc in Windows Explorer.
4. Copy manifest.bml and the .pcm file there
5. Run the game

====================
= Using on SD2SNES =
====================
Drop the ROM file, mmx2_msu1.msu and the .pcm files in any folder. (I really suggest creating a folder)
Launch the game and voilà, enjoy !

===============
= Music       =
===============


=============
= Compiling =
=============
Source is availabe on GitHub: https://github.com/mlarouche/MegamanX2-MSU1

To compile the hack you need

* bass v14 (http://files.byuu.org/download/bass_v14.tar.xz)
* wav2msu (https://github.com/mlarouche/wav2msu)

The rom needs to be named mmx3_msu1.sfc and be the version 1.1 of the game.

To distribute the hack you need

* uCON64 (http://ucon64.sourceforge.net/)
* 7-Zip (http://www.7-zip.org/)

make.bat assemble the patch
create_pcm.bat create the .pcm from the WAV files
distribute.bat distribute the patch
make_all.bat does everything
