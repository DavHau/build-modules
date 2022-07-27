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
    outputs = lib.mkOption {
      type = t.listOf t.str;
      default = ["out"];
    };
    system = lib.mkOption {
      type = t.str;
    };
    # TODO: add advanced attributes
    # allowedReferences = lib.mkOption {
    #   name = "allowedReferences";
    #   type = t.nullOr (t.listOf t.str);
    #   default = null;
    # };
    # allowedRequisites = lib.mkOption {
    #   name = "allowedRequisites";
    #   type = t.nullOr (t.listOf t.str);
    #   default = null;
    # };
    # disallowedReferences = lib.mkOption {
    #   name = "disallowedReferences";
    #   type = t.nullOr (t.listOf t.str);
    #   default = null;
    # };
    # disallowedRequisites = lib.mkOption {
    #   name = "disallowedRequisites";
    #   type = t.nullOr (t.listOf t.str);
    #   default = null;
    # };
    # exportReferenceGraph = lib.mkOption {
    #   name = "exportReferenceGraph";
    #   type = t.listOf t.str;
    # };
    # impureEnvVars = lib.mkOption {
    #   name = "exportReferenceGraph";
    #   type = t.listOf t.str;
    # };
    # outputHash = lib.mkOption {
    #   name = "outputHash";
    #   type = t.str;
    # };
    # outputHashAlgo = lib.mkOption {
    #   name = "outputHashAlgo";
    #   type = t.str;
    # };
    # outputHashMode = lib.mkOption {
    #   name = "outputHashMode";
    #   type = t.str;
    # };
    # __contentAddressed = lib.mkOption {
    #   name = "__contentAddressed";
    #   type = t.bool;
    # };
    # passAsFile = lib.mkOption {
    #   name = "passAsFile";
    #   type = t.listOf t.str;
    # };
    # preferLocalBuild = lib.mkOption {
    #   name = "preferLocalBuild";
    #   type = t.bool;
    # };
    # allowSubstitutes = lib.mkOption {
    #   name = "allowSubstitutes";
    #   type = t.bool;
    # };
  };
}
