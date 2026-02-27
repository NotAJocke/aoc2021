import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile
import solution.{type AocSolution, type Mode, Number, Real, Test}

type MeasurementVariation {
  Increase(Int)
  Decrease(Int)
  Initial(Int)
}

fn interpret_list(list: List(Int)) -> List(MeasurementVariation) {
  let assert [first, ..rest] = list

  interpret_list_acc(rest, [Initial(first)])
}

fn interpret_list_acc(
  list: List(Int),
  acc: List(MeasurementVariation),
) -> List(MeasurementVariation) {
  case list {
    [] -> acc
    [head, ..tail] -> {
      let assert [previous, ..] = acc
      let previous = case previous {
        Increase(x) -> x
        Decrease(x) -> x
        Initial(x) -> x
      }

      case head - previous > 0 {
        True -> interpret_list_acc(tail, [Increase(head), ..acc])

        False -> interpret_list_acc(tail, [Decrease(head), ..acc])
      }
    }
  }
}

pub fn part1(mode: Mode) -> AocSolution {
  let input = case mode {
    Test -> test_input()
    Real -> real_input()
  }

  let count =
    input
    |> string.trim
    |> string.split(on: "\n")
    |> list.map(fn(x) { result.unwrap(int.parse(x), -1) })
    |> interpret_list
    |> list.count(fn(x) {
      case x {
        Increase(_) -> True
        _ -> False
      }
    })

  Number(count)
}

pub fn part2(mode: Mode) -> AocSolution {
  let input = case mode {
    Test -> test_input()
    Real -> real_input()
  }

  let count =
    input
    |> string.trim
    |> string.split(on: "\n")
    |> list.filter_map(int.parse)
    |> list.window(4)
    |> list.count(fn(lst) {
      case lst {
        [first, _, _, fourth, ..] if first < fourth -> True
        _ -> False
      }
    })

  Number(count)
}

fn test_input() -> String {
  "199
200
208
210
200
207
240
269
260
263"
}

fn real_input() -> String {
  let filepath = "./inputs/day01.txt"
  let assert Ok(input) = simplifile.read(filepath)

  input
}
