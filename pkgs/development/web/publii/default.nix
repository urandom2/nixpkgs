{ autoPatchelfHook
, fetchurl
, lib
, rpmextract
, stdenv
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, glib
, gtk3
, libX11
, mesa
, nss
, pango
, xorg
, wrapGAppsHook
, alsa-lib
, libsecret
}:

stdenv.mkDerivation rec {
  pname = "publii";
  version = "0.41.1";

  src = fetchurl {
    url = "https://getpublii.com/download/Publii-${version}.rpm";
    hash = "sha256-Lt6SaiKdsUn3biOmvKw8X0fI52CHb0R/7v4I6axfwm8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
    rpmextract
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libX11
    libsecret
    mesa
    nss
    pango
    xorg.libxcb
  ];

  unpackPhase = "rpmextract $src";

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/share $out
    mv opt/Publii $out/lib
    ln -s $out/lib/Publii $out/bin/publii

    runHook postInstall
  '';

  meta = with lib; {
    description = "A continuation of development on zxfer, a popular script for managing ZFS snapshot replication";
    homepage = "https://getpublii.com";
    changelog = "https://github.com/getpublii/publii/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ urandom ];
  };
}
