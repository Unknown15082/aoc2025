# Advent of Code 2025 in Nix

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
