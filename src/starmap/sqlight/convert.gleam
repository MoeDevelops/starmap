import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/string_builder.{type StringBuilder, append}
import starmap/creation.{type CreateTable}
import starmap/insertion.{type Insertion}
import starmap/query.{
  type ConvertedWhere, type ConvertedWhereColumns, type Query, type TableColumn,
  ConvertedColumnValue, ConvertedColumns, ConvertedEqual, ConvertedGreater,
  ConvertedGreaterOrEqual, ConvertedIsNotNull, ConvertedIsNull, ConvertedLower,
  ConvertedLowerOrEqual, ConvertedNotEqual, ConvertedOr, TableColumn,
}
import starmap/schema.{type Column, PrimaryKey}

fn append_line(builder: StringBuilder, s: String) -> StringBuilder {
  builder
  |> append(s <> "\n")
}

fn append_comma_line(builder: StringBuilder, s: String) -> StringBuilder {
  builder
  |> append(s <> ",\n")
}

fn add_limit(builder: StringBuilder, limit: Option(Int)) -> StringBuilder {
  case limit {
    Some(limit) ->
      builder
      |> append("LIMIT " <> int.to_string(limit))
      |> append("\n")
    None -> builder
  }
}

fn add_where(
  builder: StringBuilder,
  wheres: List(ConvertedWhere(value)),
) -> StringBuilder {
  case wheres {
    [] -> builder
    _ ->
      builder
      |> append("WHERE ")
      |> append(
        wheres
        |> list.map(convert_where_in_add_where)
        |> string.join("\nAND "),
      )
  }
}

fn convert_where_in_add_where(where: ConvertedWhere(value)) -> String {
  case where {
    ConvertedEqual(columns) -> convert_where_columns(columns, "=")
    ConvertedNotEqual(columns) -> convert_where_columns(columns, "!=")
    ConvertedIsNull(table_column) ->
      format_table_column(table_column) <> " IS NULL"
    ConvertedIsNotNull(table_column) ->
      format_table_column(table_column) <> " IS NOT NULL"
    ConvertedGreater(columns) -> convert_where_columns(columns, ">")
    ConvertedGreaterOrEqual(columns) -> convert_where_columns(columns, ">=")
    ConvertedLower(columns) -> convert_where_columns(columns, "<")
    ConvertedLowerOrEqual(columns) -> convert_where_columns(columns, "<=")
    ConvertedOr(where1, where2) ->
      "("
      <> convert_where_in_add_where(where1)
      <> " OR "
      <> convert_where_in_add_where(where2)
      <> ")"
  }
}

fn convert_where_columns(
  where_columns: ConvertedWhereColumns(value),
  operator: String,
) {
  case where_columns {
    ConvertedColumnValue(table_column, _) ->
      format_table_column(table_column) <> " " <> operator <> " ?"
    ConvertedColumns(table_column1, table_column2) ->
      format_table_column(table_column1)
      <> " "
      <> operator
      <> " "
      <> format_table_column(table_column2)
  }
}

fn format_column(column: Column(a, value)) -> String {
  column.table <> "." <> column.name
}

fn format_table_column(table_column: TableColumn) -> String {
  table_column.table <> "." <> table_column.column
}

fn filter_primary_key(column: Column(a, value)) -> Option(String) {
  case column.arguments |> list.contains(PrimaryKey) {
    True -> Some(column.name)
    False -> None
  }
}

fn add_primary_keys(columns: List(Option(String))) -> String {
  case columns |> list.is_empty() {
    True -> ""
    False ->
      ",\nPRIMARY KEY ("
      <> columns
      |> list.filter(option.is_some)
      |> list.map(fn(x) { option.unwrap(x, "") })
      |> string.join(",")
      <> ")"
  }
}

fn format_column_create_table(column: Column(a, b)) -> String {
  let column_type = column.column_type()

  let builder =
    string_builder.new()
    |> append(column.name <> " ")
    |> append(column_type.name <> " ")

  let builder = case column_type.nullable {
    False ->
      builder
      |> append("NOT NULL ")
    True -> builder
  }

  builder
  |> string_builder.to_string()
  |> string.trim_right()
}

pub fn query1(query: Query(Column(a, value), t_wheres)) -> String {
  "SELECT " <> format_column(query.columns) <> "
  FROM " <> query.table
}

pub fn query3(
  query: Query(
    #(Column(a, value), Column(b, value), Column(c, value)),
    t_wheres,
  ),
) -> String {
  let #(column1, column2, column3) = query.columns

  string_builder.new()
  |> append("SELECT ")
  |> append_line(
    [format_column(column1), format_column(column2), format_column(column3)]
    |> string.join(", "),
  )
  |> append("FROM ")
  |> append_line(query.table)
  |> add_where(query.wheres)
  |> add_limit(query.limit)
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
  |> append_line("CREATE TABLE " <> create_table.table <> " (")
  |> append_comma_line(format_column_create_table(column1))
  |> append_comma_line(format_column_create_table(column2))
  |> append(format_column_create_table(column3))
  // 'STRICT' enforces type-safety in the table
  |> append_line(
    add_primary_keys([
      filter_primary_key(column1),
      filter_primary_key(column2),
      filter_primary_key(column3),
    ]),
  )
  |> append(") STRICT;")
  |> string_builder.to_string()
}

pub fn insertion2(
  insertion: Insertion(#(Column(a, value), Column(b, value)), #(a, b)),
) -> String {
  let #(column1, column2) = insertion.columns

  "
  INSERT INTO " <> insertion.table <> "
  (" <> column1.name <> ", " <> column2.name <> ")
  VALUES
  " <> insertion.values
  |> list.map(fn(_) { "(?, ?)" })
  |> string.join(", ")
}

pub fn insertion3(
  insertion: Insertion(
    #(Column(a, value), Column(b, value), Column(c, value)),
    #(a, b, c),
  ),
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
