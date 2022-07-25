{
  description = "module system based nix builders";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {
    nixpkgs,
    self,
  } @ inp: let
    l = nixpkgs.lib // builtins;
    supportedSystems = ["x86_64-linux"];

    forAllSystems = f: l.genAttrs supportedSystems
      (system: f system nixpkgs.legacyPackages.${system});

  in {

  };
}
