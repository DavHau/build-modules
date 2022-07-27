{config, ...}:{
  phases = {
    phase1 = {
      interpreter = config.interpreters.micropython;
      script = ./phase1.py;
      data = {
        foo = "bar";
      };
    };
    phase2 = {
      interpreter = config.interpreters.micropython;
      script = ./phase2.py;
      data = {
        bar = "baz";
      };
    };
  };
}
