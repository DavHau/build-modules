{config, ...}:{
  steps = {
    step1 = {
      interpreter = config.interpreters.micropython;
      script = ./examples/step1.py;
      data = {
        foo = "bar";
      };
    };
    step2 = {
      interpreter = config.interpreters.micropython;
      script = ./examples/step2.py;
      data = {
        bar = "baz";
      };
    };
  };
}
