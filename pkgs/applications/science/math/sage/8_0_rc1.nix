{ stdenv, fetchFromGitHub, m4, perl, gfortran, texlive, ffmpeg, tk, gnused_422
, imagemagick, liblapack, python, openssl, libpng 
, which
}:

stdenv.mkDerivation rec {
  name = "sage-${version}";
  version = "8.0.rc1";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = "${version}";
    sha256 = "0j95l0rparh3942d9rrrhdz54spkq4qc6ijyxiq2z696xkv269sa";
  };

  buildInputs = [ m4 perl gfortran texlive.combined.scheme-basic ffmpeg gnused_422 tk imagemagick liblapack
                  python openssl libpng which ];

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

  preBuild = "patchShebangs build";

  installPhase = ''DESTDIR=$out make install'';

  meta = {
    homepage = "http://www.sagemath.org";
    description = "A free open source mathematics software system";
    license = stdenv.lib.licenses.gpl2Plus;
    broken = true;
  };
}
