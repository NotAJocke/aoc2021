import gleam/int
import gleam/list
import gleam/string
import simplifile

import solution.{type AocSolution, type Mode}

type State {
  State(pos: Int, depth: Int)
}

fn update_state(state: State, instruction: String) -> State {
  let assert Ok(#(command, val_str)) = string.split_once(instruction, on: " ")
  let assert Ok(val) = int.parse(val_str)

  case command {
    "forward" -> State(..state, pos: state.pos + val)
    "down" -> State(..state, depth: state.depth + val)
    "up" -> State(..state, depth: state.depth - val)
    other -> panic as { "Unknown command : " <> other }
  }
}

pub fn part1(mode: Mode) -> AocSolution {
  let state =
    get_input(mode)
    |> string.split(on: "\n")
    |> list.fold(State(pos: 0, depth: 0), update_state)

  solution.Number(state.pos * state.depth)
}

// ---------------------------

type State2 {
  State2(pos: Int, depth: Int, aim: Int)
}

fn update_state2(s: State2, instruction: String) -> State2 {
  let assert Ok(#(command, val_str)) = string.split_once(instruction, on: " ")
  let assert Ok(val) = int.parse(val_str)

  case command {
    "down" -> State2(..s, aim: s.aim + val)
    "up" -> State2(..s, aim: s.aim - val)
    "forward" -> State2(..s, pos: s.pos + val, depth: s.depth + s.aim * val)
    other -> panic as { "Unknown command : " <> other }
  }
}

pub fn part2(mode: Mode) -> AocSolution {
  let state =
    get_input(mode)
    |> string.split(on: "\n")
    |> list.fold(State2(0, 0, 0), update_state2)

  solution.Number(state.pos * state.depth)
}

fn get_input(mode: Mode) -> String {
  case mode {
    solution.Test -> test_input()
    solution.Real -> real_input()
  }
}

fn test_input() -> String {
  "forward 5
down 5
forward 8
up 3
down 8
forward 2"
}

fn real_input() -> String {
  let filepath = "./inputs/day02.txt"
  let assert Ok(input) = simplifile.read(filepath)

  input
}
