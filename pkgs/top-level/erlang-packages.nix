{ pkgs, erlang }:

rec {
  inherit erlang;
  inherit (pkgs) fetchurl fetchsvn fetchgit stdenv;

  # helpers

  callPackage = pkgs.lib.callPackageWith (pkgs);

  buildErlangPackage = callPackage ../development/erlang-modules/generic { };

  # packages defined here

  goldrush = buildErlangPackage {
    name = "goldrush-0.1.6";
    src = fetchurl {
      url = https://github.com/DeadZen/goldrush/archive/0.1.6.tar.gz;
      sha256 = "554f36983e19fcf2ebee18b5c0ff502af4fc1b853b49041c7a9821d7043e349f";
    };

    meta = {
      description = "Small, Fast event processing and monitoring for Erlang/OTP applications.";
      license = "";
    };
  };

  lager = buildErlangPackage {
    name = "lager-2.0.2";
    src = fetchurl {
      url = https://github.com/basho/lager/archive/2.0.2.tar.gz;
      sha256 = "24767afb0072f78c267f6d1c9fbe61d69ea3103c3bdb371454e8e06acf7d841c";
    };

    buildInputs = [ goldrush ];

    meta = {
      description = "A logging framework for Erlang/OTP";
      license = "Apache";
    };
  };

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
