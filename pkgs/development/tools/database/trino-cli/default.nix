{ lib, stdenv, fetchurl, jre_headless, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "trino-cli";
  version = "410";

  jarfilename = "${pname}-${version}-executable.jar";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "mirror://maven/io/trino/${pname}/${version}/${jarfilename}";
    sha256 = "sha256-8ywle5z8OOFejAsBKSrh8RvaKyO1zht1My4QjKe/Lps=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/share/java/${jarfilename}"

    makeWrapper ${jre_headless}/bin/java $out/bin/trino \
      --add-flags "-jar $out/share/java/${jarfilename}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "The Trino CLI provides a terminal-based, interactive shell for running queries";
    homepage = "https://github.com/trinodb/trino";
    license = licenses.asl20;
    maintainers = with maintainers; [ regadas cpcloud ];
  };
}
