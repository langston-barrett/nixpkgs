{ stdenv, fetchgit, pkgconfig, fontconfig, cmake, libXft, python2, xorg, alsaLib, jsoncpp, expat, mpd_clientlib, curl, wirelesstools, git
}:

stdenv.mkDerivation rec {
  version = "2.4.8";
  name = "basket-${version}";

  # We use fetchgit instead of fetchFromGitHub because it also gets the
  # submodules.
  src = fetchgit {
    url = "https://github.com/jaagr/polybar.git";
    rev = "66131c807f6b8da966d3cad657f38c010323440a";
    sha256 = "1l0gil9m8g2a6qk3csrm88m79ksc8z1v7zb9bwp40yalw17calp7";
  };

  buildInputs = with xorg; [
    alsaLib
    cmake
    curl
    expat
    fontconfig
    jsoncpp
    libX11
    libXau
    libXdmcp
    libXft
    libpthreadstubs
    mpd_clientlib
    pkgconfig
    python2
    wirelesstools
    xcbproto
    xcbutil
    xcbutilimage
    xcbutilwm
  ];

  configureFlags = [ "--with-libcurl-headers=${curl.dev}/include" ];

  preConfigure = ''
    export LIBMPDCLIENT_LIBS=${mpd_clientlib}/lib/libmpdclient.so.${mpd_clientlib.majorVersion}.0.${mpd_clientlib.minorVersion}
    export LIBMPDCLIENT_CFLAGS=${mpd_clientlib}
  '';

  # buildPhase = ''
  #   chmod +x $out/build.sh
  #   bash $out/build.sh
  # '';

  meta = {
    description = "A fast and easy-to-use status bar";
    homepage    = https://github.com/jaagr/polybar;
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
  };
}
