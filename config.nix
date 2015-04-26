rec {
  # ~/.nixpkgs/config.nix lets us override the Nix package set
  # using packageOverrides.
  packageOverrides = pkgs : let self = pkgs.pkgs; in rec {
    haskellngPackages = pkgs.haskellngPackages.override {
      overrides = self: super: {
        # Enable profiling. Taken from
        # http://lists.science.uu.nl/pipermail/nix-dev/2015-January/015620.html.
        # Comment out this line if you do not want to enable profiling!
        #mkDerivation = expr: super.mkDerivation (expr // {
        #  enableLibraryProfiling = true; });
        # Private package
          system-fileio = self.callPackage ../clones/haskell-filesystem/system-fileio/default.nix {};
          };
    };
    
    #defines a new attribute called hsEnv that you can subsequently
    #install into an environment by saying
    # $ nix-env -iA nixpkgs.hsEnv  #nixpkgs se refere a une expression ou un repertoire
    #hsEnv = pkgs.haskellPackages_ghc784.ghcWithPackages (p: with p;
    hsEnv = pkgs.haskell-ng.packages.ghc784.ghcWithPackages (p: with p;
            (haskellDev p) 
            ++(myPackages p) 
            # add more packages here
            );

     
            
    hsEnvHoogle = withHoogle hsEnv;
    agdaEnv = pkgs.myEnvFun {
            name =  "agda";
            buildInputs = [
            pkgs.haskellPackages.Agda
            pkgs.AgdaStdlib
            #haskellPackages.AgdaPrelude
            ];
    };

    hsEmpty = pkgs.haskell-ng.packages.ghc784.ghcWithPackages (p: with p; []);

    
    withHoogle = haskellEnv: with pkgs.haskellngPackages;
     import <nixpkgs/pkgs/development/libraries/haskell/hoogle/local.nix> {
      stdenv = pkgs.stdenv;
      inherit hoogle rehoo;
      ghc = pkgs.haskell-ng.compiler.ghc;
      packages = haskellEnv.paths;
    };

    myPythonEnv = pkgs.myEnvFun {
        name = "mypython";
        buildInputs = [
          pkgs.python27
          pkgs.python27Packages.scikitlearn
        ];
    };

  };



  allowBroken = true;
  allowUnfree = true;

  
  haskellDev = p: with p; [
     ghc
     ghc-mod
     hdevtools
     hlint
     ihaskell
     #cabal2nix
     aeson base bytestring heist lens MonadCatchIO-transformers mtl
     postgresql-simple snap snap-core snap-loader-static snap-server
     snaplet-postgresql-simple text time xmlhtml
     codex
     hobbes
     hasktags
     djinn mueval
     #idris
     stylish-haskell
     threadscope
     timeplot splot
     hakyll
      ];
      
  myPackages = p: with p; [
  # z3
  HUnit
  IfElse
  MemoTrie
  MissingH
  QuickCheck
  accelerate
  adjunctions
  aeson
  async
  attempt
  attoparsec
  bifunctors
  bytestring
  #cabal-install
  cassava
  classy-prelude
  classy-prelude-conduit
  #classy-prelude-yesod
  conduit
  containers
  data-default
  #stm
  #wai-loggerm
  derive
  directory
  distributive
  dlist
  dns
  doctest
  either
  exceptions
  failure
  fast-logger
  file-embed
  hamlet
  hashable
  hashtables
  haskeline
  hfsevents
  hjsmin
  hoopl
  hslogger
  hspec
  html
  http-conduit
  list-tries
  mmorph
  monad-control
  monad-logger
  pandoc
  parallel
  parsec
  persistent
  persistent-postgresql
  persistent-template
  pipes
  pointed
  profunctors
  random
  reducers
  reflection
  resourcet
  retry
  rex
  safe
  sbv
  scotty
  semigroupoids
  semigroups
  shake
  shakespeare
  shelly
  speculation
  split
  spoon
  strict
  strptime
  syb
  system-fileio
  tagged
  tar
  tasty
  template-haskell
  text
  time
  timeparsers
  transformers
  unordered-containers
  vector
  void
  wai
  wai-extra
  warp
  xhtml
  yaml
  #yesod
  #yesod-auth
  #yesod-bin
  #yesod-core
  #yesod-for
  #yesod-static
  zippers
  zlib];

}