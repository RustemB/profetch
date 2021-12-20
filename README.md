# profetch

## Screenshots

|                                                                                                                   |
| ----------------------------------------------------------------------------------------------------------------- |
| By [v](https://github.com/q60)                                                                                    |
| ![v](https://i.imgur.com/HbG9z6G.png)                                                                             |
| By me                                                                                                             |
| ![rustemb](https://user-images.githubusercontent.com/25725953/141845673-f8a7ea4c-5e2c-4f89-a6c2-aaa671f0204d.png) |

## Requirements

- GNU/Prolog
- Make

## Building

```
$ make
```

## Using

```
$ ./profetch
```

## Installing

### From GitHub

```
# clone or download and unpack repo
$ sudo make install
```

### From AUR

```
$ git clone https://aur.archlinux.org/profetch.git
$ cd profetch
$ makepkg -si

# or using AUR helper (e.g. paru)
$ paru -S profetch
```

### For NixOS

```
$ nix-env -iA profetch
```

# Links

<a href="https://repology.org/project/profetch/versions">
    <img src="https://repology.org/badge/vertical-allrepos/profetch.svg" alt="Packaging status" align="right">
</a>

- Inspired by
  [bfetch](https://gitlab.com/bit9tream/bfetch/-/tree/master) by
  [bit9tream](https://gitlab.com/bit9tream)
- For ArchLinux Users:
  [AUR](https://aur.archlinux.org/packages/profetch/)
- For Nix Users:
  [Nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/misc/profetch/default.nix)
