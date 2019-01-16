s.quit;
s.waitForBoot {
	"SYNTHDEF-fm.scd".loadRelative;

	s.sync;

	~scale = ~scales.choose;

	~play.value;
	~melody = ~newrandommelody.value(8);
	~setmelody.value(\lead, ~melody);
	~setmelody.value(\bass, ~melody);

	~rhythm = ~newrandomrhythm.value(~melody.size);
	~setrhythm.value(\lead, ~rhythm);
	~setrhythm.value(\bass, ~rhythm);
	~setrate.value(\lead, 4);
	~setrate.value(\bass, 1);

	~postinfo.value;

	s.meter;
	s.scope.window.bounds_(Rect( 0, 1024, 200, 300));
};