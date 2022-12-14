{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phlare";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2nzEr4ODDnB08ZqmW2HtTtUqjroGoPGGtYo9+aaKCk4=";
  };

  vendorHash = "";

  subPackages = [ "cmd/..." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/grafana/phlare/pkg/util/build.Version=${version}"
    "-X github.com/grafana/phlare/pkg/util/build.BuildDate=1970-01-01T00:00:00+00:00"
  ];

  meta = with lib; {
    homepage = "https://github.com/grafana/phlare";
    changelog = "https://github.com/grafana/${pname}/releases/tag/v${version}";
    description = "Horizontally-scalable, highly-available, multi-tenant continuous profiling aggregation system";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ urandom ];
  };
}
