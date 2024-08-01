{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "yggstack";
  version = "unstable-2024-07-26";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = pname;
    rev = "5a87e43f9a7a0efdb20c9bc9a2e342c335a8767b";
    hash = "sha256-1/Tr4LYXO+GIDzVAjFmPPsXD6X9ZKs1lFpLy4K4zeMw=";
  };

  vendorHash = "sha256-Sw9FCeZ6kIaEuxJ71XnxbbTdknBomxFuEeEyCSXeJcM=";

  subPackages = [ "cmd/yggstack" ];

  meta = {
    description = "Yggdrasil + Netstack (instead of TUN)";
    homepage = "https://github.com/yggdrasil-network/yggstack";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ urandom ];
  };
}
