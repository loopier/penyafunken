( // remove main parenthesis for autoboot
~play = {
	Pbindef(\lead, \instrument, \fm7, \octave, 5).play.quant_(1);
	Pbindef(\bass, \instrument, \fm7, \octave, 3).play.quant_(1);
};

~stop = {
	Pbindef(\lead).stop;
	Pbindef(\bass).stop;
};

~scales = [
	Scale.major,
	Scale.harmonicMinor,
	Scale.mixolydian,
	Scale.jiao,
];

~scale = nil;
~setscale = { |scaleindex|
	scaleindex.postln;
	~scale = ~scales.wrapAt(scaleindex);
};

~melody = nil;
~getrandommelody  = { |size| Array.fill( size, {~scale.degrees.choose}) ++ [\rest] };
~setmelody = { |target, notes|
	~melody = notes;
	Pbindef(target.asSymbol, \degree, Pseq(notes, inf));
};
~newrandommelody = { |target, size=7| ~setmelody.value(target, ~getrandommelody.value(size))};


~rhythm = nil;
~getrandomrhythm  = { |size| Array.fill( size, {(1/[1,2,4]).choose}) };
~setrhythm = { |target, values|
	~rhythm = values;
	Pbindef(target.asSymbol, \dur, Pseq(values, inf));
};
~newrandomrhythm = { |target, size=7| ~setmelody.value(target, ~getrandommelody.value(size))};
~setrate = { |target, rate| ~setrhythm.value(target, ~rhythm * rate) };

~newrandom = { |size=7|
	~melody = ~getrandommelody.value(size);
	~setmelody.value(\lead, ~melody);
	~setmelody.value(\bass, ~melody);

	~rhythm = ~getrandomrhythm.value(~melody.size);
	~setrhythm.value(\lead, ~rhythm);
	~setrhythm.value(\bass, ~rhythm);
};

~postinfo = {
	("scale: "++~scale.name).postln;
	"melody: ".post;~melody.postln;
	"rhythm: ".post;~rhythm.postln;
};

~boot = {"Boot.scd".loadRelative};
)

~boot.value;

~setscale.value(1);

~play.value;
~stop.value;

~melody = ~getrandommelody.value(7);
~setmelody.value(\lead, ~melody);
~setmelody.value(\bass, ~melody);

~rhythm = ~getrandomrhythm.value(~melody.size);
~setrhythm.value(\lead, ~rhythm);
~setrhythm.value(\bass, ~rhythm);
~setrate.value(\lead, 1/4)
~setrate.value(\bass, 1/2)

~newrandom.value

~postinfo.value;

~boot.value;