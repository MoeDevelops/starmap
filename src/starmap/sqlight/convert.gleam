import gleam/list
import gleam/string
import starmap/insertion.{type Insertion}
import starmap/query.{type Query}
import starmap/schema.{type Column}

fn format_column(column: Column(a, value)) -> String {
  column.table <> "." <> column.name
}

pub fn query1(query: Query(t_table, Column(a, value), t_wheres)) -> String {
  "SELECT " <> format_column(query.columns) <> "
  FROM " <> query.table.name
}

pub fn query3(
  query: Query(
    t_table,
    #(Column(a, value), Column(b, value), Column(c, value)),
    t_wheres,
  ),
) -> String {
  let #(column1, column2, column3) = query.columns

  "SELECT "
  <> [format_column(column1), format_column(column2), format_column(column3)]
  |> string.join(", ")
  <> "
  FROM "
  <> query.table.name
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
