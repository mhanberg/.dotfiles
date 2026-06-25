{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  zstd,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weave";
  version = "0-unstable-2026-06-20";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "matze";
    repo = "weave";
    rev = "f60bcc364b599a46d074cfb8416e837e9f9167d8";
    hash = "sha256-xWCVnSQJGeyiUrbFZnigaC7vQFX/CBsIbEw38I4z7gk=";
  };

  cargoHash = "sha256-xl9ZDmW6LPOfflcFp1DTi7w9RegSJ2Vtsv1vm4Y+an0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
    zstd
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalistic zk web frontend";
    homepage = "https://github.com/matze/weave";
    changelog = "https://github.com/matze/weave/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ ];
    mainProgram = "weave";
  };
})
