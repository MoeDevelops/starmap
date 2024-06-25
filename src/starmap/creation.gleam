import gleam/string_builder
import starmap/schema.{type Column, type Table}

pub type Creation

pub fn create_table3(
  table: Table(a),
  column1: Column(c, d),
  column2: Column(e, f),
  column3: Column(g, h),
) -> String {
  string_builder.new()
  |> string_builder.append("CREATE TABLE " <> table.name <> " (")
  |> string_builder.append(convert_column(column1) <> ", ")
  |> string_builder.append(convert_column(column2) <> ", ")
  |> string_builder.append(convert_column(column3))
  |> string_builder.append(");")
  |> string_builder.to_string()
}

fn convert_column(column: Column(a, b)) -> String {
  column.name <> " " <> column.column_type().name
}
