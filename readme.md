# low level module system for nix builds

## Goals

### no stdenv dependency
This project aims to be an alternative for the current nixpkgs stdenv.
Instead of having a rich opinionated standard environment for builds, this project provides a low-level interface to create defferent build environments from scratch. The framework itself does not have a dependency on C toolchain by default. It also does not have a dependency on any existing package in nixpkgs, only on `nixpkgs/lib`.

### other build runtimes than bash
`bash` doesn't seem to be a good fit for implementing high level build flow control especially because it does not handle nix native data-structures well. This framework should allow to experiment with alternative build scripting languages. `micropyton` for example could be a good fit, as it is easy to bootstrap, supports many platforms and python is widely used and understood.

### bootstrapping
The framework should be easy to bootstrap. There is no dependency on package expressions from nixpkgs. There should be at least one build runtime that is easy to bootstrap, and can be used to build the other build runtimes.

### Structured data instead of environment variables
Environment variables are currently used in nixpkgs as an interface between the nix language and nix builds. This makes it hard to work with structured data, as environment variables only accept strings.
This framework deprecates the use of environment variables entirely. Instead, json is used to pass data between nix and the build runtime.

### modules instead of overrides
This model is based entirely on the nixos module system. It gets rid of `override***` functions entirely. All inputs of packages are discoverable, documented options.

### flexible granularity
A build `phase` and a `derivation` itself share the same interface. This allows a 1 to 1 conversion between the two, so that a `derivation` can always be rendered into a single `phase`, or inversely, each `phase` can be rendered into a single build/derivation. This abstraction is called `step` here. A build consisting of 100 `steps` can be rendered into any number of actual nix derivations between 100 and 1. This allows the user to decide if they want to have granular caching or to build everything in one large derivation.

### inspection capabilities
With current nixpkgs build hooks, the exact build graph within an individual derivation can be manipulated arbitrarily during build time. Hooks can be added, in arbitrary places for example. This often makes it very hard to reason about what code/scripts/functions will be executed during the build.

With this project, a series of build `steps` is determined during eval time, not build time, which should make it easier to inspect the steps of a build without having to run the build and puzzle about what is happening.

### flexible phases/steps
The build phases (or here `steps`) are free from any pre-defined structure, like `unpackPhase`, `configurePhase`. The nixpkgs default phases seem to work well for C based projects but are a misfit for projects of other languages.
In this project, build steps are just a flat attribute set with arbitrary length that can be extended via the nixos module system. Steps can always be added by adding a new attribute. Existing steps can be removed by setting an attribute to null. Steps are always executed in alphanumeric order. The output of each step is the input of the next step.

### type checked phase transitions
Build phases (or here `steps`) need to communicate with each other. In nixpkgs, this is currently done by setting environment variables. This doesn't allow for type safe communication between phases.
In this project, environment variables are deprecated. Each build `step` will be launched in a completely clean environment. `steps` should only pass data to each other via json. `jsonschema` defined at eval time can be used to type check the data at build time after each executed step.
