arch snes.cpu

// MSU memory map I/O
constant MSU_STATUS($2000)
constant MSU_ID($2002)
constant MSU_AUDIO_TRACK_LO($2004)
constant MSU_AUDIO_TRACK_HI($2005)
constant MSU_AUDIO_VOLUME($2006)
constant MSU_AUDIO_CONTROL($2007)

// SPC communication ports
constant SPC_COMM_0($2140)

// MSU_STATUS possible values
constant MSU_STATUS_TRACK_MISSING($8)
constant MSU_STATUS_AUDIO_PLAYING(%00010000)
constant MSU_STATUS_AUDIO_REPEAT(%00100000)
constant MSU_STATUS_AUDIO_BUSY($40)
constant MSU_STATUS_DATA_BUSY(%10000000)

// Constants
if {defined EMULATOR_VOLUME} {
	constant FULL_VOLUME($60)
	constant DUCKED_VOLUME($20)
	constant FADE_DELTA(1)
} else {
	constant FULL_VOLUME($FF)
	constant DUCKED_VOLUME($60)
	constant FADE_DELTA(2)
}

// Variables
variable fadeState($180)
variable fadeVolume($181)

// FADE_STATE possibles values
constant FADE_STATE_IDLE($00)
constant FADE_STATE_FADEOUT($01)
constant FADE_STATE_FADEIN($02)

// **********
// * Macros *
// **********
// seek converts SNES LoROM address to physical address
macro seek(variable offset) {
  origin ((offset & $7F0000) >> 1) | (offset & $7FFF)
  base offset
}

macro CheckMSUPresence(labelToJump) {
	lda.w MSU_ID
	cmp.b #'S'
	bne {labelToJump}
}

// Hijack NMI routine
seek($00FFEA)
	dw MSU_VBlankUpdate

// Add a hook to where the sound effects/special commands are played
seek($0883FC)
	jsl MSU_SoundEffectsAndCommand

// Password
seek($00845F)
	jsr MSU_Main
	
// Story
seek($008910)
	jsr MSU_Main
	
// Title
seek($808B62)
	jsr MSU_Main
	
// Cutscene
seek($009ACB)
	jsr MSU_Main
	
// ??
seek($009AE3)
	jsr MSU_Main
	
// ??
seek($009AF0)
	jsr MSU_Main
	
// ??
seek($009B10)
	jsr MSU_Main
	
// ??
seek($009BEF)
	jsr MSU_Main
	
// ??
seek($009843)
	jmp MSU_Main
	
// Game
seek($00984C)
	jmp MSU_Main
	
seek($00FE78)
scope MSU_Main: {
	php
// Backup A and Y in 16bit mode
	rep #$30
	pha
	phy
	
	sep #$30 // Set all registers to 8 bit mode
	tay
	
	// Check if MSU-1 is present
	CheckMSUPresence(MSUNotFound)
	
	// Set track
	tya
	sec
	sbc.b #$11
	tay
	sta.w MSU_AUDIO_TRACK_LO
	stz.w MSU_AUDIO_TRACK_HI

CheckAudioStatus:
	lda.w MSU_STATUS
	
	and.b #MSU_STATUS_AUDIO_BUSY
	bne CheckAudioStatus
	
	// Check if track is missing
	lda.w MSU_STATUS
	and.b #MSU_STATUS_TRACK_MISSING
	bne MSUNotFound
	
	// Play the song and add repeat if needed
	jsr TrackNeedLooping
	sta.w MSU_AUDIO_CONTROL
	
	// Set volume
	lda.b #FULL_VOLUME
	sta.w MSU_AUDIO_VOLUME
	
	// Reset the fade state machine
	lda.b #$00
	sta.w fadeState
	
	rep #$30
	ply
	pla
	plp
	rts
	
// Call original routine if MSU-1 is not found
MSUNotFound:
	rep #$30
	ply
	pla
	plp
	
	jsr $8465
	rts
}

scope TrackNeedLooping: {
// capcom logo
	cpy.b #$00
	beq NoLooping
// Title
	cpy.b #$0B
	beq NoLooping
// Stage start
	cpy.b #$0F
	beq NoLooping
// Boss defeated
	cpy.b #$13
	beq NoLooping
// Story
	cpy.b #$14
	beq NoLooping
// Ending
	cpy.b #$1E
	beq NoLooping
// Staff roll
	cpy.b #$1F
	beq NoLooping
	lda.b #$03
	rts
NoLooping:
	lda.b #$01
	rts
}

scope MSU_VBlankUpdate: {
	php
	sep #$20
	pha
	
	CheckMSUPresence(OriginalCode)
	
	// Switch on fade state
	lda.w fadeState
	cmp.b #FADE_STATE_IDLE
	beq OriginalCode
	cmp.b #FADE_STATE_FADEOUT
	beq .FadeOutUpdate
	cmp.b #FADE_STATE_FADEIN
	beq .FadeInUpdate
	bra OriginalCode
	
.FadeOutUpdate:
	lda.w fadeVolume
	sec
	sbc.b #FADE_DELTA
	bcs +
	lda.b #$00
+;
	sta.w fadeVolume
	sta.w MSU_AUDIO_VOLUME
	beq .FadeOutCompleted
	bra OriginalCode
	
.FadeInUpdate:
	lda.w fadeVolume
	clc
	adc.b #FADE_DELTA
	bcc +
	lda.b #FULL_VOLUME
+;
	sta.w fadeVolume
	sta.w MSU_AUDIO_VOLUME
	cmp.b #FULL_VOLUME
	beq .SetToIdle
	bra OriginalCode

.FadeOutCompleted:
	lda.b #$00
	sta.w MSU_AUDIO_CONTROL
.SetToIdle:
	lda.b #FADE_STATE_IDLE
	sta.w fadeState

OriginalCode:
	pla
	plp
	jmp $1fef
}

if (pc() > $00FFB0) {
	error "Overlow detected"
}

seek($08FDB0)
scope MSU_SoundEffectsAndCommand: {
	php
	
	sep #$20
	pha
	
	CheckMSUPresence(MSUNotFound)
	
	pla
	// $F5 is a command to resume music
	cmp.b #$F5
	beq .ResumeMusic
	// $F6 is a command to fade-out music
	cmp.b #$F6
	beq .StopMusic
	// $FE is a command to raise volume back to full volume coming from pause menu
	cmp.b #$FE
	beq .RaiseVolume
	// $FF is a command to drop volume when going to pause menu
	cmp.b #$FF
	beq .DropVolume
	// If not, play the sound as the game excepts to
	bra .PlaySound
	
.ResumeMusic:
	// Stop the SPC music if any
	lda.b #$F6
	sta.w SPC_COMM_0
	
	// Resume music then fade-in to full volume
	lda.b #$03
	sta.w MSU_AUDIO_CONTROL
	lda.b #FADE_STATE_FADEIN
	sta.w fadeState
	lda.b #$00
	sta.w fadeVolume
	bra .CleanupAndReturn

.StopMusic:
	sta.w SPC_COMM_0

	lda.w MSU_STATUS
	and.b #MSU_STATUS_AUDIO_PLAYING
	beq .CleanupAndReturn

	// Fade-out current music then stop it
	lda.b #FADE_STATE_FADEOUT
	sta.w fadeState
	lda.b #FULL_VOLUME
	sta.w fadeVolume
	bra .CleanupAndReturn

.RaiseVolume:
	sta.w SPC_COMM_0
	lda.b #FULL_VOLUME
	sta.w MSU_AUDIO_VOLUME
	bra .CleanupAndReturn
	
.DropVolume:
	sta.w SPC_COMM_0
	lda.b #DUCKED_VOLUME
	sta.w MSU_AUDIO_VOLUME
	bra .CleanupAndReturn
	
MSUNotFound:
	pla
.PlaySound:
	sta.w SPC_COMM_0
.CleanupAndReturn:
	inx
	plp
	rtl
}
