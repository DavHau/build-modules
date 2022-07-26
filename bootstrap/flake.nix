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
        rm -rf ./bbin
        cp -r ${bbin} ./bbin
        chmod +w -R ./bbin
        git add -f ./bbin
      '';

      bbin = pkgs.runCommand "bbin" {} ''
        mkdir $out
        cp ${micropython-standalone}/bin/* $out/
        cp -r ${micropython-stdlib}/lib $out/mpy-lib
        cp ${pkgs.pcre.out}/lib/libpcre.so $out/libpcre.so
      '';

      micropython-stdlib = import ./micropython-stdlib.nix {
        inherit micropython-lib-src;
        inherit (pkgs) runCommand;
      };

      micropython-musl = pkgs.pkgsMusl.micropython.overrideAttrs (old: {
        doCheck = false;
        NIX_CFLAGS_COMPILE = [
          "-w"
          "-Wno-error"
        ];
      });

      micropython = pkgs.micropython.overrideAttrs (old: {
        doCheck = false;
      });

      micropython-musl-standalone = pkgs.runCommand "micropython-standalone" {} ''
        mkdir -p $out/bin
        cp ${micropython-musl}/bin/micropython $out/bin/micropython
        chmod +w $out/bin/*
        patchelf $out/bin/micropython --no-default-lib
        patchelf $out/bin/micropython --set-rpath '$ORIGIN'
        cp -r ${pkgs.musl}/lib/libc.so $out/bin/
        cp -r ${pkgs.musl}/lib/ld-musl* $out/bin/ld-linux
        cp -r ${pkgs.libffi}/lib/libffi.so.* $out/bin/
      '';

      micropython-standalone = pkgs.runCommand "micropython-standalone" {} ''
        mkdir -p $out/bin
        cp ${micropython}/bin/micropython $out/bin/micropython
        chmod +w $out/bin/*
        patchelf $out/bin/micropython --no-default-lib
        patchelf $out/bin/micropython --set-rpath '$ORIGIN'
        cp -r ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 $out/bin/ld-linux
        cp -r ${pkgs.glibc}/lib/libpthread.so.0 $out/bin/
        cp -r ${pkgs.glibc}/lib/libdl.so.2 $out/bin/
        cp -r ${pkgs.glibc}/lib/libm.so.6 $out/bin/
        cp -r ${pkgs.glibc}/lib/libc.so.6 $out/bin/
        cp -r ${pkgs.libffi}/lib/libffi.so.* $out/bin/
      '';

      micropython-static = pkgs.pkgsStatic.micropython.overrideAttrs (old: {
        checkPhase = ":";
        NIX_CFLAGS_COMPILE = [
          "-w"
          "-Wno-error"
        ];
        nativeBuildInputs = old.nativeBuildInputs ++ (with pkgs; [
          bintools
        ]);
        DEBUG=true;
        preBuild = ''
          mkdir $TMP/bin
          ln -s $NIX_CC/bin/*gcc $TMP/bin/gcc
          ln -s $NIX_CC/bin/*strip $TMP/bin/strip
          ln -s $(${pkgs.which}/bin/which $PKG_CONFIG) $TMP/bin/pkg-config
          export PATH="$PATH:$TMP/bin"
        '';
      });

      musl-static = pkgs.pkgsStatic.musl;
    });
  };
}
