{config, ...}:{
  steps = {
    step1 = {
      interpreter = config.interpreters.micropython;
      script = ./step1.py;
      data = {
        foo = "bar";
      };
    };
    step2 = {
      interpreter = config.interpreters.micropython;
      script = ./step2.py;
      data = {
        bar = "baz";
      };
    };
  };
}
