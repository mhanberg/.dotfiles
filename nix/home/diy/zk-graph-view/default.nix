{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "zk-graph-view";
  version = "0-unstable-2026-06-05";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cyberSapoPerro";
    repo = "zk-graph-view";
    rev = "d2f76f0ba0f8ecc21daa89ff4ffb8ec2012eb808";
    hash = "sha256-zAO42iaNS3joTchncHj5PKejsvEJnzIRqBs4arEHlog=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  # `typing` is a stdlib module on modern Python; upstream still declares it as
  # a runtime dependency, so strip it to satisfy pythonRuntimeDepsCheck.
  pythonRemoveDeps = [ "typing" ];

  dependencies =
    let
      colorir = python3Packages.callPackage ../python/colorir.nix { };
    in
    with python3Packages;
    [
      colorir
      pyvis
    ];

  pythonImportsCheck = [
    "zk_graph_view"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive visualization of Zettelkasten graphs generated with zk";
    homepage = "https://github.com/cyberSapoPerro/zk-graph-view";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "zk-graph-view";
  };
})
