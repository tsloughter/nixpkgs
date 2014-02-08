/* This function provides a generic Erlang package builder. */

{ erlang, rebar }:

args @ { name, src, buildInputs ? [], ... }:

erlang.stdenv.mkDerivation ({
  inherit src;
  name = name;

  buildInputs = [ rebar ] ++ buildInputs;

  installPhase = ''
    runHook preInstall
    echo "$name"
    mkdir -p "$out/lib/erlang/lib/$name"

    echo "installing ${name}..."
    cp -R * $out/lib/erlang/lib/$name

    runHook postInstall
    '';
})
