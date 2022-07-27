{
  description = "module system based nix builders";

  inputs = {
    nixpkgs-raw = {flake = false; url = "nixpkgs/nixos-unstable";};
  };

  outputs = {
    nixpkgs-raw,
    self,
  } @ inp: let
    lib = import "${nixpkgs-raw}/lib";
    l = lib // builtins;
    supportedSystems = ["x86_64-linux"];

    forAllSystems = f: l.genAttrs supportedSystems
      (system: f system);

    testBuild' = system: l.evalModules {
      specialArgs = {inherit l; t = l.types;};
      modules = [
        ./modules/build.nix
        ./examples/package.nix
      ];
    };

  in {
    testBuild = (testBuild' "x86_64-linux").config.result;
  };
}
