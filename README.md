# DoomFire

![DOOM Fire gif](./doom-fire.gif)

A functional recursive version of the famous DOOM fire graphics algorithm.

## Installation

You need to have both erlang and elixir installed, the project itself has no dependencies.

To start, run:

```bash
iex -S mix
```

```elixir
DoomFire.light
```

To have a flame 40 pixels tall and 40 pixels wide (like the gif).
You can set the flame width and height as params.

```elixir
DoomFire.light 50, 100 # height, width
```
