{l, t, config, ...}: let

  /*
   This ensures that all phases of a given list are connected so that the `out`
   of each phase is fed as an input named `outPrev` to the next phase in the list.
  */
  connectphases = all: currphase: let
    prevphase = if all == [] then null else l.last all;
  in
    all
    ++ [
      (
        derivation (
          currphase.interpreter.env
          // {
            inherit (currphase) name outputs;
            inherit (currphase.interpreter) builder system;
            args = currphase.interpreter.args ++ [currphase.script];
            data = l.toFile "${currphase.name}-data.json" (l.toJSON currphase.data);
          }
          // (l.optionalAttrs (prevphase != null) {
            outPrev = prevphase;
          })
        )
      )
    ];

  # renders a list of loose phases into a single derivation
  renderphasesToSingleDerivation = phases: let
    namedphases = l.mapAttrs (name: phase: phase // {inherit name;}) phases;
    phasesList = l.attrValues namedphases;
    connectedphases = l.foldl
      connectphases
      []
      phasesList;
  in
    l.last connectedphases;

in {

  imports = [
    ./interpreters/default.nix
    ./interpreters/micropython.nix
  ];

  options = {
    phases = l.mkOption {
      type = t.attrsOf (t.submodule [./interfaces/phase.nix]);
    };
    result = l.mkOption {
      type = t.anything;
    };
  };

  config = {
    result = renderphasesToSingleDerivation config.phases;
  };
}
