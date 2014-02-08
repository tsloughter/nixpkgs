{ pkgs, erlang }:

rec {

  inherit erlang;
  inherit (pkgs) fetchurl fetchsvn fetchgit stdenv;

  # helpers

  callPackage = pkgs.lib.callPackageWith (pkgs);

  buildErlangPackage = callPackage ../development/erlang-modules/generic { };

  # packages defined here

  heroku_crashdumps = buildErlangPackage {
    name = "heroku_crashdumps-0.1.0";
    src = fetchurl {
      url = https://github.com/heroku/heroku_crashdumps/archive/0.1.0.tar.gz;
      sha256 = "86ac3da400278bf37870c82f43373512f51c43bc6ccbeeb1f7d28a82c688d8b7";
    };

    meta = {
      description = "Configures crash dump output location";
      license = "GPL";
    };
  };
}
