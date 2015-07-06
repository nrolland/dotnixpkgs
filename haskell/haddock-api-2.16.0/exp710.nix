with (import <nixpkgs> {}).pkgs;
with haskell710Packages;
callPackage ./. {}
