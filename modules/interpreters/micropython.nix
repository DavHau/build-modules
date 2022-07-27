{lib, ...}: let
  t = lib.types;
in {
  interpreters.micropython = {
    system = "x86_64-linux";
    builder = "${../../bbin}/ld-linux";
    env.MICROPYPATH = "${../../bbin}/mpy-lib";
    args = ["${../../bbin}/micropython"];
  };
}
