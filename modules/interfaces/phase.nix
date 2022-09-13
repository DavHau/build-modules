{config, lib, ...}: let
  t = lib.types;
in {
  options = {
    data = lib.mkOption {
      type = t.attrsOf t.anything;
      default = {};
    };
    script = lib.mkOption {
      type = t.path;
    };
    interpreter = lib.mkOption {
      type = t.submodule ./interpreter.nix;
    };
    asAttrs = lib.mkOption {
      type = t.attrsOf t.anything;
    };
  };

  config = {
    asAttrs = {
      inherit (config) data script;
      interpreter = {
        inherit (config.interpreter)
          args
          builder
          env
          ;
      };
    };
  };
}
