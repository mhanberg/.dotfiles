{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ipython,
  kivy,
  matplotlib,
  networkx,
  numpy,
  pillow,
  plotly,
  pygame,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "colorir";
  version = "0-unstable-2025-06-24";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aleferna12";
    repo = "colorir";
    rev = "34d45e10ca2b575ac2fdcdadc53beed1ffd693c7";
    hash = "sha256-mlsbcLYUl7iiCz33rTmMfld3LDZzBWM2mSIM9M18hDM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    ipython
    kivy
    matplotlib
    networkx
    numpy
    pillow
    plotly
    pygame
    setuptools
  ];

  pythonImportsCheck = [
    "colorir"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A python package for creation and management of color palettes";
    homepage = "https://github.com/aleferna12/colorir";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
})
