{ cabal, aeson, cmdargs, filepath, haskellSrcExts, HUnit, mtl
, strict, syb, testFramework, testFrameworkHunit, yaml
}:

cabal.mkDerivation (self: {
  pname = "stylish-haskell";
  version = "0.5.9.1";
  sha256 = "0wh0n63nywwzlp9glgm10jyidlcyl944ylnfg5phiahr39946x6y";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson cmdargs filepath haskellSrcExts mtl strict syb yaml
  ];
  testDepends = [
    aeson cmdargs filepath haskellSrcExts HUnit mtl syb testFramework
    testFrameworkHunit yaml
  ];
  meta = {
    homepage = "https://github.com/jaspervdj/stylish-haskell";
    description = "Haskell code prettifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
