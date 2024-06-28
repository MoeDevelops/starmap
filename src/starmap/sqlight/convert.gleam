import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import gleam/string_builder.{type StringBuilder, append}
import starmap/creation.{type CreateTable}
import starmap/insertion.{type Insertion}
import starmap/query.{type Query}
import starmap/schema.{type Column}

fn append_line(builder: StringBuilder, s: String) -> StringBuilder {
  builder
  |> append(s)
  |> append("\n")
}

fn format_column(column: Column(a, value)) -> String {
  column.table <> "." <> column.name
}

fn format_column_create_table(column: Column(a, b)) -> String {
  column.name <> " " <> column.column_type().name
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

  let builder =
    string_builder.new()
    |> append("SELECT ")
    |> append_line(
      [format_column(column1), format_column(column2), format_column(column3)]
      |> string.join(", "),
    )
    |> append("FROM ")
    |> append_line(query.table.name)

  let builder = case query.limit {
    Some(limit) ->
      builder
      |> append("LIMIT " <> int.to_string(limit))
      |> append("\n")
    None -> builder
  }

  builder
  |> string_builder.to_string()
}

pub fn create_table3(
  create_table: CreateTable(
    t_table,
    #(Column(a, value), Column(b, value), Column(c, value)),
  ),
) -> String {
  let #(column1, column2, column3) = create_table.columns

  string_builder.new()
  |> append("CREATE TABLE ")
  |> append(create_table.table.name)
  |> append_line(" (")
  |> append(format_column_create_table(column1))
  |> append_line(", ")
  |> append(format_column_create_table(column2))
  |> append_line(", ")
  |> append(format_column_create_table(column3))
  // 'STRICT' enforces type-safety in the table
  |> append(") STRICT;")
  |> string_builder.to_string()
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
