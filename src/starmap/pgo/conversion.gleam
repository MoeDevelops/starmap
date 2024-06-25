import gleam/list
import gleam/string
import starmap/query.{type Query, type Select}

pub fn convert_query(query: Query(a)) {
  "
  SELECT " <> selects_to_string(query.selects) <> "
  FROM " <> query.table <> "
  "
}

fn selects_to_string(selects: List(Select)) -> String {
  selects
  |> list.map(fn(x) { x.table <> "." <> x.column })
  |> string.join(", ")
}
