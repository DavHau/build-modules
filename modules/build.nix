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
          currStep.env
          // {
            inherit (currStep) args builder name outputs system;
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
  options = {
    steps = l.mkOption {
      type = t.attrsOf (t.submoduleWith {
        modules = [./derivation-interface.nix];
      });
    };
    result = l.mkOption {
      type = t.anything;
    };
  };

  config = {
    result = renderStepsToSingleDerivation config.steps;
  };
}
