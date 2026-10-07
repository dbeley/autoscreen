{
  lib,
  stdenv,
  bash,
  coreutils,
  makeWrapper,
  grim,
  src,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "autoscreen";
  version = "unstable";

  inherit src;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 autoscreen.sh $out/share/autoscreen/autoscreen.sh

    makeWrapper ${bash}/bin/bash $out/bin/autoscreen \
      --add-flags "$out/share/autoscreen/autoscreen.sh" \
      --prefix PATH : ${lib.makeBinPath [ coreutils grim ]}

    runHook postInstall
  '';

  meta = {
    description = "Automatically take screenshots at a random time every hour (Wayland)";
    homepage = "https://github.com/dbeley/autoscreen";
    mainProgram = "autoscreen";
    platforms = lib.platforms.linux;
  };
})
