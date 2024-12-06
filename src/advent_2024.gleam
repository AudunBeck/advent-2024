import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let task_path = "./inputs/1.txt"
  let assert Ok(input) = simplifile.read(from: task_path)
  let splitstring =
    input
    |> string.split("\n")
  let Day1Input(left_list, right_list) = split_line(splitstring, [], [])

  let output =
    list.zip(
      list.sort(left_list, int.compare),
      list.sort(right_list, int.compare),
    )
    |> list.fold(0, fn(accumulator, lists) {
      accumulator + int.absolute_value(lists.0 - lists.1)
    })
  io.debug(output)
}

type Day1Input {
  Day1Input(left_list: List(Int), right_list: List(Int))
}

fn print_list(list: List(Int)) {
  case list {
    [first, ..rest] -> {
      io.debug(first)
      print_list(rest)
    }
    [] -> io.println("finished")
  }
}

fn split_line(
  main_list: List(String),
  left_list: List(Int),
  right_list: List(Int),
) -> Day1Input {
  case main_list {
    [first, ..rest] -> {
      case string.split(first, "   ") {
        [a, b] -> {
          let assert Ok(left) = int.parse(a)
          let assert Ok(right) = int.parse(b)
          split_line(rest, [left, ..left_list], [right, ..right_list])
        }
        _ -> Day1Input(left_list, right_list)
      }
    }
    [] -> Day1Input(left_list, right_list)
  }
}
