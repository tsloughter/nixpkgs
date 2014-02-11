/* This function provides a generic Erlang package builder. */

{ erlang, rebar }:

args @ { name, src, buildInputs ? [], ... }:

erlang.stdenv.mkDerivation ({
  inherit src;
  name = name;

  buildInputs = [ rebar ] ++ buildInputs;

  buildPhase = ''
    rebar compile skip_deps=true
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/erlang/lib/$name"

    echo "installing ${name}..."
    cp -R * $out/lib/erlang/lib/$name

    runHook postInstall
    '';
})
