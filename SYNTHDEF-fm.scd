SynthDef(\fm7, {
	arg out=0, amp=0.3, spread=0, freq=440, attack=0.01, decay=0.3, sustain=0.5, release=1, gate=1;
	var sig, env, ctls, mods, chans, envs, freqs, amps;
	// frequencies of oscillators are in partials of main frequency, they
	// multiply the base frequency
	freqs = Array.fill(6, { |i|
		freq * ((\freq++i).asSymbol).kr((i+1)) + 0.1.rand2;
	});

	envs = Array.fill(6, { |i|
		EnvGen.kr(
			Env.adsr(
				((\attack++i).asSymbol).kr(0.01),
				((\decay++i).asSymbol).kr(0.3),
				((\sustain++i).asSymbol).kr(1),
				((\release++i).asSymbol).kr(1)
			),
			gate);//((\gate++i).asSymbol).kr(0));
	});

	// freq, phase (initialization only), amp
	ctls = Array.fill(6, { |i| [freqs[i], 0, envs[i]] });

	// mods modulate ctls phases
	// Access them with x.set(\mod[carrier][modulator], value),
	// For example: x.set(\mod01, 0.5) is modulating first oscilator with the signal from
	// the second oscillator  by an amount of 0.5 radians
	mods = Array.fill2D(6, 6, { |r, c|
		((\mod++r++c).asSymbol).kr(0);
	});

	// use this instead if you prefer using a [6][6] array
	//mods = \mods.kr(0!6!6);

	amps = Array.fill(6, { |i|
		((\amp++i).asSymbol).kr((i.mod(6)==0).asInt);
	});

	env = EnvGen.ar(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);

	sig = Splay.ar(FM7.ar(ctls, mods) * amps * env, spread);
	Out.ar(out, sig * amp);
}).add;
