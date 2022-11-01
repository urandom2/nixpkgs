{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "atlas";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ariga";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sC0RkRUtOkmQ07A7WVU9Tg29Ffk6H26z7FdtnMgatc8=";
  };

  modRoot = "./cmd/atlas";

  proxyVendor = true;
  vendorHash = "sha256-XjmXMj9EaRuqSqAgZdvi51gy2gMbwYk6/J40qbQH8CQ=";

  doCheck = false;

  meta = with lib; {
    description = "A database toolkit";
    homepage = "https://atlasgo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
