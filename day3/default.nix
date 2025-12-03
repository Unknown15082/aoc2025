{ lib, ... }:
with lib;
with lib.strings;
let
	rawInput = fileContents ./input.txt;

	getElem = idx: lst: builtins.elemAt lst idx;
	power10 = x: if x == 0 then 1 else (power10 (x - 1)) * 10;

	toDigits = digits: let
		digitsList = splitString "" digits;
		len = length digitsList;
		strList = sublist 1 (len - 2) digitsList;
	in map toInt strList;

	parse = input:
		input
		|> splitString "\n"
		|> map toDigits;

	input = parse rawInput;

	op1 = d: state: let
		best = getElem 0 state;
		maxd = getElem 1 state;

		val = if maxd < 0 then 0 else d * 10 + maxd;
		newMaxD = max maxd d;
		newBest = max best val;
	in [ newBest newMaxD ];

	op2 = d: state: let
		applyD = best2: best1: p: if best1 < 0 then -1 else max best2 (d * p + best1);

		applyDL = st: let
			best2 = getElem 0 st;
			best1 = getElem 1 st;
			p = getElem 2 st;
		in applyD best2 best1 p;

		pairedState = let
			lst = zipListsWith (a: b: [ a b ]) ([0] ++ state) (state ++ [0]);
			len = length lst;
		in (sublist 1 (len - 1) lst);

		pList = builtins.genList (x: power10 (11 - x)) 12;

		zipped = zipListsWith (a: b: a ++ [ b ]) pairedState pList;
	in (map applyDL zipped);

	getMax1 = foldr op1 [ 0 (0 - 1) ];
	getMax2 = foldr op2 (builtins.genList (_: -1) 12);

	part1 = input |> map getMax1 |> map (getElem 0) |> foldr builtins.add 0;
	part2 = input |> map getMax2 |> map (getElem 0) |> foldr builtins.add 0;
in {
	inherit part1 part2;
}
