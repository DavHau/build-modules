# low level module system for nix builds

## Goals

### no stdenv dependency
This project aims to be an alternative for the current nixpkgs stdenv.
Instead of having a rich opinionated standard environment for builds, this project provides a low-level interface to create different build environments from scratch. The framework itself does not have a dependency on C toolchain by default. It also does not have a dependency on any existing package in nixpkgs, only on `nixpkgs/lib`.

### build scripts without bash
`bash` doesn't seem to be a good fit for implementing high level build flow control especially because it does not handle nix native data-structures well. This framework should allow to experiment with alternative build scripting languages. `micropyton` for example could be a good fit, as it is easy to bootstrap, supports many platforms and python is widely used and understood.

### bootstrapping
The framework should be easy to bootstrap. There is no dependency on package expressions from nixpkgs. There should be at least one build time interpreter that is easy to bootstrap, and can be used to build the other build time interpreters.

### Structured data instead of environment variables
This framework deprecates the use of environment variables entirely. Instead, JSON is used to pass data between nix language and build time interpreter. JSON is also used to pass data between build phases.

### modules instead of overrides
This model is based entirely on the nixos module system. It gets rid of `override***` functions entirely. All inputs of packages are discoverable, documented options.

### flexible granularity
Phases are treated like derivations itself. They have inputs and outputs. A build consisting of x phases can be rendered into any number of nix derivation between 1 and x. This allows the user to decide if they want to have granular caching or to build everything in one large derivation.
This also enhances debugging capabilities, as the user can always jump to any arbitrary phase and inspect its output.

### inspection capabilities
With this project, a series of build phases is determined during eval time, not build time, which should make it easier to inspect the phases of a build without having to run the build and puzzle about what is happening.

### flexible phases
The build phases are free from any pre-defined structure, like `unpackPhase`, `configurePhase`. The nixpkgs default phases seem to work well for C based projects but are a misfit for projects of other languages.
In this project, build phases are just a flat attribute set with arbitrary length that can be extended via the nixos module system. Phases can always be added by adding a new attribute. Existing phases can be removed by setting an attribute to null. Phases are always executed in alphanumeric order. The output of each phase is the input of the next phase.

## Optional Goals
### type checked phase transitions
Build phases need to communicate with each other. In nixpkgs, this is currently done by setting environment variables. This doesn't allow for type safe communication between phases.
In this project, environment variables are deprecated. Each build phase will be launched in a completely clean environment. Phases should only pass data to each other via json. `jsonschema` defined at eval time can be used to type check at validate at build time the data passed between phases.
