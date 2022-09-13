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
            inherit (currphase) name;
            inherit (currphase.interpreter) builder system;
            outputs = ["out" "build"];
            args = currphase.interpreter.args ++ [currphase.interpreter.runnerScript];
            data = l.toFile "${currphase.name}-data.json" (l.toJSON currphase.data);
            phases = l.toFile "${currphase.name}-phases.json" (l.toJSON {
              "0001-init" = {
                script = currphase.interpreter.phaseInitScript;
                interpreter =
                  {inherit (currphase.interpreter) args builder env;};
              };
              "0002-main" = {
                script = currphase.script;
                interpreter =
                  {inherit (currphase.interpreter) args builder env;};
              };
              "0003-exit" = {
                script = currphase.interpreter.phaseExitScript;
                interpreter =
                  {inherit (currphase.interpreter) args builder env;};
              };
            });
          }
          // (l.optionalAttrs (prevphase != null) {
            outPrev = prevphase.out;
            buildDirPrev = prevphase.build;
          })
        )
      )
    ];

  # renders a list of loose phases into many derivations
  renderPhasesToDerivations = phases: let
    namedphases = l.mapAttrs (name: phase: phase // {inherit name;}) phases;
    phasesList = l.attrValues namedphases;
    connectedphases = l.foldl
      connectphases
      []
      phasesList;
  in
    l.last connectedphases;

  # renders a list of loose phases into a single derivation
  renderPhasesToSingleDerivation = phases: let
    namedphases = l.mapAttrs (name: phase: phase // {inherit name;}) phases;
    # Some interpreter is required to run the phases.
    # Python is picked here, but any other intrepreter would work as well.
    interpreter = config.interpreters.python;
  in
    derivation (
      interpreter.env
      // {
        inherit (interpreter) builder system;
        name = "multiple-phases";
        args = interpreter.args ++ [interpreter.runnerScript];
        phases = l.toFile "phases.json" (l.toJSON (
          l.mapAttrs
          (name: phase: phase.asAttrs)
          namedphases
        ));
      }
    );

in {

  imports = [
    ./interpreters/default.nix
    ./interpreters/python
  ];

  options = {
    phases = l.mkOption {
      type = t.attrsOf (t.submodule [./interfaces/phase.nix]);
    };
    single = l.mkOption {
      type = t.anything;
    };
    split = l.mkOption {
      type = t.anything;
    };
  };

  config = {
    split = renderPhasesToDerivations config.phases;
    single = renderPhasesToSingleDerivation config.phases;
  };
}
