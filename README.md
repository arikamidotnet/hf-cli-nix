# hf-cli-nix

A minimal Nix flake for installing the official Hugging Face CLI (`hf`) via
[`huggingface_hub`](https://huggingface.co/docs/huggingface_hub/en/index).

## Install

```bash
nix profile install github:peedrr/hf-cli-nix
```

After installation, `hf` is available on your PATH:

```bash
hf --help
hf --version
```

## Run without installing

```bash
nix run github:peedrr/hf-cli-nix -- --help
nix run github:peedrr/hf-cli-nix -- --version
```

## Use as an input in another flake

```nix
{
  inputs.hf-cli.url = "github:peedrr/hf-cli-nix";

  outputs = { self, hf-cli, ... }:
    let
      system = "x86_64-linux";
    in
    {
      packages.${system}.default = hf-cli.packages.${system}.hf;
    };
}
```

## Update

Update the `nixpkgs` input (and any others) to their latest lock entries:

```bash
nix flake update
```

Then build and test again:

```bash
nix build
./result/bin/hf --version
```

## Supported systems

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

The package reuses `nixpkgs#python3Packages.huggingface-hub`, so binary
availability depends on the upstream nixpkgs build.
