{ bash
, binutils
, buildGoModule
, cpio
, fetchFromGitHub
, gcc
, go
, gzip
, installShellFiles
, kbd
, lib
, libfido2
, linux
, lvm2
, lz4
, mdadm
, ronn
, swtpm-tpm2
, unixtools
, usbutils
, xz
, zfs
, zstd
}:

buildGoModule rec {
  pname = "booster";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "anatol";
    repo = pname;
    rev = version;
    hash = "sha256-kalVFVBb+ngoUpm+iiIHGS6vBVLEvTVyKuSMSMbp7Qc=";
  };

  vendorHash = "sha256-GD+nsT4/Y2mTF+ztOC3N560BY5+QSfsPrXZ+dJYtzAw=";

  # templatise exec calls for substituteInPlace
  patches = [./exec.patch];

  # runtimeInputs = [ bash binutils kbd libfido2 lvm2 mdadm zfs ];
  postPatch = ''
    mv docs/manpage.md docs/booster.md
    substituteInPlace generator/*.go init/*.go \
      --subst-var-by "bash" "${bash}/bin/bash" \
      --subst-var-by "cpio" "${cpio}/bin/cpio" \
      --subst-var-by "fido2-assert" "${libfido2}/bin/fido2-assert" \
      --subst-var-by "fsck" "${unixtools.fsck}/bin/fsck" \
      --subst-var-by "gcc" "${gcc}/bin/gcc" \
      --subst-var-by "go" "${go}/bin/go" \
      --subst-var-by "gzip" "${gzip}/bin/gzip" \
      --subst-var-by "loadkeys" "${kbd}/bin/loadkeys" \
      --subst-var-by "lsusb" "${usbutils}/bin/lsusb" \
      --subst-var-by "lvm" "${lvm2}/bin/lvm" \
      --subst-var-by "lz4" "${lz4}/bin/lz4" \
      --subst-var-by "mdadm" "${mdadm}/bin/mdadm" \
      --subst-var-by "modules" "${linux.dev}/lib/modules" \
      --subst-var-by "out" "${placeholder "out"}" \
      --subst-var-by "setfont" "${kbd}/bin/setfont" \
      --subst-var-by "strip" "${gcc}/bin/strip" \
      --subst-var-by "swtpm" "${swtpm-tpm2}/bin/swtpm" \
      --subst-var-by "xz" "${xz}/bin/xz" \
      --subst-var-by "zfs" "${zfs}/bin/zfs" \
      --subst-var-by "zpool" "${zfs}/bin/zpool" \
      --subst-var-by "zstd" "${zstd}/bin/zstd"
  '';

  postBuild = ''
    ${ronn}/bin/ronn docs/booster.md
  '';

  # integration tests are run against the current kernel
  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
    kbd
    lz4
    xz
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/anatol/booster/generator.consolefontsDir=${kbd}/share/consolefonts/"
    "-X github.com/anatol/booster/generator.firmwareDir=${linux.dev}/lib/firmware"
    "-X github.com/anatol/booster/generator.imageModulesDir=${linux.dev}/lib/modules"
    "-X github.com/anatol/booster/init.imageModulesDir=${linux.dev}/lib/modules"
  ];

  postInstall = ''
    mkdir $out/etc/
    touch $out/etc/booster.yaml
    mv $out/bin/{generator,booster}
    installManPage docs/booster.1
    installShellCompletion --bash --name booster.bash contrib/completion/bash
  '';

  meta = with lib; {
    description = "Fast and secure initramfs generator ";
    homepage = "https://github.com/anatol/booster";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "init";
  };
}
