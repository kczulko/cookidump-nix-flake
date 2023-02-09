# cookidump-nix-flake

## Why?

Since the [cookidump author has removed existing nix flake from the mainline](https://github.com/auino/cookidump/commit/104f55e7ca30aff97b278432f2a3fc45a8061bf1), I decided to create it outside of the [cookidump](https://github.com/auino/cookidump) repository.

## Usage

```
nix run github:kczulko/cookidump-nix-flake -- <outputdir> [--separate-json]
```

Nix provisions `google-chrome` together with `chromedriver`. Only 
`<outputdir>` and `[--separate-json]` arguments are expected.
