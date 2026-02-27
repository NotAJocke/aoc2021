import gleam/int

pub type Mode {
  Test
  Real
}

pub type AocSolution {
  Text(String)
  Number(Int)
}

pub fn to_string(r: AocSolution) -> String {
  case r {
    Text(s) -> s
    Number(i) -> int.to_string(i)
  }
}
