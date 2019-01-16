// Download OscHook app from the store.
(
~oscPort = 7400; // OscHook default port
// To filter out, simply comment the lines you don't want to recieve
~oscAddresses = [
	// "/accelerometer/raw/x",
	// "/accelerometer/raw/y",
	// "/accelerometer/raw/z",
	// "/accelerometer/linear/x",
	// "/accelerometer/linear/y",
	// "/accelerometer/linear/z",
	// "/accelerometer/gravity/x",
	// "/accelerometer/gravity/y",
	// "/accelerometer/gravity/z",
	// "/rotation_vector/r1",
	// "/rotation_vector/r2",
	// "/rotation_vector/r3",
	// "/rotation_vector/r4",
	// "/orientation/azimuth",
	// "/orientation/pitch",
	// "/orientation/roll",
	"/light",
	// "/gps/longitude",
	// "/gps/latitude",
	// "/gps/speed",
	// "/gps/accuracy",
	// "/proximity",
	// "/wifi/one/rssi",
	// "/wifi/two/rssi",
	// "/wifi/three/rssi",
	// "/wifi/four/rssi",
	// "/oscHook", // combined - gravity, acceleration, GPS speed, accuracy and fix
];

~oscLight = {|value| value  = 1/((value / (15000/4)).ceil); };
~oscLatitude = {|value, min=0.0, max=1.0| value = value.linlin(2.35, 2.37, min, max)};// - 2.356 * 1000;};
~oscLongitude = {|value, min=0.0, max=1.0| value = value.linlin(41.48, 41.50, min, max)};// - 2.356 * 1000;};
~oscAzimuth = {|value, min=0.0, max=1.0| value = value.linlin(-180, 180, min, max)};// - 2.356 * 1000;};
~oscPitch = {|value, min=0.0, max=1.0| value = value.linlin(-90, 90, min, max)};// - 2.356 * 1000;};

// map osc values to a Pbindef parameter
// @param  target              Symbol                                       Pbindef id
// @param  param              Symbol                                      Parameter of the Pbind
// @param  function           [  Function | GlobalVariable ]     Function that maps osc value to Pbind value
// @param  min                  Number                                     Minimum mapped value
// @param  max                 Number                                     Maximum mapped value
// @param  oscaddress       String                                     Maximum mapped value
~setparam = {|oscaddress, target, param, function, min, max|
	[target, param, function, min, max, oscaddress].postln;
	OSCdef(param, {|msg|
		var value = function.value(msg[1], min, max);
		[target, param, value].postln;
		Pbindef(target, param, value);
	}, oscaddress, recvPort:7400);
};


/*~oscAddresses.do {|address|
var symbol;
symbol = address.split.join.asSymbol;
OSCdef(symbol, { |msg, time, addr, recvPort|
var ip = addr.ip;
var oscaddr = msg[0].asString;
var value = msg[1];
~oscMap[oscaddr].value(value);
([ip]++msg).postln;
}, address, recvPort:~oscPort);
};*/

~setparam.value('/gps/latitude', \lead, \mod01, ~oscLatitude, 0.0, 4.0);
~setparam.value('/gps/longitude', \lead, \freq1, ~oscLatitude, 0.25, 4.0);
~setparam.value('/orientation/pitch', \lead, \degree, ~oscPitch, 0, 1);

OSCdef(\mod01, {|msg| 	Pbindef(\lead, \mod01, ~oscLatitude.value(msg[1], 0.0, 4.0).postln);}, '/gps/latitude', recvPort:7400);
OSCdef(\freq1, {|msg| 	Pbindef(\lead, \freq1, ~oscLongitude.value(msg[1], 0.25,4).postln);}, '/gps/longitude', recvPort:7400);
OSCdef(\degree, {|msg| 	Pbindef(\lead, \degree, ~oscPitch.value(msg[1], 7,0).asInt.postln);}, '/orientation/pitch', recvPort:7400);

OSCdef(\degree).clear;
OSCdef(\mod01).clear;
OSCdef(\freq1).clear;

s.meter
s.boot.scope
Pbindef(\lead, \instrument, \fm7, \degree, Prand([0,3], inf), \dur, 1/4).play;
Pbindef(\lead, \freq1, 1);
Pbindef(\lead, \mod01, 0);
Pbindef(\lead).clear
(
OSCdef(\a).clear;
OSCdef(\a, { |msg|
	// var value = 1/((msg[1] / (15000/4)).ceil);
	// value.postln;
	// Pbindef(\lead, \dur, value);
	// ~oscDur.value(msg[1]);
	Pbindef(\lead, \mod01, ~oscLatitude.value(msg[1], 0.0, 4.0).postln);
	Pbindef(\lead, \freq1, ~oscLatitude.value(msg[1], 0,4).postln);
	// msg[1].postln;
}, '/gps/latitude', recvPort:7400)
)

y = [ 1, 2, 3 ];
y.clipAt(0).postln;
y