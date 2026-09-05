# KronosUI mirrored assets

Vendored from `Skinny-yz/NullUI-Assets` (the `KronosUI-Assets` URLs in `Lib.lua` do not resolve — 404).

| File | Upstream size | SHA (blob) |
|---|---|---|
| `fonts/Figtree-Medium.ttf` | 40148 | `5b89c890` |
| `fonts/Figtree-SemiBold.ttf` | 40360 | `aa2b78c2` |
| `icons/LucideIcons.luau` | 56002 | `a16951d4` |
| `icons/MaterialIcons.luau` | 46723 | `46acf5ea` |
| `icons/Phosphor.luau` | 52420 | `ed523720` |
| `icons/Phosphor Filled.luau` | 54175 | `dbd1f05a` |
| `icons/SFSymbols.luau` | 130005 | `a2f80842` |

To self-host: push this folder to a public repo (e.g. `Doran342545345/KronosUI-Assets`
with the same `fonts/` + `icons/` layout), then point `Lib.lua` at it —
the `IconSources` table and the fonts `base` string at the top of the file.
