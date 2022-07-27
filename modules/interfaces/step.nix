{lib, ...}: let
  t = lib.types;
in {
  options = {
    outputs = lib.mkOption {
      type = t.listOf t.str;
      default = ["out"];
    };
    data = lib.mkOption {
      type = t.attrsOf t.anything;
      default = {};
    };
    script = lib.mkOption {
      type = t.path;
    };
    interpreter = lib.mkOption {
      type = t.anything;
    };
  };
}
