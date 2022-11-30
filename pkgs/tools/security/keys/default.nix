{ lib, buildGoModule, fetchFromGitHub, mkYarnPackage, symlinkJoin }:

let
  version = "0.2.4";
  owner = "keys-pub";
  rev = "refs/tags/v${version}";
  meta = with lib; {
    homepage = "https://keys.pub";
    description = "Key management is hard";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
in {
  keys-app = mkYarnPackage {
    pname = "keys-app";
    inherit version;

    src = fetchFromGitHub {
      inherit owner rev;
      repo = "app";
      hash = "sha256-wfavnW7FfWxue09AYCqludwHZi1AaEjm1NEPjVMXMOg=";
    };
  };
  keys-ext = symlinkJoin {
    name = "keys-ext-${version}";
    inherit meta;
    paths = lib.mapAttrsToList (tool: {
      doCheck ? true,
      patches ? [],
      vendorHash
    }: buildGoModule {
      pname = "keys-${tool}";
      inherit doCheck patches vendorHash version;
      src = "${fetchFromGitHub {
        inherit owner rev;
        repo = "keys-ext";
        hash = "sha256-K+RR2AzA9vEhWt3CWuGNpQzu243AHvHHjnK04d7lJ7M=";
      }}/${tool}";
      ldflags = [
        "-s"
        "-w"
        "-X=main.version=${version}"
        "-X main.date=1970-01-01T00:00:00Z"
      ];
    }) {
      "auth/cmds/fido2" = {
        patches = [ ./fido2.patch ]; # tidy module
        vendorHash = "sha256-r3FosSb5uk1tewQlgY2qVGuRac+x7VCvsLa6YvnGMW4=";
      };
      firestore = {
        doCheck = false; # integration tests require network access and non existent credentials
        vendorHash = "sha256-eQava0TU+Sgh1KRyr55C62mtdsd1AD96b8o5aiQrIKs=";
      };
      "http/client" = {
        doCheck = false; # integration tests require network access
        vendorHash = "sha256-dVoZPLmy9Qis77tTcxSwNrcpw3hrcdFulhPUfWE4B9E=";
      };
      sdb = {
        vendorHash = "sha256-Y1P8Fw8862snsdShRNqFWpnjTqQp6AAuFuXUVd61JVU=";
      };
      service = {
        vendorHash = "sha256-xjAgpGB82QWWzAa4bphLiiwtVahmFtSxxfxvwGuVjQw=";
      };
      sqlcipher = {
        vendorHash = "sha256-Eca1aN60ynShAX5a4wYnsxPDHlFrQGR73oSk59zkPw8=";
      };
      vault = {
        doCheck = false; # broken upstream tests
        vendorHash = "sha256-PzG2HZLVrrcKV0gR530f+GYjOsvHvgFZFrndAaC+ht0=";
      };
      wormhole = {
        doCheck = false; # integration tests require network access
        vendorHash = "sha256-MN3Eisw59flfxLZ6hh513OetvTmUg+r+aW8TVUatovk=";
      };
    };
  };
}
