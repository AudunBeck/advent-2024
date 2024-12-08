import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn part_1() {
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

pub fn part_2() {
  let task_path = "./inputs/1.txt"
  let assert Ok(input) = simplifile.read(from: task_path)
  let splitstring =
    input
    |> string.split("\n")
  let Day1Input(left_list, right_list) = split_line(splitstring, [], [])
  let total_score = similarity(left_list, right_list, 0)
  io.debug(total_score)
}

fn similarity(left_list: List(Int), right_list: List(Int), total: Int) -> Int {
  case left_list {
    [first, ..rest] -> {
      let score = check_number(first, right_list, 0)
      similarity(rest, right_list, total + score)
    }
    [] -> total
  }
}

fn check_number(number: Int, list: List(Int), total: Int) -> Int {
  case list {
    [first, ..rest] -> {
      case number == first {
        True -> check_number(number, rest, total + number)
        False -> check_number(number, rest, total)
      }
    }
    [] -> total
  }
}

pub type Day1Input {
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
