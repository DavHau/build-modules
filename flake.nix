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

    testBuild' = system: l.evalModules {
      specialArgs = {inherit l; t = l.types;};
      modules = [
        ./modules/build.nix
        {
          steps = {
            step1 = {
              inherit system;
              builder = "${./bbin}/ld-linux";
              env.MICROPYPATH = ./bbin/mpy-lib;
              args = ["${./bbin}/micropython" "${./examples}/step1.py"];
            };
            step2 = {
              inherit system;
              builder = "${./bbin}/ld-linux";
              env.MICROPYPATH = ./bbin/mpy-lib;
              args = ["${./bbin}/micropython" "${./examples}/step2.py"];
            };
          };
        }
      ];
    };

  in {
    testBuild = (testBuild' "x86_64-linux").config.result;
  };
}
