# Custom Glove80 firmware

## Build

Install Docker and [keymap-drawer](https://pypi.org/project/keymap-drawer/).

Build custom [ZMK firmware (MoErgo fork)](https://github.com/moergo-sc/zmk) using their [nix solution](https://github.com/moergo-sc/zmk/blob/main/README-NIX.md).

```sh
# build main
$ make
# build specific tag
$ make BRANCH=v24.08-beta.1
```

## Layers

![The keyboard layout's layers visualized](keymap.svg)

## Linux config

Use the following keyboard configuration on your Linux computer:

```sh
$ setxkbmap -layout us -variant de_se_fi -option eurosign:e -option compose:menu
```

## Reference

- [ZMK Keymaps & Behaviors](https://zmk.dev/docs/keymaps)
