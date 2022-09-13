{bootstrapped, lib, ...}: let
  t = lib.types;
in {
  interpreters.python = {
    system = "x86_64-linux";
    builder = "${bootstrapped.python}/python";
    env.PYTHONPATH = "${bootstrapped.python}/lib/python3.10";
    env.PYTHONHOME = "${bootstrapped.python}";
    args = [];
    runnerScript = ./runner.py;
    phaseInitScript = ./phase-init.py;
    phaseExitScript = ./phase-exit.py;
  };
}
