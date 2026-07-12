# dojo-obby

dojo-obby is a dojo-themed Roblox obby with working levels, checkpoint-based progression, server-side spawn and stats handling, and a small Fusion-driven client UI for settings, the store, and stage-skipping.

This project shows full-stack Roblox game development rather than just simple scripting. It combines place content, gameplay logic, UI, data flow, and reusable server components into one playable experience that is easy to open, explore, and evaluate.

## Why It Matters

The project demonstrates the kinds of skills that matter in a real game or engine-adjacent codebase:

- Gameplay systems that persist player progress through checkpoints and leaderstats.
- Server-authoritative logic for spawning, hazards, and component timing.
- A modular component architecture that attaches behavior to tagged in-game assets.
- Client UI built with Fusion and shared state instead of hard-coded screens.
- A finished, themed experience that can be explored directly in Roblox Studio.

## Overview

The experience is organized as a conventional Roblox game project:

- `src/Server` handles player initialization, stats, spawning, component timing, and gameplay logic.
- `src/Client` builds the in-game UI and reacts to stage updates, checkpoint notifications, and purchase prompts.
- `src/Shared` contains shared state, UI composition, assets, and reusable modules.
- `assets` stores place content such as terrain, lighting, workspace models, and server storage assets.
- `Packages` contains third-party dependencies managed with Wally.

Notable gameplay systems include:

- Leaderstats for `Stage` and `Wins`.
- Respawning players at the correct checkpoint.
- A checkpoint notification sequence with sound and animation.
- A skip-stage product prompt.
- Component-based server obstacles and interactive hazards.

The levels are built to feel like a structured dojo course rather than a random obstacle chain. Players move through a sequence of themed stages, each one acting as a working checkpoint in the course, so progress is saved as they advance and respawns return them to the correct stage. The result is a more deliberate obby loop where the dojo setting and the level system work together as part of the experience.

The gameplay objects are driven by an object-oriented component pattern. Individual in-game assets, such as a checkpoint model or a kill brick, are tagged in the place and then turned into component instances by the server. Each component owns the behavior for the asset it is attached to: it reads the model or part stored in `self.Instance`, initializes per-asset state in `Construct`, starts behavior in `Start`, and cleans up connections in `Stop`. That keeps the asset itself as the data source while the component becomes the object-like controller for its runtime behavior.

## Requirements

- Roblox Studio
- Aftman
- Wally
- Rojo-compatible tooling used by the project, including Lync
- Windows is the primary setup reflected by the bundled scripts

## Setup

1. Install the tools defined in `aftman.toml`.

   ```powershell
   aftman install
   ```

2. Fetch project dependencies.

   ```powershell
   wally install
   ```

3. Open the place through the project workflow you prefer. The repo is configured for Lync using `lync.project.json` on port `34873`.

## Development

The repository includes a few Windows helper scripts under `BuildScripts`:

- `BuildScripts/Win_Sync.bat` starts Lync in sync-only mode on port `34873`.
- `BuildScripts/Win_Build.bat` starts the normal build flow.
- `BuildScripts/Win_BuildOffline.bat` runs the offline build flow.

The generated build file referenced by Lync is `BuildScripts/Build/Build.rbxl`.

## Project Structure

```text
src/
  Client/
  Server/
  Shared/
assets/
  Lighting/
  ServerStorage/
  Workspace/
BuildScripts/
Packages/
```

## Tooling

- `selene.toml` configures Lua linting.
- `wally.toml` defines package dependencies.
- `tarmac.toml` and `tarmac-manifest.toml` manage image asset publishing/codegen.
- `rojo.project.json` and `lync.project.json` define the Roblox project tree and sync/build configuration.

## Notes

- The server creates `leaderstats` for each player and keeps stage respawns aligned with the current checkpoint.
- The client UI is assembled from Fusion components and shared state.
- Server components attach behavior to tagged Roblox assets, which is why obstacles and checkpoints stay modular even though they live as place objects.
- Game content under `assets` is part of the place, not source code, so changes there affect the live Roblox experience directly.