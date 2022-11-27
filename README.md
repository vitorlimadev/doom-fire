# DoomFire

![DOOM Fire gif](./doom-fire.gif)

A functional recursive version of the famous DOOM fire graphics algorithm.

This implementation is much slower than the original since it relies on imutable data structures only.
I did this for fun and didn't want to use any advantages of OTP such as Genservers, Agents or anything that handles state. Just functions.
There's definitely a lot of room for improvement so feel free to open a PR.

## Installation

You need to have both erlang and elixir installed, the project itself has no dependencies.

To start, run:

```bash
iex -S mix
```

```elixir
DoomFire.light
```

To have a flame 50 pixels wide (like the gif).
You can also set the flame width as params:

```elixir
DoomFire.light 80
```
