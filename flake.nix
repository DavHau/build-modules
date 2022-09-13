{
  description = "module system based nix builders";

  inputs = {
    bin-micropython = {flake = false; url = "github:davhau/nix-bootstrap-binaries/micropython";};
    bin-python = {flake = false; url = "github:davhau/nix-bootstrap-binaries/python";};
    nixpkgs-raw = {flake = false; url = "nixpkgs/nixos-unstable";};
  };

  outputs = {
    bin-micropython,
    bin-python,
    nixpkgs-raw,
    self,
  } @ inp: let
    lib = import "${nixpkgs-raw}/lib";
    l = lib // builtins;
    supportedSystems = ["x86_64-linux"];

    forAllSystems = f: l.genAttrs supportedSystems
      (system: f system);

    bootstrapped = {
      micropython = "${bin-micropython}/bin";
      python = "${bin-python}/bin";
    };

    testBuild' = system: l.evalModules {
      specialArgs = {
        inherit
          bootstrapped
          l
          ;
        t = l.types;
      };
      modules = [
        ./modules/build.nix
        ./examples/package.nix
      ];
    };

  in {
    testBuildSplit = (testBuild' "x86_64-linux").config.split;
    testBuildSingle = (testBuild' "x86_64-linux").config.single;
  };
}
