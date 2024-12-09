import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn part_1() {
  let task_path = "./inputs/3.txt"
  let assert Ok(input) = simplifile.read(from: task_path)
  let mul_split = string.split(input, on: "mul(")
  let sum = find_numbers(mul_split, 0)
  io.debug(sum)
}

pub fn part_2() {
  let task_path = "./inputs/3.txt"
  let assert Ok(input) = simplifile.read(from: task_path)
  let do_start = string.append("do()", input)
  let do_dont_split =
    string.split(do_start, on: "don't()")
    |> list.map(fn(x) {
      case string.split_once(x, "do()") {
        Ok(out) -> {
          out.1
        }
        Error(_) -> ""
      }
    })
    |> string.join(with: "")
  let mul_split = string.split(do_dont_split, on: "mul(")
  let sum = find_numbers_do(mul_split, 0)
  io.debug(sum)
}

fn find_numbers_do(list: List(String), sum: Int) -> Int {
  case list {
    [first, ..rest] -> {
      let number = case string.split_once(first, on: ")") {
        Ok(out) -> {
          let multiplied = case string.split_once(out.0, on: ",") {
            Ok(split) -> {
              let num_1 = result.unwrap(int.parse(split.0), 0)
              let num_2 = result.unwrap(int.parse(split.1), 0)
              num_1 * num_2
            }
            Error(_) -> 0
          }
          multiplied
        }
        Error(_) -> 0
      }
      find_numbers(rest, sum + number)
    }
    [] -> sum
  }
}

fn find_numbers(list: List(String), sum: Int) -> Int {
  case list {
    [first, ..rest] -> {
      let number = case string.split_once(first, on: ")") {
        Ok(out) -> {
          let multiplied = case string.split_once(out.0, on: ",") {
            Ok(split) -> {
              let num_1 = result.unwrap(int.parse(split.0), 0)
              let num_2 = result.unwrap(int.parse(split.1), 0)
              num_1 * num_2
            }
            Error(_) -> 0
          }
          multiplied
        }
        Error(_) -> 0
      }
      find_numbers(rest, sum + number)
    }
    [] -> sum
  }
}
