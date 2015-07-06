with (import <nixpkgs> {}).pkgs;
let pkg = haskellngPackages.callPackage
            ({ mkDerivation, array, base, bytestring, Cabal, containers
             , deepseq, directory, filepath, ghc, ghc-paths, haddock-library
             , stdenv, xhtml
             }:
             mkDerivation {
               pname = "haddock-api";
               version = "2.16.0";
               sha256 = "0hk42w6fbr6xp8xcpjv00bhi9r75iig5kp34vxbxdd7k5fqxr1hj";
               buildDepends = [
                 array base bytestring Cabal containers deepseq directory filepath
                 ghc ghc-paths haddock-library xhtml
               ];
               homepage = "http://www.haskell.org/haddock/";
               description = "A documentation-generation tool for Haskell libraries";
               license = stdenv.lib.licenses.bsd3;
             }) {};
in
  pkg.env
