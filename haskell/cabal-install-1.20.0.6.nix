{ mkDerivation, array, base, bytestring, Cabal, containers
, directory, filepath, HTTP, HUnit, mtl, network, network-uri
, pretty, process, QuickCheck, random, stdenv, stm, test-framework
, test-framework-hunit, test-framework-quickcheck2, time, unix
, zlib
}:
mkDerivation {
  pname = "cabal-install";
  version = "1.20.0.6";
  sha256 = "1hc187yzl59518cswk25xzsabn9dvm4wqpq817hmclrvkf4zr3pl";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    array base bytestring Cabal containers directory filepath HTTP mtl
    network network-uri pretty process random stm time unix zlib
  ];
  testDepends = [
    array base bytestring Cabal containers directory filepath HTTP
    HUnit mtl network network-uri pretty process QuickCheck stm
    test-framework test-framework-hunit test-framework-quickcheck2 time
    unix zlib
  ];
  postInstall = ''
    mkdir $out/etc
    mv bash-completion $out/etc/bash_completion.d
  '';
  homepage = "http://www.haskell.org/cabal/";
  description = "The command-line interface for Cabal and Hackage";
  license = stdenv.lib.licenses.bsd3;
}
