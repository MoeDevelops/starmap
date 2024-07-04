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
import starmap/schema.{type Column, ForeignKey, PrimaryKey}

// StringBuilder

fn append_line(builder: StringBuilder, s: String) -> StringBuilder {
  builder
  |> append(s <> "\n")
}

fn append_comma_line(builder: StringBuilder, s: String) -> StringBuilder {
  builder
  |> append(s <> ",\n")
}

// Adding

fn add_query_args(
  builder: StringBuilder,
  query: Query(t_columns, t_wheres),
) -> StringBuilder {
  builder
  |> add_from(query.table)
  |> add_where(query.wheres)
  |> add_limit(query.limit)
  |> add_order_by(query.order_by)
  |> add_group_by(query.group_by)
}

fn add_select(builder: StringBuilder, columns: List(String)) -> StringBuilder {
  builder
  |> append("SELECT ")
  |> append_line(columns |> string.join(", "))
}

fn add_from(builder: StringBuilder, table: String) {
  builder
  |> append("FROM ")
  |> append_line(table)
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

fn add_order_by(
  builder: StringBuilder,
  order_bys: List(#(TableColumn, String)),
) -> StringBuilder {
  case order_bys {
    [] -> builder
    _ ->
      builder
      |> append("ORDER BY ")
      |> append_line(
        order_bys
        |> list.map(fn(x) {
          let #(table_column, mod) = x

          format_table_column(table_column) <> " " <> mod
        })
        |> string.join(", "),
      )
  }
}

fn add_group_by(builder: StringBuilder, group_bys: List(TableColumn)) {
  case group_bys {
    [] -> builder
    _ ->
      builder
      |> append("GROUP BY ")
      |> append_line(
        group_bys
        |> list.map(format_table_column)
        |> string.join(", "),
      )
  }
}

// Converting

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
) -> String {
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

fn add_primary_keys(columns: List(Option(String))) -> String {
  case columns |> list.is_empty() {
    True -> ""
    False ->
      ",\nPRIMARY KEY ("
      <> columns
      |> option.values()
      |> string.join(",")
      <> ")"
  }
}

fn filter_primary_key(column: Column(a, value)) -> Option(String) {
  case column.arguments |> list.contains(PrimaryKey) {
    True -> Some(column.name)
    False -> None
  }
}

fn format_column_create_table(column: Column(a, b)) -> String {
  let builder =
    string_builder.new()
    |> append(column.name <> " ")
    |> append(column.column_type.name <> " ")

  let builder = case column.column_type.nullable {
    False ->
      builder
      |> append("NOT NULL ")
    True -> builder
  }

  let builder = case column.arguments {
    [ForeignKey(ref_table, ref_column)] ->
      builder
      |> append("REFERENCES " <> ref_table <> " (" <> ref_column <> ") ")
    _ -> builder
  }

  builder
  |> string_builder.to_string()
  |> string.trim_right()
}

// Query

pub fn query1(query: Query(Column(a, value), t_wheres)) -> String {
  string_builder.new()
  |> add_select([format_column(query.columns)])
  |> add_query_args(query)
  |> string_builder.to_string()
}

pub fn query2(
  query: Query(#(Column(a, value), Column(b, value)), t_wheres),
) -> String {
  let #(column1, column2) = query.columns

  string_builder.new()
  |> add_select([format_column(column1), format_column(column2)])
  |> add_query_args(query)
  |> string_builder.to_string()
}

pub fn query3(
  query: Query(
    #(Column(a, value), Column(b, value), Column(c, value)),
    t_wheres,
  ),
) -> String {
  let #(column1, column2, column3) = query.columns

  string_builder.new()
  |> add_select([
    format_column(column1),
    format_column(column2),
    format_column(column3),
  ])
  |> add_query_args(query)
  |> string_builder.to_string()
}

pub fn query4(
  query: Query(
    #(Column(a, value), Column(b, value), Column(c, value), Column(d, value)),
    t_wheres,
  ),
) -> String {
  let #(column1, column2, column3, column4) = query.columns

  string_builder.new()
  |> add_select([
    format_column(column1),
    format_column(column2),
    format_column(column3),
    format_column(column4),
  ])
  |> add_query_args(query)
  |> string_builder.to_string()
}

pub fn query5(
  query: Query(
    #(
      Column(a, value),
      Column(b, value),
      Column(c, value),
      Column(d, value),
      Column(e, value),
    ),
    t_wheres,
  ),
) -> String {
  let #(column1, column2, column3, column4, column5) = query.columns

  string_builder.new()
  |> add_select([
    format_column(column1),
    format_column(column2),
    format_column(column3),
    format_column(column4),
    format_column(column5),
  ])
  |> add_query_args(query)
  |> string_builder.to_string()
}

pub fn query6(
  query: Query(
    #(
      Column(a, value),
      Column(b, value),
      Column(c, value),
      Column(d, value),
      Column(e, value),
      Column(f, value),
    ),
    t_wheres,
  ),
) -> String {
  let #(column1, column2, column3, column4, column5, column6) = query.columns

  string_builder.new()
  |> add_select([
    format_column(column1),
    format_column(column2),
    format_column(column3),
    format_column(column4),
    format_column(column5),
    format_column(column6),
  ])
  |> add_query_args(query)
  |> string_builder.to_string()
}

pub fn query7(
  query: Query(
    #(
      Column(a, value),
      Column(b, value),
      Column(c, value),
      Column(d, value),
      Column(e, value),
      Column(f, value),
      Column(g, value),
    ),
    t_wheres,
  ),
) -> String {
  let #(column1, column2, column3, column4, column5, column6, column7) =
    query.columns

  string_builder.new()
  |> add_select([
    format_column(column1),
    format_column(column2),
    format_column(column3),
    format_column(column4),
    format_column(column5),
    format_column(column6),
    format_column(column7),
  ])
  |> add_query_args(query)
  |> string_builder.to_string()
}

pub fn query8(
  query: Query(
    #(
      Column(a, value),
      Column(b, value),
      Column(c, value),
      Column(d, value),
      Column(e, value),
      Column(f, value),
      Column(g, value),
      Column(h, value),
    ),
    t_wheres,
  ),
) -> String {
  let #(column1, column2, column3, column4, column5, column6, column7, column8) =
    query.columns

  string_builder.new()
  |> add_select([
    format_column(column1),
    format_column(column2),
    format_column(column3),
    format_column(column4),
    format_column(column5),
    format_column(column6),
    format_column(column7),
    format_column(column8),
  ])
  |> add_query_args(query)
  |> string_builder.to_string()
}

pub fn query9(
  query: Query(
    #(
      Column(a, value),
      Column(b, value),
      Column(c, value),
      Column(d, value),
      Column(e, value),
      Column(f, value),
      Column(g, value),
      Column(h, value),
      Column(i, value),
    ),
    t_wheres,
  ),
) -> String {
  let #(
    column1,
    column2,
    column3,
    column4,
    column5,
    column6,
    column7,
    column8,
    column9,
  ) = query.columns

  string_builder.new()
  |> add_select([
    format_column(column1),
    format_column(column2),
    format_column(column3),
    format_column(column4),
    format_column(column5),
    format_column(column6),
    format_column(column7),
    format_column(column8),
    format_column(column9),
  ])
  |> add_query_args(query)
  |> string_builder.to_string()
}

// Create Table

pub fn create_table1(create_table: CreateTable(Column(a, value))) -> String {
  let column1 = create_table.columns

  string_builder.new()
  |> append_line("CREATE TABLE " <> create_table.table <> " (")
  |> append(format_column_create_table(column1))
  |> append_line(add_primary_keys([filter_primary_key(column1)]))
  |> append(") STRICT;")
  |> string_builder.to_string()
}

pub fn create_table2(
  create_table: CreateTable(#(Column(a, value), Column(b, value))),
) -> String {
  let #(column1, column2) = create_table.columns

  string_builder.new()
  |> append_line("CREATE TABLE " <> create_table.table <> " (")
  |> append_comma_line(format_column_create_table(column1))
  |> append(format_column_create_table(column2))
  |> append_line(
    add_primary_keys([filter_primary_key(column1), filter_primary_key(column2)]),
  )
  |> append(") STRICT;")
  |> string_builder.to_string()
}

pub fn create_table3(
  create_table: CreateTable(
    #(Column(a, value), Column(b, value), Column(c, value)),
  ),
) -> String {
  let #(column1, column2, column3) = create_table.columns

  string_builder.new()
  |> append_line("CREATE TABLE " <> create_table.table <> " (")
  |> append_comma_line(format_column_create_table(column1))
  |> append_comma_line(format_column_create_table(column2))
  |> append(format_column_create_table(column3))
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

pub fn create_table4(
  create_table: CreateTable(
    #(Column(a, value), Column(b, value), Column(c, value), Column(d, value)),
  ),
) -> String {
  let #(column1, column2, column3, column4) = create_table.columns

  string_builder.new()
  |> append_line("CREATE TABLE " <> create_table.table <> " (")
  |> append_comma_line(format_column_create_table(column1))
  |> append_comma_line(format_column_create_table(column2))
  |> append_comma_line(format_column_create_table(column3))
  |> append(format_column_create_table(column4))
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

pub fn create_table5(
  create_table: CreateTable(
    #(
      Column(a, value),
      Column(b, value),
      Column(c, value),
      Column(d, value),
      Column(e, value),
    ),
  ),
) -> String {
  let #(column1, column2, column3, column4, column5) = create_table.columns

  string_builder.new()
  |> append_line("CREATE TABLE " <> create_table.table <> " (")
  |> append_comma_line(format_column_create_table(column1))
  |> append_comma_line(format_column_create_table(column2))
  |> append_comma_line(format_column_create_table(column3))
  |> append_comma_line(format_column_create_table(column4))
  |> append(format_column_create_table(column5))
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

pub fn create_table6(
  create_table: CreateTable(
    #(
      Column(a, value),
      Column(b, value),
      Column(c, value),
      Column(d, value),
      Column(e, value),
      Column(f, value),
    ),
  ),
) -> String {
  let #(column1, column2, column3, column4, column5, column6) =
    create_table.columns

  string_builder.new()
  |> append_line("CREATE TABLE " <> create_table.table <> " (")
  |> append_comma_line(format_column_create_table(column1))
  |> append_comma_line(format_column_create_table(column2))
  |> append_comma_line(format_column_create_table(column3))
  |> append_comma_line(format_column_create_table(column4))
  |> append_comma_line(format_column_create_table(column5))
  |> append(format_column_create_table(column6))
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

pub fn create_table7(
  create_table: CreateTable(
    #(
      Column(a, value),
      Column(b, value),
      Column(c, value),
      Column(d, value),
      Column(e, value),
      Column(f, value),
      Column(g, value),
    ),
  ),
) -> String {
  let #(column1, column2, column3, column4, column5, column6, column7) =
    create_table.columns

  string_builder.new()
  |> append_line("CREATE TABLE " <> create_table.table <> " (")
  |> append_comma_line(format_column_create_table(column1))
  |> append_comma_line(format_column_create_table(column2))
  |> append_comma_line(format_column_create_table(column3))
  |> append_comma_line(format_column_create_table(column4))
  |> append_comma_line(format_column_create_table(column5))
  |> append_comma_line(format_column_create_table(column6))
  |> append(format_column_create_table(column7))
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

pub fn create_table8(
  create_table: CreateTable(
    #(
      Column(a, value),
      Column(b, value),
      Column(c, value),
      Column(d, value),
      Column(e, value),
      Column(f, value),
      Column(g, value),
      Column(h, value),
    ),
  ),
) -> String {
  let #(column1, column2, column3, column4, column5, column6, column7, column8) =
    create_table.columns

  string_builder.new()
  |> append_line("CREATE TABLE " <> create_table.table <> " (")
  |> append_comma_line(format_column_create_table(column1))
  |> append_comma_line(format_column_create_table(column2))
  |> append_comma_line(format_column_create_table(column3))
  |> append_comma_line(format_column_create_table(column4))
  |> append_comma_line(format_column_create_table(column5))
  |> append_comma_line(format_column_create_table(column6))
  |> append_comma_line(format_column_create_table(column7))
  |> append(format_column_create_table(column8))
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

pub fn create_table9(
  create_table: CreateTable(
    #(
      Column(a, value),
      Column(b, value),
      Column(c, value),
      Column(d, value),
      Column(e, value),
      Column(f, value),
      Column(g, value),
      Column(h, value),
      Column(i, value),
    ),
  ),
) -> String {
  let #(
    column1,
    column2,
    column3,
    column4,
    column5,
    column6,
    column7,
    column8,
    column9,
  ) = create_table.columns

  string_builder.new()
  |> append_line("CREATE TABLE " <> create_table.table <> " (")
  |> append_comma_line(format_column_create_table(column1))
  |> append_comma_line(format_column_create_table(column2))
  |> append_comma_line(format_column_create_table(column3))
  |> append_comma_line(format_column_create_table(column4))
  |> append_comma_line(format_column_create_table(column5))
  |> append_comma_line(format_column_create_table(column6))
  |> append_comma_line(format_column_create_table(column7))
  |> append_comma_line(format_column_create_table(column8))
  |> append(format_column_create_table(column9))
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

// Insert Into

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
