{bootstrapped, lib, ...}: let
  t = lib.types;
in {
  interpreters.micropython = {
    system = "x86_64-linux";
    builder = "${bootstrapped.micropython}/ld-linux";
    env.MICROPYPATH = "${bootstrapped.micropython}/mpy-lib";
    args = ["${bootstrapped.micropython}/micropython"];
    runnerScript = ./runner.py;
  };
}
