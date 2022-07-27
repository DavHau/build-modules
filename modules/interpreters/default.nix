{lib, ...}: let
  t = lib.types;
in {
  options = {
    interpreters = lib.mkOption {
      type = t.attrsOf (t.submoduleWith {
        modules = [../interfaces/interpreter.nix];
      });
    };
  };
}
