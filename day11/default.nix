{ lib, ... }:
with lib;
with lib.strings;
let
	rawInput = fileContents ./input.txt;

	getElem = idx: val: elemAt val idx;

	parseList = rawstr: let
		len = stringLength rawstr;
		str = substring 1 (len - 1) rawstr;
	in splitString " " str;

	parse = input:
		input |> splitString "\n"
			  |> map (splitString ":")
			  |> map (line: {
					source = (elemAt line 0);
					children = parseList (elemAt line 1);
				 });

	input = parse rawInput;

	nodes = [ "out" ] ++ (map (x: x.source) input);
	cnt = length nodes;
	intnodes = range 0 (cnt - 1);

	findIndex = val: lists.findFirstIndex (x: x == val) (0 - 1) nodes;
	idxYou = findIndex "you";

	adj = [ { source = 0; children = []; } ] ++ map (line: let
		source = line.source;
		lst = line.children;
	in { source = findIndex source; children = map findIndex lst; }) input;

	member = val: any (x: x == val);

	before = a: b: (member a (elemAt adj b).children);

	order = (toposort before intnodes).result;
	initDP = genList (_: 0) cnt;

	update = lst: idx: val: genList (i: if i == idx then val else elemAt lst i) cnt;

	sum = foldr add 0;
	f1 = dp: x: map (y: elemAt dp y) ((elemAt adj x).children) |> sum;

	op = src: dp: x: let
		newval = if x == src then 1 else f1 dp x;
	in update dp x newval;

	idxDAC = findIndex "dac";
	idxFFT = findIndex "fft";
	idxSVR = findIndex "svr";

	part1 = elemAt (foldl' (op 0) initDP order) idxYou;
	part2 = let
		p3 = elemAt (foldl' (op 0) initDP order) idxDAC;
		p2 = elemAt (foldl' (op idxDAC) initDP order) idxFFT;
		p1 = elemAt (foldl' (op idxFFT) initDP order) idxSVR;
	in p1 * p2 * p3;
in {
	inherit part1 part2;
	# (svr -> dac) * (dac -> fft) * (fft -> out)
	inherit idxDAC idxFFT idxSVR;
	inherit order adj;
}
