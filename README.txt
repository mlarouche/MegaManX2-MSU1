Mega Man X2 MSU-1
Version 1.0
by DarkShock and Exort

This hack adds CD quality audio to Mega Man X2 using the MSU-1 chip invented by byuu.
The hack has been tested on SD2SNES, bsnes-plus and higan 094. The patched ROM needs to be named mmx2_msu1.sfc.

Note they are two IPS patches:
- mmx2_msu1_emulator.ips is the one to use for proper volume in emulators.
- mmx2_msu1.ips is for the SD2SNES

The music pack can be found here:
http://www.mediafire.com/download/rqbld7el8x1qllp/MegaManX2_MSU1_Music.7z

Original ROM info:
MEGAMAN X2
U.S.A.
1572864 Bytes (12.0000 Mb)
Interleaved/Swapped: No
Backup unit/emulator header: No
Version: 1.0
Checksum: Ok, 0x09b7 (calculated) == 0x09b7 (internal)
Inverse checksum: Ok, 0xf648 (calculated) == 0xf648 (internal)
Checksum (CRC32): 0x947b0355

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

===========
= Credits =
===========
DarkShock - Music editing, ASM hacking
Exort - ASM hacking
Krzysztof Slowikowski - Music reorchestration

Find out the original video here: https://www.youtube.com/watch?v=HQ9oQCCSw8o and check out his other stuff on his channel !

===============
= Music       =
===============
01 = Morph Moth
02 = Magna Centipede
03 = Wire Sponge
04 = Bubble Crab
05 = Flame Stag
06 = Overdrive Ostrich
07 = Wheel Gator
08 = Intro Stage (Opening)
09 = Boss 1 (Boss Fight)
10 = Boss 2 (Another Boss 2)
11 = Title
12 = Stage Select 1
13 = Password
14 = Crystal Snail
15 = Stage Start
16 = Zero
17 = X Hunter Stage 2
18 = Stage Select 2
19 = Boss defeated (Stage Cleared)
20 = Story (Opening)
21 = Boss intro 2 (Another Boss 1)
22 = Boss intro 1
23 = Get a Weapon
24 = X Hunter Stage 1
26 = Intro Stage, again (Opening)
27 = Cutscene (Demo)
28 = Sigma 1
29 = Sigma 2
30 = Ending
31 = Staff roll
32 = Laboratory

=============
= Compiling =
=============
Source is availabe on GitHub: https://github.com/mlarouche/MegamanX2-MSU1

To compile the hack you need

* bass v14 (http://files.byuu.org/download/bass_v14.tar.xz)
* wav2msu (https://github.com/mlarouche/wav2msu)

The rom needs to be named mmx2_msu1.sfc

To distribute the hack you need

* uCON64 (http://ucon64.sourceforge.net/)
* 7-Zip (http://www.7-zip.org/)

make.bat assemble the patch
create_pcm.bat create the .pcm from the WAV files
distribute.bat distribute the patch
make_all.bat does everything
