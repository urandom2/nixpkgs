{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "authelia";
  version = "4.37.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zNMZkIUEsOX+z1YnGnYC1OKUanUj4sLvRQ8zjhK98jg=";
  };

  vendorHash = "sha256-RodWMeHdlu7WeWmg415giL9Nfw2OoIIOABwgwzegULE=";

  meta = with lib; {
    description = "The Single Sign-On Multi-Factor portal for web apps";
    homepage = "https://www.authelia.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
