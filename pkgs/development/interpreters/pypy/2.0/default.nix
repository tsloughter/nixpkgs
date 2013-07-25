{ stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2, pkgconfig, libffi
, sqlite, openssl, ncurses, pythonFull, expat }:

assert zlibSupport -> zlib != null;

let

  majorVersion = "2.0";
  version = "${majorVersion}.2";

  pypy = stdenv.mkDerivation rec {
    name = "pypy-${version}";

    inherit majorVersion version;

    src = fetchurl {
      url = "https://bitbucket.org/pypy/pypy/downloads/pypy-${version}-src.tar.bz2";
      sha256 = "0g2cajs6m3yf0lak5f18ccs6j77cf5xvbm4h6y5l1qlqdc6wk48r";
    };

    buildInputs = [ bzip2 openssl pkgconfig pythonFull libffi ncurses expat sqlite ]
      ++ stdenv.lib.optional (stdenv ? gcc && stdenv.gcc.libc != null) stdenv.gcc.libc
      ++ stdenv.lib.optional zlibSupport zlib;

    C_INCLUDE_PATH = stdenv.lib.concatStringsSep ":" (map (p: "${p}/include") buildInputs);
    LIBRARY_PATH = stdenv.lib.concatStringsSep ":" (map (p: "${p}/lib") buildInputs);
    LD_LIBRARY_PATH = LIBRARY_PATH;

    preConfigure = ''
      substituteInPlace Makefile \
        --replace "-Ojit" "-Ojit --batch" \
        --replace "pypy/goal/targetpypystandalone.py" "pypy/goal/targetpypystandalone.py --withmod-_minimal_curses --withmod-unicodedata --withmod-thread --withmod-bz2"

      # we are using cpython and not pypy to do translation
      substituteInPlace rpython/bin/rpython \
        --replace "/usr/bin/env pypy" "${pythonFull}/bin/python"
      substituteInPlace pypy/goal/targetpypystandalone.py \
        --replace "/usr/bin/env pypy" "${pythonFull}/bin/python"

      # convince pypy to find nix ncurses
      substituteInPlace pypy/module/_minimal_curses/fficurses.py \
        --replace "/usr/include/ncurses/curses.h" "${ncurses}/include/curses.h" \
        --replace "ncurses/curses.h" "${ncurses}/include/curses.h" \
        --replace "ncurses/term.h" "${ncurses}/include/term.h" \
        --replace "libraries = ['curses']" "libraries = ['ncurses']"
    '';

    TERMINFO = "${ncurses}/share/terminfo/";

    doCheck = true;
    checkPhase = ''
       export HOME="$TMPDIR"
      ./pypy-c ./pypy/test_all.py --pypy=./pypy-c -m "not shutil" lib-python
    '';

    installPhase = ''
       mkdir -p $out/bin
       mkdir -p $out/pypy-c
       cp -R {include,lib_pypy,lib-python,pypy-c} $out/pypy-c
       ln -s $out/pypy-c/pypy-c $out/bin/pypy
       chmod +x $out/bin/pypy
       # TODO: compile python files?
    '';

    passthru = {
      inherit zlibSupport;
      libPrefix = "pypy${majorVersion}";
    };

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      homepage = "http://pypy.org/";
      description = "PyPy is a fast, compliant alternative implementation of the Python language (2.7.3)";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ iElectric ];
    };
  };

in pypy