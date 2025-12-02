# Advent of Code 2025 in Nix

## Running Instructions

This is an attempt to do AoC 2025 in Nix.

To run a particular day:
```
nix eval .#dayX
```

where `X` is a number from 1 to 12.

If we want to get only a single part:
```
nix eval .#dayX.partY
```

where `Y` is either 1 or 2.

## Input files

As per the request of the Advent of Code developer, the input files are not shared.

Thus, for each puzzle, download your own input file and place it in the corresponding `dayX/input.txt` file.
