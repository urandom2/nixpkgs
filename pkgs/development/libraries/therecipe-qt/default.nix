{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "therecipe-qt";
  version = "unstable-2020-09-04";

  src = fetchFromGitHub {
    owner = "therecipe";
    repo = "qt";
    rev = "c0c124a5770d357908f16fa57e0aa0ec6ccd3f91";
    hash = "sha256-LSOm6/P1fOO3jlwxMm78mJMH7iuNvbBuE688sAVs/KQ=";
  };

  patches = [ ./tidy.patch ];

  vendorHash = "sha256-YZ/vHNB/zgIz9K7daoWq5X7cwcoSYm+Dre/6Hxtgrxs=";

  subPackages = [ "cmd/..." ];

  meta = with lib; {
    description = "Qt binding for Go (Golang)";
    homepage = "https://github.com/therecipe/qt";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ urandom ];
  };
}
