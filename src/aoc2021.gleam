import gleam/int
import gleam/io
import gleam/result

import argv

import days/day01
import days/day02
import solution.{type Mode, Real, Test}

pub fn main() -> Nil {
  let args = argv.load().arguments

  let parsed: Result(#(Mode, Int), String) = case args {
    [mode, day_str] if mode == "test" || mode == "real" -> {
      let mode = case mode {
        "test" -> Test
        _ -> Real
      }

      int.parse(day_str)
      |> result.map(fn(day) { #(mode, day) })
      |> result.replace_error("Invalid number day")
    }

    _ -> Error("Usage: gleam run <test|real> <day_number>")
  }

  case parsed {
    Ok(#(mode, 1)) -> {
      let part1 = day01.part1(mode)
      let part2 = day01.part2(mode)

      io.println("Part 1 result: " <> solution.to_string(part1))
      io.println("Part 2 result: " <> solution.to_string(part2))
    }
    Ok(#(mode, 2)) -> {
      let part1 = day02.part1(mode)
      let part2 = day02.part2(mode)

      io.println("Part 1 result: " <> solution.to_string(part1))
      io.println("Part 2 result: " <> solution.to_string(part2))
    }
    Ok(#(_, x)) ->
      io.println("Day " <> int.to_string(x) <> " not implemented yet")
    Error(e) -> io.println(e)
  }
}
