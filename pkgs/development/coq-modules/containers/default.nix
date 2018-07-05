{ stdenv, lib, fetchFromGitHub, coq }:

stdenv.mkDerivation rec {
  name = "containers";
  version = "20180705";

  src = fetchFromGitHub {
    owner = "coq-contribs";
    repo = "containers";
    rev = "52b86bed1671321b25fe4d7495558f9f221b12aa";
    sha256 = "0hbnrwdgryr52170cfrlbiymr88jsyxilnpr343vnprqq3zk1xz0";
  };

  buildInputs = [ coq coq.ocaml coq.camlp5 coq.findlib ];

  enableParallelBuilding = true;
  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = {
    homepage = https://github.com/coq-contribs/containers;
    description = "A typeclass-based library of finite sets/maps";
    longDescription = ''
      A reimplementation of the FSets/FMaps library from the standard library,
      using typeclasses.
    '';
    platforms = stdenv.lib.platforms.unix;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.8" ];
  };
}
