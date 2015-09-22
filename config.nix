{pkgs}:
rec {
  # ~/.nixpkgs/config.nix lets us override the Nix package set
  # using packageOverrides.
  packageOverrides = super : let self = super.pkgs; in rec {
    myEnv = pkgs.stdenv.mkDerivation {
    name = "myEnv";
    buildInputs = [
      cabal-install."1_20_0_6"
      pkgs.haskellPackages.cabal2nix
      pkgs.wxGTK30
    ];
    };
  
    #to override packages for every ghc version
    myHaskellPackages = hp : hp.override {
      overrides = self: super:  with pkgs.haskell-ng.lib; {
          # Enable profiling. Taken from
          # http://lists.science.uu.nl/pipermail/nix-dev/2015-January/015620.html.
          # Comment out this line if you do not want to enable profiling!
          #mkDerivation = expr: super.mkDerivation (expr // {
          #  enableLibraryProfiling = true; });
          # Private package
          #system-fileio   = self.callPackage  ../clones/haskell-filesystem/system-fileio/default.nix {};
          cmdtheline = self.callPackage  ../hask/purescript-nix/cmdtheline.nix {};
          purescript = self.callPackage  ../hask/purescript-nix/purescript.nix {};
          #ghc-events = pkgs.haskell.packages.ghc784.callPackage  ../src/../src/ghc-events-0.4.3.0  {};
          #ghc-events = pkgs.haskell.packages.ghc784.callPackage  ./haskell/ghc-events-0.4.3.0  {};
          lens = dontCheck super.lens;
          mockery = dontCheck super.mockery;
          http-reverse-proxy = dontCheck super.http-reverse-proxy;
          goa = dontHaddock super.goa;
          #authenticate = dontCheck authenticate;


          #useless in the end, pb was not here
          #ghc-events = doJailbreak super.ghc-events;

          #why this alone does not work for removing check ? 
          snap-extras  = dontCheck super.snap-extras;

          ghc-mod = dontCheck (self.callPackage ./haskell/ghc-mod-5.3.0.0 {});
          cabal-helper = self.callPackage ./haskell/cabal-helper-0.5.1.0 {};
          };
      };

    #to override packages only for 784
    myHaskellPackages784 = hp : hp.override {
      overrides = self: super:  with pkgs.haskell-ng.lib; {
          # to retrieve the nix expression:
          # cd haskell && cabal get ghc-events-0.4.3.0 && cd ghc-events-0.4.3.0
          # && cabal2nix --no-check ghc-events.cabal >default.nix
          # dontCheck can be specified here instead, cf combinators available
          ghc-events = dontCheck (pkgs.haskell.packages.ghc784.callPackage  ./haskell/ghc-events-0.4.3.0  {});
          #gloss      = dontCheck (pkgs.haskell.packages.ghc784.callPackage  ./haskell/gloss-1.8.2.1  {});
          #GLUT       = dontCheck (pkgs.haskell.packages.ghc784.callPackage  ./haskell/GLUT-2.5.1.1  {});
          #bmp       = dontCheck (pkgs.haskell.packages.ghc784.callPackage  ./haskell/bmp-1.2.5.2  {});
          #OpenGL       = dontCheck (pkgs.haskell.packages.ghc784.callPackage  ./haskell/OpenGL-2.9.2.0  {});
          lens =  dontCheck super.lens;
          mockery = dontCheck super.mockery;
          http-reverse-proxy = dontCheck super.http-reverse-proxy;
          goa = dontHaddock super.goa;
          #authenticate = dontCheck authenticate;

          #I have to override it here..
          snap-extras  = dontCheck super.snap-extras;
          };
      };
      
    myHaskellPackages764 = myHaskellPackages784;

    cabal-install = {
      "1_20_0_6"  = self.callPackage (import cabal/1.20.0.6.nix) { ghc = hs784; };
      "1_22_4_0"  = self.callPackage (import cabal/1.22.4.0.nix)  {ghc = hs7101;};
    };

    # that can work, but I need to parameterize unsing string interpolation, cf below
    haskell710Packages =                      myHaskellPackages super.haskell.packages.ghc7102;
    haskell784Packages = myHaskellPackages784(myHaskellPackages super.haskell.packages.ghc784 );
    # haskell763Packages =                      myHaskellPackages super.haskell.packages.ghc763 ;

    # I create another set instead with . so that I can call something.${argcompiler}.somethingelse
    # as interpolation has to happen after a dot
    myhaskell = { packages = {
                     ghc763  = myHaskellPackages764(myHaskellPackages super.haskell.packages.ghc763 );
                     ghc784  = myHaskellPackages784(myHaskellPackages super.haskell.packages.ghc784 );
                     ghc7101 =                      myHaskellPackages super.haskell.packages.ghc7102;
                  };  }; 

   stackLTS35 = super.haskell.packages.lts-3_5.ghcWithPackages(p: with p; [ghc-mod ]);
                  
   # wihtout interpolation it would be 
   # hs784  = haskell784Packages.ghcWithPackages (p: with p;
   # i use instead
   # this is an environment containing ghc784 and the corresponding packages
   hs784  = myhaskell.packages.ghc784.ghcWithPackages (p: with p;
             [
             process
            ]
            ++(myPackages784 p)
         );
   hs763  = myhaskell.packages.ghc763.ghcWithPackages (p: with p;
             [
                  ghc-mod
                  #agda
                  #hdevtools
                  category-extras
                  hlint
                  #cabal2nix
                  flow
                  #GLUT
                  #OpenGL
                  blaze-svg
                  aeson base bytestring heist lens MonadCatchIO-transformers mtl
                  postgresql-simple snap snap-core snap-loader-static snap-server snap-extras
                  snaplet-postgresql-simple text time xmlhtml
                  codex
                  random
                                    OpenGL
                  gloss
                  directory
                  hobbes
                  hasktags
                  djinn #mueval
                  #idris
                  stylish-haskell
                  sqlite-simple
                  #haddock-api
                  threadscope
                  ghc-events
                  timeplot splot
                  hakyll
                  QuickCheck 
            ]
            ++(myPackages784 p)
         );
         
    #hs7101 = haskell710Packages.ghcWithPackages (p: with p;
    hs71012 =  myhaskell.packages.ghc7101.ghcWithPackages (p: with p;
                 [
                 haddock-api
                 #aeson
                 ]
                );
    hs7101 = myhaskell.packages.ghc7101.ghcWithPackages (p: with p;
              [
                  #ghc-mod
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

    #this installs documentation
    hsHoogle784 = withHoogle hs784;
    
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
            pkgs.haskell.packages.ghc784.Agda
            #pkgs.AgdaStdlib
            #haskellPackages.AgdaPrelude
            ];
    };
    #installing this builds the docs for the installed packages
    withHoogle = haskellEnv: with pkgs.haskellngPackages;
     import <nixpkgs/pkgs/development/libraries/haskell/hoogle/local.nix> {
      stdenv = pkgs.stdenv;
      inherit hoogle rehoo;
      ghc = pkgs.haskell.compiler.ghc784;
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
    #cabal2nix
  #category-extras
  #ghcjs-dom
  #reflex
  #reflex-dom
  #reflex-todomvc
  #stm
  #timeparsers
  #wai-loggerm
  #yesod
  #yesod-auth
  #yesod-bin
  #yesod-core
  #yesod-for
  #yesod-static
  GLFW-b
  HUnit
  IfElse
  MemoTrie
  MissingH
  MonadCatchIO-transformers
  QuickCheck 
  accelerate
  adjunctions
  aeson
  aeson
  async
  attempt
  atto-lisp
  attoparsec
  attoparsec-conduit
  base
  bifunctors
  binary-conduit
  blaze-svg
  bytestring
  bytestring
  cassava
  charset
  classy-prelude
  classy-prelude-conduit
  clay 
  clay 
  codex
  conduit
  conduit-combinators
  containers
  data-default
  derive
  directory
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
  flow
  #ghc-mod
  gloss
  gloss-algorithms
  gloss-raster
  goa
  haddock-api
  haddock-library
  hamlet
  hashable
  hashtables
  haskeline
  hasktags
  hdevtools
  heist
  hi
  hfsevents
  hjsmin
  hlint
  hobbes
  hoopl
  hslogger
  hspec
  html
  http-conduit
  iso8601-time
  lambdabot
  lens
  lens
  lens
  lens-aeson
  list-tries
  lucid
  mmorph
  monad-control
  monad-logger
  mtl
  mtl
  mvc
  network-conduit
  pandoc
  parallel
  parsec
  persistent
  persistent-postgresql
  persistent-template
  pipes
  pipes-concurrency
  pointed
  postgresql-simple
  profunctors
  random
  random
  reducers
  reflection
  repa
  repa-algorithms
  repa-io 
  resourcet
  retry
  rex
  safe
  sbv
  scotty
  semigroupoids
  semigroups
  servant
  servant-docs   
  servant-lucid  
  servant-server
  servant-jquery
  shake
  shakespeare
  shelly
  snap
  snap-core
  snap-extras
  snap-loader-static
  snap-server
  snaplet-postgresql-simple
  speculation
  split
  spoon
  sqlite-simple
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
  text           
  time
  time
  transformers
  unordered-containers
  vector
  void
  wai
  wai-extra
  warp
  xhtml
  xmlhtml
  yaml
  zippers
  zlib
 #classy-prelude-yesod
  ];
  
  myPackages784 = p: with p; [
   #OpenGL
  #cabal2nix
  #category-extras
  #classy-prelude-yesod
  #ghcjs-dom
  #gloss
  #haddock-api
  #idris
  #reflex
  #reflex-dom
  #reflex-todomvc
  #wai-loggerm
  #yesod-for
  HUnit
  #IfElse
  MemoTrie
  MissingH
  MonadCatchIO-transformers
  QuickCheck 
  QuickCheck 
  accelerate
  adjunctions
  aeson
  aeson
  async
  attempt
  atto-lisp
  attoparsec
  attoparsec-conduit
  base
  bifunctors
  bifunctors
  binary-conduit
  blaze-svg
  bytestring
  bytestring
  cassava
  charset
  classy-prelude
  classy-prelude-conduit
  clay 
  clay 
  codex
  conduit
  conduit-combinators
  containers
  data-default
  derive
  directory
  distributive
  #djinn #mueval
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
  flow
  ghc-events
  ghc-mod
  goa
  #hakyll
  hamlet
  #hashable
  hashtables
  haskeline
  hasktags
  #hdevtools
  heist
  hfsevents
  hi
  hjsmin
  hlint
  hobbes
  hoopl
  hslogger
  hspec
  html
  http-conduit
  iso8601-time  
  lens
  lens-aeson
  list-tries
  lucid
  mmorph
  monad-control
  monad-logger
  mtl
  mvc
  network-conduit
  optparse-applicative
  pandoc
  parallel
  parsec
  persistent
  persistent-postgresql
  persistent-template
  pipes
  pipes-concurrency
  pointed
  postgresql-simple
  profunctors
  random
  random
  reducers
  reflection
  resourcet
  retry
  rex
  safe
  safecopy
  sbv
  scotty
  semigroupoids
  semigroups
  servant
  servant-docs   
  servant-lucid  
  servant-server
  servant-jquery
  shake
  shakespeare
  shelly
  snap snap-core snap-loader-static snap-server snap-extras snap-blaze snaplet-acid-state
  snaplet-postgresql-simple text time xmlhtml
  speculation
  split
  spoon
  sqlite-simple
  sqlite-simple
  stm
  strict
  strptime
  stylish-haskell
  syb
  system-fileio
  tagged
  tagsoup
  tar
  tasty
  template-haskell
  text
  text         
  text           
  threadscope
  time
  timeparsers
  #timeplot #splot
  transformers
  unordered-containers
  vector
  void
  wai
  wai-extra
  warp
  xhtml
  yaml
  yesod
  yesod-auth
  yesod-bin
  yesod-core
  yesod-static
  zippers
 # z3
  zlib
  #GLUT
  ];

  allowBroken = true;
  allowUnfree = true;

}