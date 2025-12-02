{
	description = "Advent of Code 2025 using Nix";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	};

	outputs = { nixpkgs, ... }: let
		inherit (nixpkgs) lib;

		days = lib.filterAttrs (name: _: lib.hasPrefix "day" name) (
			builtins.readDir ./.
		);
	in (
		lib.mapAttrs (name: _: import ./${name} { inherit lib; }) days
	);
}
