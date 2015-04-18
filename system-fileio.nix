{ mkDerivation, base, bytestring, chell, stdenv, system-filepath
, temporary, text, time, transformers, unix
}:
mkDerivation {
  pname = "system-fileio";
  version = "0.3.16.2";
  sha256 = "17mk1crlgrh9c9lfng6a2fdk49m2mbkkdlq5iysl1rzwkn12mmkd";
  buildDepends = [ base bytestring system-filepath text time unix ];
  testDepends = [
    base bytestring chell system-filepath temporary text time
    transformers unix
  ];
  homepage = "https://github.com/fpco/haskell-filesystem";
  description = "Consistent filesystem interaction across GHC versions";
  license = stdenv.lib.licenses.mit;
}
