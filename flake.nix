{
  description = "module system based nix builders";

  inputs = {
    micropython-bin = {flake = false; url = "github:davhau/nix-bootstrap-binaries/micropython";};
    nixpkgs-raw = {flake = false; url = "nixpkgs/nixos-unstable";};
  };

  outputs = {
    micropython-bin,
    nixpkgs-raw,
    self,
  } @ inp: let
    lib = import "${nixpkgs-raw}/lib";
    l = lib // builtins;
    supportedSystems = ["x86_64-linux"];

    forAllSystems = f: l.genAttrs supportedSystems
      (system: f system);

    bootstrapped = {
      micropython = "${micropython-bin}/bin";
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
    testBuild = (testBuild' "x86_64-linux").config.result;
  };
}
