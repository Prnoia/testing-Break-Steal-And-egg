# EggHub v1 — Roblox Studio learning scaffold

This package contains a Luau UI and a small scanner for a Roblox experience you own or are authorized to develop.

## Install
1. Open your own experience in Roblox Studio.
2. In Explorer, open `StarterPlayer > StarterPlayerScripts`.
3. Insert a `LocalScript`.
4. Copy the contents of `src/main.lua` into that LocalScript.
5. Press Play.

## Scanner setup
The Scanner page searches `BasePart` instances tagged `Egg` using `CollectionService`.
In Studio, select your egg parts and add the `Egg` tag through the Tag Editor.

## Important limitations
- This is not a Delta Executor script or a `loadstring` loader.
- It does not work as a cheat in Break and Steal an Egg.
- It does not inspect hidden objects in other games, automate stealing, teleport, or bypass server protections.
- Farming buttons are demo toggles only; implement game mechanics on the server in your own experience.
