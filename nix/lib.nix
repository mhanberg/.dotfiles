{
  config,
  lib,
  ...
}: rec {
  joinHome = path: config.home.homeDirectory + path;
  fromHome = attrset: (lib.attrsets.mapAttrs' (name: value: lib.attrsets.nameValuePair (joinHome name) value) attrset);
}
