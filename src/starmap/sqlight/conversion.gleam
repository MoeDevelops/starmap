import gleam/list
import gleam/string
import starmap/insertion.{type Insertion}
import starmap/query.{type Query}
import starmap/schema.{type Column}

pub fn query(query: Query(a)) -> String {
  "
  SELECT " <> query.selects
  |> list.map(fn(x) { x.table <> "." <> x.column })
  |> string.join(", ") <> "
  FROM " <> query.table <> "
  "
}

pub fn insertion3(
  insertion: Insertion(#(Column(a, b), Column(c, d), Column(e, f)), #(a, c, e)),
) -> String {
  let #(column1, column2, column3) = insertion.columns

  "
  INSERT INTO " <> insertion.table <> "
  (" <> column1.name <> ", " <> column2.name <> ", " <> column3.name <> ")
  VALUES
  " <> insertion.values
  |> list.map(fn(_) { "(?, ?, ?)" })
  |> string.join(", ")
}
