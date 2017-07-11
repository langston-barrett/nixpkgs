{ stdenv, fetchurl, automake, autoconf, m4, perl, gfortran, texlive
, ffmpeg, tk, gnused_422, imagemagick, liblapack, patch, python, openssl, libpng, which, atlas
}:

stdenv.mkDerivation rec {
  name = "sage-${version}";
  version = "7.6";

  src = fetchurl {
    url = "mirror://sagemath/${name}.tar.gz";
    sha256 = "1p8dpbisq2in65hkqm87y6nyzngqws5grgnir6gf37449d30wwaf";
  };

  propagatedBuildInputs = [ atlas ];
  SAGE_ATLAS_LIB = "${atlas}";

  buildInputs = [
    automake
    autoconf
    ffmpeg
    gfortran
    gnused_422
    imagemagick
    liblapack
    libpng
    m4
    openssl
    patch
    perl
    python
    texlive.combined.scheme-basic
    tk
    which
  ];

  patches = [
    ./spkg-singular.patch
    # ./spkg-python.patch
    # ./spkg-git.patch
  ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  preConfigure = ''
    export SAGE_NUM_THREADS=$NIX_BUILD_CORES
    export SAGE_ATLAS_ARCH=fast
    mkdir -p $out/sageHome
    export HOME=$out/sageHome
    export CPPFLAGS="-P"
  '';

  preBuild = ''
    patchShebangs bootstrap
    patchShebangs build
  '';

  # http://doc.sagemath.org/html/en/installation/source.html#using-alternative-compilers
  SAGE_INSTALL_GCC = "no";

  installPhase = ''DESTDIR=$out make install'';

  meta = {
    homepage = "http://www.sagemath.org";
    description = "A free open source mathematics software system";
    license = stdenv.lib.licenses.gpl2Plus;
    broken = true;
  };
}
