{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "monitoror";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-uOmUKWsdXoGbJI8/5NzXirACKLka3YCnruHKkyCFGIc=";
  };

  vendorHash = "sha256-gejy0+MoiZLtha8LEvDunpAxsA68mILwVYhOOnwFbgs=";

  meta = with lib; {
    description = "Unified monitoring wallboard";
    longDescription = "Light, ergonomic and reliable monitoring for anything.";
    homepage = "https://monitoror.com";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
