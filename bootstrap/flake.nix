{
  description = "bootstrap binaries for build-modules";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    micropython-lib-src = {flake = false; url = "github:micropython/micropython-lib";};
  };

  outputs = {
    micropython-lib-src,
    nixpkgs,
    self,
  } @ inp: let
    l = nixpkgs.lib // builtins;
    supportedSystems = ["x86_64-linux"];

    forAllSystems = f: l.genAttrs supportedSystems
      (system: f system nixpkgs.legacyPackages.${system});

  in {

    packages = forAllSystems (system: pkgs: rec {

      bootstrap = pkgs.writeScriptBin "boostrap" ''
        cp -r ${bootstrap-binaries} ./bootstrap-binaries
        chmod +w -R ./bootstrap-binaries
      '';

      micropython-stdlib = import ./micropython-stdlib.nix {
        inherit micropython-lib-src;
        inherit (pkgs) runCommand;
      };

      micropython-static = pkgs.pkgsStatic.micropython.overrideAttrs (old: {
        checkPhase = ":";
        NIX_CFLAGS_COMPILE = [
          "-w"
          "-Wno-error"
        ];
        nativeBuildInputs = old.nativeBuildInputs ++ (with pkgs; [
          bintools
        ]);
        preBuild = ''
          mkdir $TMP/bin
          ln -s $NIX_CC/bin/*gcc $TMP/bin/gcc
          ln -s $NIX_CC/bin/*strip $TMP/bin/strip
          ln -s $(${pkgs.which}/bin/which $PKG_CONFIG) $TMP/bin/pkg-config
          export PATH="$PATH:$TMP/bin"
        '';
      });

      bootstrap-binaries = pkgs.runCommand "bootstrap-binaries" {} ''
        mkdir $out
        cp ${micropython-static}/bin/micropython $out/micropython
        cp -r ${micropython-stdlib}/lib $out/mp-lib
      '';

      # micropython-with-stdlib = pkgs.micropython.overrideAttrs (old: {
      #   doCheck = false;
      #   postInstall = ''
      #     mkdir -p $out/lib
      #     cp -r ${micropython-stdlib}/lib/* $out/lib/
      #   '';
      #   postPatch = ''
      #     substituteInPlace ports/unix/main.c --replace \
      #       "path = MICROPY_PY_SYS_PATH_DEFAULT;" \
      #       "path = \"$MICROPY_PY_SYS_PATH_DEFAULT\";"
      #   '';
      #   MICROPY_PY_SYS_PATH_DEFAULT = ".frozen:${micropython-stdlib}/lib";
      # });
    });
  };
}
