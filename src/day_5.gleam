import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn part_1() {
  let task_path = "./inputs/5.txt"
  let assert Ok(input) = simplifile.read(from: task_path)
  let parsed = parse(input)
  check_prints(parsed.rules, parsed.prints, 0)
}

fn parse(input: String) {
  let line_split = string.split(input, "\n")
  rules_print(line_split, Day5Input([], []), False)
}

fn check_prints(
  rules: List(#(Int, Int)),
  prints: List(List(Int)),
  sum: Int,
) -> Int {
  case prints {
    [first, ..rest] -> {
      check_prints(rules, rest, sum + check_rules(rules, first))
    }
    [] -> sum
  }
}

fn check_rules(rules: List(#(Int, Int)), print: List(Int)) -> Int {
  case rules {
    [rule, ..rest] -> {
      case check_one(rule, print) {
        True -> check_rules(rest, print)
        False -> {
          0
        }
      }
    }
    [] -> find_middle(print)
  }
}

fn find_middle(print: List(Int)) -> Int {
  print
  |> list.drop(list.length(print) / 2)
  |> list.first
  |> result.unwrap(0)
}

fn check_one(rule: #(Int, Int), print: List(Int)) -> Bool {
  let #(rule1, rule2) = rule
  let check =
    list.combination_pairs(print)
    |> list.fold_until(0, fn(_acc, i) {
      case i {
        rule_case if rule_case == #(rule2, rule1) -> list.Stop(1)

        _ -> list.Continue(0)
      }
    })
  check == 0
}

pub type Day5Input {
  Day5Input(rules: List(#(Int, Int)), prints: List(List(Int)))
}

fn rules_print(list: List(String), output: Day5Input, flip: Bool) -> Day5Input {
  case flip {
    False -> {
      case list {
        [first, ..rest] if first == "" -> rules_print(rest, output, True)
        [first, ..rest] -> {
          let #(rule1, rule2) =
            result.unwrap(string.split_once(first, "|"), #("0", "0"))
          let rule = #(
            result.unwrap(int.parse(rule1), 0),
            result.unwrap(int.parse(rule2), 0),
          )
          rules_print(
            rest,
            Day5Input(rules: [rule, ..output.rules], prints: output.prints),
            False,
          )
        }
        [] -> Day5Input(rules: output.rules, prints: output.prints)
      }
    }
    True -> {
      case list {
        [first, ..rest] -> {
          let print =
            string.split(first, on: ",")
            |> list.map(fn(x) {
              case int.parse(x) {
                Ok(number) -> number
                Error(_) -> 0
              }
            })
          rules_print(
            rest,
            Day5Input(rules: output.rules, prints: [print, ..output.prints]),
            True,
          )
        }
        [] -> Day5Input(rules: output.rules, prints: output.prints)
      }
    }
  }
}
