@ECHO OFF

del /q MegaManX2_MSU1.zip
del /q MegaManX2_MSU1_Music.7z

mkdir MegaManX2_MSU1
ucon64 -q --snes --chk mmx2_msu1.sfc
ucon64 -q --mki=mmx2_original.sfc mmx2_msu1.sfc
ucon64 -q --snes --chk mmx2_msu1_emulator.sfc
ucon64 -q --mki=mmx2_original.sfc mmx2_msu1_emulator.sfc
copy mmx2_msu1.ips MegaManX2_MSU1
copy mmx2_msu1_emulator.ips MegaManX2_MSU1
copy README.txt MegaManX2_MSU1
copy mmx2_msu1.msu MegaManX2_MSU1
copy mmx2_msu1.xml MegaManX2_MSU1
copy manifest.bml MegaManX2_MSU1
"C:\Program Files\7-Zip\7z" a -r MegaManX2_MSU1.zip MegaManX2_MSU1

"C:\Program Files\7-Zip\7z" a MegaManX2_MSU1_Music.7z *.pcm

del /q mmx2_msu1.ips
del /q mmx2_msu1_emulator.ips
rmdir /s /q MegaManX2_MSU1