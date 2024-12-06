// Set to your desired tempo
~bpm = 130;
TempoClock.default.tempo = ~bpm / 60;  // Sync TempoClock to the BPM

// Group of all synthDefs
(
    // Global reverb applied to all synths
    SynthDef(\globalReverb, {
        var sound, reverb;
        sound = In.ar(0, 2);  // Input from all instruments
        reverb = JPverb.ar(sound, 0.5, 0.2, 0.3);
        Out.ar(0, reverb);
    }).add;

    // Kick
    SynthDef(\kickDrum, {
        arg freq, amp, dur;
        var sound;
        sound = SinOsc.ar(freq, 0, amp);
        sound = sound * EnvGen.kr(Env.perc(0.01, 0.1), doneAction: 2);
        Out.ar(0, Pan2.ar(sound, 0)); // Panned center
    }).add;

    // HiHat
    SynthDef(\hiHat, {
        arg freq, amp, dur;
        var sound;
        sound = WhiteNoise.ar(amp);
        sound = LPF.ar(sound, freq);
        sound = sound * EnvGen.kr(Env.perc(0.01, 0.03), doneAction: 2);
        Out.ar(0, Pan2.ar(sound, 0)); // Panned center
    }).add;

    // Saw pad with subtle reverb
    SynthDef(\modulatedPad, {
        arg freq, amp, dur;
        var sound, modulatedPan, filterEnv, reverb;
        sound = Saw.ar(freq, amp);
        sound = LPF.ar(sound, 300);
        filterEnv = EnvGen.kr(Env.perc(0.5, 3.0), doneAction: 2);
        sound = sound * filterEnv;
        modulatedPan = SinOsc.kr(0.1).range(-1, 1); // Slow modulated pan
        reverb = JPverb.ar(sound, 0.1, 0.6, 0.8);
        Out.ar(0, Pan2.ar(reverb, modulatedPan));
    }).add;

    // Bassline
    SynthDef(\BassLine, {
        arg freq, amp, dur;
        var sound, filteredSound;
        sound = Pulse.ar(freq, 0.5, amp);
        filteredSound = LPF.ar(sound, 80);
        filteredSound = filteredSound * EnvGen.kr(Env.perc(0.1, 0.2), doneAction: 2);
        Out.ar(0, Pan2.ar(filteredSound, 0));
    }).add;

    // Arp melody
    SynthDef(\arpMelody, {
        arg freq, amp, dur;
        var sound;
        sound = SinOsc.ar(freq, 0, amp);
        sound = sound * EnvGen.kr(Env.perc(0.1, 0.2), doneAction: 2);
        Out.ar(0, Pan2.ar(sound, 0));
    }).add;

    // Background noise textur
    SynthDef(\backgroundNoise, {
        var sound, filteredNoise, modulatedFilter, panMod;
        sound = WhiteNoise.ar(0.005);
        modulatedFilter = SinOsc.kr(0.1).range(400, 2000); // Sine wave modulating the filter frequency
        filteredNoise = LPF.ar(sound, modulatedFilter);
        panMod = SinOsc.kr(0.01).range(-1, 1); // Slowly panning from left to right
        Out.ar(0, Pan2.ar(filteredNoise * 0.2, panMod));
    }).add;
)


// Group of all patterns
(
    // Global pattern definitions (synchronized with TempoClock)

    // Kick
    ~kickPattern = Pbindef(\kickPattern,
        \instrument, \kickDrum,
        \freq, 50,
        \dur, 1,
        \amp, 1.25,
        \clock, TempoClock.default
    );

    // HiHat
    ~hihatPattern = Pbindef(\hihatPattern,
        \instrument, \hiHat,
        \freq, Pseq([2000, 2400, 2800, 3200, 3600, 2400, 2000, 1000], inf),
        \dur, Pwrand([0.25, 0.25, 0.5], [0.5, 0.5, 0.25], inf),
        \amp, 0.05,
        \clock, TempoClock.default
    );

    // Pad
    ~padPattern = Pbindef(\padPattern,
        \instrument, \modulatedPad,
        \freq, Pseq([220, 250, 300, 220], inf),
        \dur, 4,
        \amp, 0.1,
        \clock, TempoClock.default
    );

    // Bass
    ~bassPattern = Pbindef(\bassPattern,
        \instrument, \BassLine,
        \freq, Pseq([110, 125, 100, 220, 180, 150, 200], inf),
        \dur, Pseq([0.5, 0.25, 0.75, 0.5, 0.25, 0.5], inf),
        \amp, 0.5,
        \clock, TempoClock.default
    );

    // Arp
    ~arpPattern = Pbindef(\arpPattern,
        \instrument, \arpMelody,
        \freq, Pseq([220, 250, 300, 220], inf),
        \dur, Pseq([1, 1.5, 1, 0.5, 1, 1, 2, 0], inf),
        \amp, 0.12,
        \clock, TempoClock.default
    );

    // Background noise
    ~backgroundNoisePattern = Pbindef(\backgroundNoisePattern,
        \instrument, \backgroundNoise,
        \clock, TempoClock.default
    );
)

~globalEffect = Synth(\globalReverb);  // Apply global reverb before play

// Play instruments here
~backgroundNoisePattern.play;
~kickPattern.play;
~hihatPattern.play;
~padPattern.play;
~bassPattern.play;
~arpPattern.play;


// Stop instruments here
~backgroundNoisePattern.stop;
~kickPattern.stop;
~hihatPattern.stop;
~padPattern.stop;
~bassPattern.stop;
~arpPattern.stop;
