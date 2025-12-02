{ lib, ... }:
with lib;
let
	rawInput = fileContents ./input.txt;

	modulo = a: b: a - (b * (a / b));
	getElem = idx: lst: builtins.elemAt lst idx;

	parseLine = line: let
		s = lib.strings.split "([LR])([[:digit:]]+)" line |> getElem 1;
	in [ (getElem 0 s) (getElem 1 s |> strings.toInt) ];

	parse = input:
		input
		|> splitString "\n"
		|> map parseLine;

	input = parse rawInput;

	getNewPos = pos: movement: let
		rawPos = modulo (pos + movement) 100;
		newPos = if rawPos < 0 then rawPos + 100 else rawPos;
	in newPos;

	calcPass = pos: dir: x: let
		pos' = if pos == 0 then 100 else pos;
		caseL = if x < pos' then 0 else (x - pos') / 100 + 1;
		caseR = if x < 100 - pos then 0 else (x - 100 + pos) / 100 + 1;
		cnt = if dir == -1 then caseL else caseR;
	in cnt;

	rotateOp = state: rotation: let
		pos = getElem 0 state;
		cnt = getElem 1 state;
		dir = if ((getElem 0 rotation) == "L") then -1 else 1;
		movementX = getElem 1 rotation;
		movement = dir * movementX;

		newPos = getNewPos pos movement;
		extraCnt = if newPos == 0 then 1 else 0;

		newCnt = cnt + extraCnt;
	in [ newPos newCnt ];

	rotateOp2 = state: rotation: let
		pos = getElem 0 state;
		cnt = getElem 1 state;
		dir = if ((getElem 0 rotation) == "L") then -1 else 1;
		movementX = getElem 1 rotation;
		movement = dir * movementX;

		newPos = getNewPos pos movement;
		extraCnt = calcPass pos dir movementX;

		newCnt = cnt + extraCnt;
	in [ newPos newCnt ];

	part1 = foldl' rotateOp [ 50 0 ] input |> getElem 1;
	part2 = foldl' rotateOp2 [ 50 0 ] input |> getElem 1;
in {
	inherit part1 part2;
}
