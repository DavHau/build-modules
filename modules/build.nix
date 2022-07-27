{l, t, config, ...}: let

  /*
   This ensures that all steps of a given list are connected so that the `out`
   of each step is fed as an input named `outPrev` to the next step in the list.
  */
  connectSteps = all: currStep: let
    prevStep = if all == [] then null else l.last all;
  in
    all
    ++ [
      (
        derivation (
          currStep.interpreter.env
          // {
            inherit (currStep) name outputs;
            inherit (currStep.interpreter) builder system;
            args = currStep.interpreter.args ++ [currStep.script];
            data = l.toFile "${currStep.name}-data.json" (l.toJSON currStep.data);
          }
          // (l.optionalAttrs (prevStep != null) {
            outPrev = prevStep;
          })
        )
      )
    ];

  # renders a list of loose steps into a single derivation
  renderStepsToSingleDerivation = steps: let
    namedSteps = l.mapAttrs (name: step: step // {inherit name;}) steps;
    stepsList = l.attrValues namedSteps;
    connectedSteps = l.foldl
      connectSteps
      []
      stepsList;
  in
    l.last connectedSteps;

in {

  imports = [
    ./interpreters/default.nix
    ./interpreters/micropython.nix
  ];

  options = {
    steps = l.mkOption {
      type = t.attrsOf (t.submodule [./interfaces/step.nix]);
    };
    result = l.mkOption {
      type = t.anything;
    };
  };

  config = {
    result = renderStepsToSingleDerivation config.steps;
  };
}
