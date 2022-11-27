defmodule DoomFire do
  @moduledoc """
  Recursively creates a matrix of tuples as {intensity, index}.
  This matrix is then rendered with ANSI colors according to the
  curret intensity.
  """

  # Interval per render. 16ms = ~60fps
  @sleep_ms 16

  # Higher decay = Smaller flames
  @decay 0..3

  @color_pallete {
    IO.ANSI.black_background(),
    IO.ANSI.color_background(52),
    IO.ANSI.color_background(88),
    IO.ANSI.color_background(89),
    IO.ANSI.color_background(89),
    IO.ANSI.color_background(90),
    IO.ANSI.color_background(132),
    IO.ANSI.color_background(130),
    IO.ANSI.color_background(167),
    IO.ANSI.color_background(167),
    IO.ANSI.color_background(196),
    IO.ANSI.color_background(196),
    IO.ANSI.color_background(196),
    IO.ANSI.color_background(202),
    IO.ANSI.color_background(202),
    IO.ANSI.color_background(203),
    IO.ANSI.color_background(160),
    IO.ANSI.color_background(160),
    IO.ANSI.color_background(160),
    IO.ANSI.color_background(162),
    IO.ANSI.color_background(162),
    IO.ANSI.color_background(166),
    IO.ANSI.color_background(167),
    IO.ANSI.color_background(168),
    IO.ANSI.color_background(178),
    IO.ANSI.color_background(178),
    IO.ANSI.color_background(179),
    IO.ANSI.color_background(179),
    IO.ANSI.color_background(180),
    IO.ANSI.color_background(142),
    IO.ANSI.color_background(142),
    IO.ANSI.color_background(144),
    IO.ANSI.color_background(185),
    IO.ANSI.color_background(228),
    IO.ANSI.color_background(229),
    IO.ANSI.color_background(231),
    IO.ANSI.color_background(231)
  }

  def light do
    light(50)
  end

  def light(width) do
    Application.put_env(:elixir, :ansi_enabled, true)
    {:ok, io_height} = :io.rows()

    list_length = width * (io_height - 5)
    starting_list = build_initial_fire_list(list_length, width)

    recurse_fire_propagation(starting_list, width)
  end

  defp build_initial_fire_list(list_length, width) do
    collor_pallete_length = length(Tuple.to_list(@color_pallete)) - 1

    Enum.reduce(1..list_length, [], fn i, acc ->
      # Adds 0 to all of the pixels except the ones on the bottom row.
      # Those have the highest intensity and will serve as the fire starter.
      if i > list_length - width do
        acc ++ [collor_pallete_length]
      else
        acc ++ [0]
      end
    end)
    |> Enum.with_index()
  end

  defp recurse_fire_propagation(fire_tuple_list, width) do
    new_fire_tuple =
      Enum.map(fire_tuple_list, fn {_value, i} = pixel_tuple ->
        pixel_below_index = i + width

        pixel_below = Enum.at(fire_tuple_list, pixel_below_index)
        decay = Enum.random(@decay)

        case pixel_below do
          nil ->
            pixel_tuple

          {below_value, _} ->
            if below_value - decay >= 0 do
              {below_value - decay, i}
            else
              pixel_tuple
            end
        end
      end)

    render_fire(new_fire_tuple, width)
    Process.sleep(@sleep_ms)

    recurse_fire_propagation(new_fire_tuple, width)
  end

  defp render_fire(fire_list, width) do
    IEx.Helpers.clear()

    columns = Enum.chunk_every(fire_list, width)

    Enum.map(columns, fn row ->
      Enum.map(row, fn {intensity, _index} ->
        IO.ANSI.format_fragment([elem(@color_pallete, intensity), "  "])
      end)
      |> IO.puts()
    end)

    print_last_black_character()
  end

  defp print_last_black_character do
    # The last pixel of the fire render is a white pixel.
    # Terminal emulators tend to user the last declared ANSI background color in the whole screen.
    # This is just to add a last black pixel to make sure the background is black.
    [IO.ANSI.black_background(), "\n"]
    |> IO.ANSI.format_fragment()
    |> IO.puts()
  end
end
