
##Livecoding patch in SC

by David Gao

Introduction

This patch is a minimalist toolkit for creating and performing dance music in SuperCollider.

####How to use:
1. Set tempo (line 2)
You can set the BPM by modifying the ~bpm variable at the top of the patch:

	~bpm = 120;  // Set your desired BPM
	
2. Boot server and load synthdefs, make sure to evaluate the entire synthdef group block:

	line 6	(
		    // SynthDefs
	line 75	)
		
3. Start patterns for each instrument altogether, similar to the above step:

	line 79 (
		    // Patterns
	line 132	)


4. Apply global reverb (line 134):
	~globalEffect = Synth(\globalReverb);  // Apply global reverb before play

5. Play and stop instruments as desired (line 136 - 151)

p.s.: Feel free to tweak the frequency, amplitude, duration, and other parameters of each pattern in real-time by modifying their respective values.

Happy SuperColliding!🎵






