{ buildGoPackage
, fetchFromGitHub
, qt5
, go
, lib
, stdenv
, therecipe-qt
}:

buildGoPackage rec {
  pname = "goneovim";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "akiyosi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WluB+KTdsyEDskUUQXwaORoZxxJGsbFFB8TPLKmcrLU=";
  };

  # upstream does not support modules
  goPackagePath = "github.com/akiyosi/goneovim";

  goDeps = ./deps.nix;

  postPatchPhase = ''
    cd cmd/goneovim
    qtmoc
  '';

  # patches = [ ./mod.patch ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    therecipe-qt
  ];

  buildInputs = [
    qt5.qtbase
  ];

  ldflags = [
    "-s"
    "-w"
    "-X ${goPackagePath}/editor.Version=${version}"
  ];

  buildPhase = ''
    runHook preBuild
    runHook renameImports

    cd go/src/${goPackagePath}/cmd/goneovim
    export QT_QMAKE_DIR=${qt5.qtbase.dev}/bin
    qtdeploy -ldflags '${lib.strings.concatStringsSep " "  ldflags}' build desktop
    ls -l
    exit 1
  '' + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    # normalize cross-compiled builds w.r.t. native builds
    (
      dir=$NIX_BUILD_TOP/go/bin/${go.GOOS}_${go.GOARCH}
      if [[ -n "$(shopt -s nullglob; echo $dir/*)" ]]; then
        mv $dir/* $dir/..
      fi
      if [[ -d $dir ]]; then
        rmdir $dir
      fi
    )
  '' + ''
    runHook postBuild
  '';

  meta = with lib; {
    description = "A GUI frontend for neovim.";
    homepage = "https://github.com/akiyosi/goneovim";
    changelog = "https://github.com/akiyosi/goneovim/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
