{
  lib,
  stdenv,
  bash,
  coreutils,
  makeWrapper,
  grim,
  libwebp,
  libavif,
  libjxl,
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

    # grim writes png/jpeg/ppm; libwebp/libavif/libjxl provide the optional
    # cwebp/avifenc/cjxl re-encoders for the webp/avif/jxl output formats.
    makeWrapper ${bash}/bin/bash $out/bin/autoscreen \
      --add-flags "$out/share/autoscreen/autoscreen.sh" \
      --prefix PATH : ${lib.makeBinPath [ coreutils grim libwebp libavif libjxl ]}

    runHook postInstall
  '';

  meta = {
    description = "Automatically take screenshots at a random time every hour (Wayland)";
    homepage = "https://github.com/dbeley/autoscreen";
    mainProgram = "autoscreen";
    platforms = lib.platforms.linux;
  };
})
