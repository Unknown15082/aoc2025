{ lib, ... }:
with lib;
with lib.strings;
let
	rawInput = fileContents ./input.txt;

	getElem = idx: lst: builtins.elemAt lst idx;
	modulo = a: b: a - (b * (a / b));

	getDigitCount = num: num |> toString |> stringLength;
	checkBetween = l: r: x: (l <= x) && (x <= r);

	power10 = x: if x == 0 then 1 else (power10 (x - 1)) * 10;
	full9 = x: (power10 x) - 1;

	parse = input:
		input
		|> splitString ","
		|> map (range: range |> splitString "-" |> map toInt);

	input = parse rawInput;

	# We can make some assumptions about the inputs here:
	# - The number of digits of the endpoints differ by at most 1.
	# - The number of digits is not that large, at most 10.

	# splitNums assumes x can be divided into k parts
	splitNums = x: k: let
		str = toString x;
		d = getDigitCount x;
		startIdxs = builtins.genList (y: y * d / k) k;
		parts = map (l: substring l (d / k) str |> toIntBase10) startIdxs;
	in parts;

	getMult = d: k: if (k == 0) then 1 else 1 + (getMult d (k - 1)) * (power10 d);

	duplicate = x: k: let
		d = getDigitCount x;
	in x * (getMult d (k - 1));

	calcRangeK = l: r: d: k: let
		ls = splitNums l k;
		rs = splitNums r k;

		l1 = getElem 0 ls;
		r1 = getElem 0 rs;

		dupl = duplicate l1 k;
		dupr = duplicate r1 k;

		ans = (if l1 + 1 <= r1 - 1
				then (l1 + r1) * (r1 - l1 - 1) / 2 * (getMult (d / k) (k - 1))
				else 0)
			+ (if l1 == r1
				then (if checkBetween l r dupl then dupl else 0)
				else (if dupl >= l then dupl else 0)
					+ (if dupr <= r then dupr else 0));
	in ans;

	calcRangeD = l: r: d: let
		ans = (if (modulo d 2) != 0 then 0 else calcRangeK l r d 2)
			+ (if (modulo d 3) != 0 then 0 else calcRangeK l r d 3)
			+ (if (modulo d 5) != 0 then 0 else calcRangeK l r d 5)
			- (if (modulo d 6) != 0 then 0 else calcRangeK l r d 6)
			+ (if (modulo d 7) != 0 then 0 else calcRangeK l r d 7)
			- (if (modulo d 10) != 0 then 0 else calcRangeK l r d 10);
	in ans;

	calcRange1 = l: r: let
		dl = getDigitCount l;
		dr = getDigitCount r;
		ans = if dl != dr
			then (if (modulo dl 2) == 0 then calcRangeK l (full9 dl) dl 2 else 0)
				+ (if (modulo dr 2) == 0 then calcRangeK (power10 (dr - 1)) r dr 2 else 0)
			else (if (modulo dl 2) == 0 then calcRangeK l r dl 2 else 0);
	in ans;

	calcRange2 = l: r: let
		dl = getDigitCount l;
		dr = getDigitCount r;
		ans = if dl != dr
			then (calcRangeD l (full9 dl) dl)
				+ (calcRangeD (power10 (dr - 1)) r dr)
			else calcRangeD l r dl;
	in ans;

	cnts = f: let
		calc = range: f (getElem 0 range) (getElem 1 range);
	in map calc input;

	part1 = foldr builtins.add 0 (cnts calcRange1);
	part2 = foldr builtins.add 0 (cnts calcRange2);
in {
	inherit part1 part2;
}
