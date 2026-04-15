{ pkgs, lib }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "qbz";
  version = "1.2.4";

  src = pkgs.fetchFromGitHub {
    owner = "vicrodh";
    repo = "qbz";
    rev = "v${version}";
    hash = "sha256-3MPWLovWRmSrSfaR5ciZR2+4S7QzPYYVdVKP+mczhis=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;
  cargoLock = {
    lockFile = "${src}/src-tauri/Cargo.lock";
  };

  npmDeps = pkgs.fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    inherit src;
    hash = "sha256-JN3lQyEX1n5G1OcWuRNZl/KSfL7JEfsc4opeh4F/iAY=";
  };

  env.LIBCLANG_PATH = "${pkgs.lib.getLib pkgs.llvmPackages.libclang}/lib";

  nativeBuildInputs = with pkgs; [
    clang
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    alsa-lib
    openssl
    webkitgtk_4_1
    glib-networking
    libsecret
    libayatana-appindicator
  ];

  runtimeDependencies = with pkgs; [
    libayatana-appindicator
  ];

  checkFlags = [
    "--skip=credentials::tests::test_credentials_roundtrip"
    "--skip=credentials::tests::test_encryption_roundtrip"
    "--skip=qconnect_service::tests::refreshes_local_renderer_id_from_unique_fingerprint_when_uuid_missing"
  ];

  postInstall = ''
    install -Dm644 ${src}/src-tauri/icons/icon.png $out/share/icons/hicolor/512x512/apps/qbz.png
  '';
}
