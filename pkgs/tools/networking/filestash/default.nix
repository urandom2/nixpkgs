{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "filestash";
  version = "unstable-2022-11-25";

  src = fetchFromGitHub {
    owner = "mickael-kerjean";
    repo = pname;
    rev = "5c9c85ff2a8756963a14e00712f78a234195ba8e";
    hash = "sha256-84POMykoBsh926LyxwoYfmSAeyyMz2nXIJXCsUg7E0o=";
  };

  postConfigurePhase = "go generate -x ./server/...";

  vendorHash = null;

  meta = with lib; {
    description = "A modern web client for SFTP, S3, FTP, WebDAV, Git, Minio, LDAP, CalDAV, CardDAV, Mysql, Backblaze, ...";
    homepage = "https://www.filestash.app";
    license = licenses.agpl3;
    maintainers = with maintainers; [ urandom ];
  };
}
