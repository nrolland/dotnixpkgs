{pkgs}:
rec {
  # ~/.nixpkgs/config.nix lets us override the Nix package set
  # using packageOverrides.
  packageOverrides = super : let self = super.pkgs; in rec {

    myHaskellPackages = hp : hp.override {
      overrides = self: super:  with pkgs.haskell-ng.lib; {
          # Enable profiling. Taken from
          # http://lists.science.uu.nl/pipermail/nix-dev/2015-January/015620.html.
          # Comment out this line if you do not want to enable profiling!
          #mkDerivation = expr: super.mkDerivation (expr // {
          #  enableLibraryProfiling = true; });
          # Private package
          system-fileio   = self.callPackage  ../clones/haskell-filesystem/system-fileio/default.nix {};
          cmdtheline = self.callPackage  ../hask/purescript-nix/cmdtheline.nix {};
          purescript = self.callPackage  ../hask/purescript-nix/purescript.nix {};
          #ghc-events = pkgs.haskell.packages.ghc784.callPackage  ../src/../src/ghc-events-0.4.3.0  {};
          #ghc-events = pkgs.haskell.packages.ghc784.callPackage  ./haskell/ghc-events-0.4.3.0  {};
          lens = dontCheck super.lens;
          #ghc-events = doJailbreak super.ghc-events;
          };
      };

    myHaskellPackages784 = hp : hp.override {
      overrides = self: super:  with pkgs.haskell-ng.lib; {
          ghc-events = dontCheck (pkgs.haskell.packages.ghc784.callPackage  ./haskell/ghc-events-0.4.3.0  {});
          lens =  dontCheck super.lens;
          };
      };
      

    haskellngPackages  = myHaskellPackages super.haskellngPackages;
    haskell784Packages = myHaskellPackages784(myHaskellPackages super.haskell-ng.packages.ghc784);
    haskell763Packages = myHaskellPackages super.haskell-ng.packages.ghc763;

    hs784  = haskell784Packages.ghcWithPackages (p: with p;
             [
                  ghc-mod 
                  hdevtools
                  hlint
                  cabal2nix
                  aeson base bytestring heist lens MonadCatchIO-transformers mtl
                  postgresql-simple snap snap-core snap-loader-static snap-server
                  snaplet-postgresql-simple text time xmlhtml
                  codex
                  hobbes
                  hasktags
                  djinn #mueval
                  #idris
                  stylish-haskell
                  threadscope
                  ghc-events
                  timeplot splot
                  hakyll
            ]
            ++(myPackages p)
         );
    hs7101 = haskellngPackages.ghcWithPackages (p: with p;
              [
                  #ghc-mod
                  hdevtools
                  hlint
                  cabal2nix
                  aeson base bytestring heist lens MonadCatchIO-transformers mtl
                  postgresql-simple snap snap-core snap-loader-static snap-server
                  snaplet-postgresql-simple text time xmlhtml
                  codex
                  hobbes
                  hasktags
                  #djinn mueval
                  #idris
                  #stylish-haskell
                  #threadscope
                  #ghc-events
                  #timeplot #splot
                  hakyll
            ] 
            ++( myPackages7101  p) 
         );

    hsEnvHoogle = withHoogle hs784;
    hsEmpty = pkgs.haskell-ng.packages.ghc784.ghcWithPackages (p: with p; []);

    devWeb = let haskellngPackages = pkgs.haskellngPackages.override {
              extension = self: super: {
               cmdtheline = self.callPackage ../hask/purescript-nix/cmdtheline.nix {};
               purescript = self.callPackage  ../hask/purescript-nix/purescript.nix {};
              };
              };
             in
             #a voir.. comment juste installer les binaires dans l'environnement global ?
             #self.stdenv.mkDerivation {
             pkgs.myEnvFun {
               name = "devWeb";
               buildInputs = with pkgs; [
                              flow
                              nix-repl
                              haskellngPackages.purescript
                              nodePackages.bower
                              nodePackages.grunt-cli
                              git
                            ];
       };
       
    agdaEnv = pkgs.myEnvFun {
            name =  "agda";
            buildInputs = [
            pkgs.haskellngPackages.Agda
            pkgs.AgdaStdlib
            #haskellPackages.AgdaPrelude
            ];
    };
    #installing this builds the docs for the installed packages
    withHoogle = haskellEnv: with pkgs.haskellngPackages;
     import <nixpkgs/pkgs/development/libraries/haskell/hoogle/local.nix> {
      stdenv = pkgs.stdenv;
      inherit hoogle rehoo;
      ghc = pkgs.haskell-ng.compiler.ghc;
      packages = haskellEnv.paths;
      };
    #does not work openblas-0.2.14 : unsupported system: x86_64-darwin
    myPythonEnv = pkgs.myEnvFun {
        name = "myPythonEnv";
        buildInputs = [
          pkgs.python27
          pkgs.python27Packages.scikitlearn
        ];
      };
  };#end packageOverrides


  myPackages7101 = p: with p; [
     #classy-prelude-yesod
  #stm
  #wai-loggerm
  #yesod
  #yesod-auth
  #yesod-bin
  #yesod-core
  #yesod-for
  #yesod-static
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
  cassava
  classy-prelude
  classy-prelude-conduit
  clay 
  clay 
  conduit
  containers
  data-default
  derive
  directory
  distributive
  dlist
  dns
  doctest
  either
  errors
  exceptions
  failure
  fast-logger
  feed
  file-embed
  #ghcjs-dom
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
  iso8601-time
  lens
  lens
  list-tries
  lucid
  mmorph
  monad-control
  monad-logger
  mtl
  mvc
  pandoc
  parallel
  parsec
  persistent
  persistent-postgresql
  persistent-template
  pipes
  pipes-concurrency
  pointed
  profunctors
  random
  reducers
  reflection
  #reflex
  #reflex-dom
  #reflex-todomvc
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
  text         
  text           
  time
  #timeparsers
  transformers
  unordered-containers
  vector
  void
  wai
  wai-extra
  warp
  xhtml
  yaml
  zippers
  zlib

  ];
  
  myPackages = p: with p; [
    #classy-prelude-yesod
  stm
  #wai-loggerm
  yesod
  yesod-auth
  yesod-bin
  yesod-core
  #yesod-for
  yesod-static
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
  cassava
  classy-prelude
  classy-prelude-conduit
  clay 
  clay 
  conduit
  containers
  data-default
  derive
  directory
  distributive
  dlist
  dns
  doctest
  either
  errors
  exceptions
  failure
  fast-logger
  feed
  file-embed
  #ghcjs-dom
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
  iso8601-time
  lens
  lens
  list-tries
  lucid
  mmorph
  monad-control
  monad-logger
  mtl
  mvc
  pandoc
  parallel
  parsec
  persistent
  persistent-postgresql
  persistent-template
  pipes
  pipes-concurrency
  pointed
  profunctors
  random
  reducers
  reflection
  #reflex
  #reflex-dom
  #reflex-todomvc
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
  text         
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
  zippers
  zlib
# z3
#cabal-install
  ];

  allowBroken = true;
  allowUnfree = true;

}