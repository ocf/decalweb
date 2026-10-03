{
  stdenvNoCC,
  git,
  hugo,
  just,
}:

stdenvNoCC.mkDerivation {
  name = "ocf-decal-web";
  src = ./.;

  nativeBuildInputs = [
    hugo
  ];

  buildPhase = ''
    runHook preBuild
    hugo
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mv public $out
    runHook postInstall
  '';
}
