{ cabal, HDBC, mtl, odbc, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "HDBC-odbc";
  version = "2.3.1.1";
  sha256 = "0zypgwy8yxzp69c2775gkzi8591b0l3wncn7vmq11l16ign95fc7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ HDBC mtl time utf8String ];
  extraLibraries = [ odbc ];
  noHaddock = true;
  meta = {
    homepage = "https://github.com/hdbc/hdbc-odbc";
    description = "ODBC driver for HDBC";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.ocharles
    ];
  };
})
