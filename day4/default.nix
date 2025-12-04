{ lib, ... }:
with lib;
with lib.strings;
let
	rawInput = fileContents ./input.txt;

	parse = input: input
		|> splitString "\n"
		|> map (line: line
			|> splitStringBy (x: _: x != "") true
			|> map (x: if x == "@" then 1 else 0));

	input = parse rawInput;

	n = length input;
	m = length (elemAt input 0);

	valid = pos: let
		x = elemAt pos 0;
		y = elemAt pos 1;
	in (x >= 0) && (x < n) && (y >= 0) && (y < m);

	elemAt2D = lst: x: y: elemAt (elemAt lst x) y;
	get' = lst: pos: elemAt2D lst (elemAt pos 0) (elemAt pos 1);
	get = get' input;

	id = x: x;

	makePairs' = l1: l2: map (x: map (y: [ x y ]) l2) l1;
	makePairs = l1: l2: makePairs' l1 l2 |> concatMap id;

	idxs = makePairs (genList id n) (genList id m);
	dirs = makePairs [ (0 - 1) 0 1 ] [ (0 - 1) 0 1 ] |> remove [ 0 0 ];

	boardIdxs = makePairs' (genList id n) (genList id m);

	addIndex = pos1: pos2: let
		x1 = elemAt pos1 0;
		y1 = elemAt pos1 1;
		x2 = elemAt pos2 0;
		y2 = elemAt pos2 1;
	in [ (x1 + x2) (y1 + y2) ];

	check1 = pos: let
		adj = map (addIndex pos) dirs;
		cnt = map (p: if valid p then get p else 0) adj |> foldr add 0;
		val = get pos;
	in (cnt < 4) && (val > 0);

	check2 = lst: pos: let
		adj = map (addIndex pos) dirs;
		cnt = map (p: if valid p then get' lst p else 0) adj |> foldr add 0;
		val = get' lst pos;
	in (cnt < 4) && (val > 0);

	getTotal = lst: map (get' lst) idxs |> foldl' add 0;

	pass = lst: accessible: let
		f = val: pos:
			if ((val > 0) && (get' accessible pos == false)) then 1 else 0;
	in zipListsWith (a: b: zipListsWith f a b) lst boardIdxs;

	run2 = lst: let
		crrcnt = getTotal lst;
		accessible = map (map (check2 lst)) boardIdxs;
		newlst = pass lst accessible;
		newcnt = getTotal newlst;
	in (if newcnt == crrcnt then newlst else run2 newlst);

	part1 = map check1 idxs |> map (x: if x then 1 else 0) |> foldl' add 0;
	part2 = (getTotal input) - (getTotal (run2 input));
in {
	inherit part1 part2;
}
