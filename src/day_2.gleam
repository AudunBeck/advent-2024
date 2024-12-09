import gleam/int
import gleam/list
import gleam/string
import simplifile

pub fn part_1() {
  let task_path = "./inputs/2.txt"
  let assert Ok(input) = simplifile.read(from: task_path)
  let splitstring =
    input
    |> string.split("\n")
    |> list.map(fn(x) { string.split(x, " ") })
    |> list.map(fn(x) {
      list.map(x, fn(y) {
        case int.parse(y) {
          Ok(number) -> number
          Error(_) -> 0
        }
      })
    })
  levels(splitstring, 0, False)
}

pub fn part_2() {
  let task_path = "./inputs/2.txt"
  let assert Ok(input) = simplifile.read(from: task_path)
  let splitstring =
    input
    |> string.split("\n")
    |> list.map(fn(x) { string.split(x, " ") })
    |> list.map(fn(x) {
      list.map(x, fn(y) {
        case int.parse(y) {
          Ok(number) -> number
          Error(_) -> 0
        }
      })
    })
  levels(splitstring, 0, True)
}

fn levels(list: List(List(Int)), sum: Int, safe: Bool) -> Int {
  case list {
    [first, ..rest] -> {
      case reports(first, -1, 0, safe) {
        True -> levels(rest, sum + 1, safe)

        False -> levels(rest, sum, safe)
      }
    }
    [] -> sum
  }
}

fn reports(list: List(Int), last_number: Int, dir: Int, safe: Bool) -> Bool {
  case list {
    [0] -> False
    [first, ..rest] -> {
      case last_number {
        -1 -> reports(rest, first, 0, safe)
        _ -> {
          case last_number - first {
            i if i < 4 && i > 0 && dir >= 0 -> {
              reports(rest, first, 1, safe)
            }
            i if i < 0 && i > -4 && dir <= 0 -> {
              reports(rest, first, -1, safe)
            }
            _ if safe == True -> {
              reports(rest, first, dir, False)
            }
            _ -> False
          }
        }
      }
    }
    [] -> True
  }
}
