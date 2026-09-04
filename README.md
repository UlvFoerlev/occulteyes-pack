# OccultEyes Create Modpack

Minecraft 1.21.1 · NeoForge 21.1.249 · 122 mods

Auto-updating [packwiz](https://packwiz.infra.link/) pack. This repo holds **metadata only** —
mods are downloaded by each client from CurseForge and Modrinth directly.

## Installing (for players)

Send them `OccultEyes-Create-Modpack-<version>.mrpack` (~800 KB) and these two steps:

1. **ATLauncher → Add Instance → Import → select the .mrpack.**
   This installs Minecraft 1.21.1 and NeoForge 21.1.249 and drops in the updater.
2. **Edit Instance → Settings → Commands tab.** Set **"Enable commands?"** to **Yes**
   (it defaults to "Use Launcher Default", which means off), and paste into
   **"Pre-launch command"**:

   ```
   "$INST_JAVA" -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/UlvFoerlev/occulteyes-pack/main/pack.toml
   ```

Then press Play. The first launch pulls ~230 MB of mods and configs before Minecraft
starts; after that every launch checks for updates automatically.

The same instructions are inside the mrpack as `SETUP-README.txt`, which lands in the
instance folder where they will see it.

ATLauncher supplies its own Java runtime, so nothing else needs installing.

> **Do not post the .mrpack publicly.** It bundles Create: Shimmer and Builders' Jetpack,
> which CurseForge will not serve over its API and whose licenses do not permit
> redistribution. Handing it to a specific person is fine; publishing it is not.

### Rebuilding the mrpack

`./tools/build-mrpack.sh` reads the versions out of `pack.toml`, so it stays correct
when the loader or pack version changes. Override the URL if the repo is named
differently:

```sh
PACK_URL=https://raw.githubusercontent.com/UlvFoerlev/occulteyes-pack/main/pack.toml ./tools/build-mrpack.sh
```

## Updating the pack (maintainer)

```sh
cd ~/Documents/occulteyes-pack
# add a CurseForge mod
packwiz cf add <slug>
# add a Modrinth mod
packwiz mr add <slug>
# after editing configs or dropping in files manually
packwiz refresh
git commit -am "describe change" && git push
```

Players get it on their next launch. No zip, no reinstall.

## Notes

- `.packwizignore` excludes per-client settings (Sodium, Xaero, Iris, keybinds) so they are
  not overwritten on other people's machines.
- `mods/occulteyes-tweaks-*.jar` is the one jar hosted here directly; it is our own mod.
- Mod versions are pinned. `packwiz update <mod>` bumps one; `packwiz update --all` bumps everything.
