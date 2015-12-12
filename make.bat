@ECHO OFF
del mmx2_msu1.sfc
del mmx2_msu1_emulator.sfc

copy mmx2_original.sfc mmx2_msu1.sfc

set BASS_ARG=
if "%~1" == "emu" set BASS_ARG=-d EMULATOR_VOLUME

bass %BASS_ARG% -o mmx2_msu1.sfc mmx2_msu1.asm

copy mmx2_original.sfc mmx2_msu1_emulator.sfc
bass -d EMULATOR_VOLUME -o mmx2_msu1_emulator.sfc mmx2_msu1.asm