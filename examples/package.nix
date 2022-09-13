{config, ...}:{
  phases = {
    phase1 = {
      interpreter = config.interpreters.python;
      script = ./phase1.py;
      data = {
        foo = "bar";
      };
    };
    phase2 = {
      interpreter = config.interpreters.python;
      script = ./phase2.py;
      data = {
        bar = "baz";
      };
    };
  };
}
