{lib, ...}: let
  t = lib.types;
in {
  options = {
    args = lib.mkOption {
      type = t.listOf t.str;
      default = [];
    };
    builder = lib.mkOption {
      type = t.oneOf [t.str t.path t.package];
    };
    env = lib.mkOption {
      type = t.attrsOf (t.oneOf [t.str t.path t.package]);
      default = {};
    };
    system = lib.mkOption {
      type = t.str;
    };
  };
}
