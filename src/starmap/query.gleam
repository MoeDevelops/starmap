import gleam/list
import gleam/option.{type Option, None, Some}
import starmap/schema.{type Column}

// Query

pub type Query(t_columns, t_value) {
  Query(
    table: String,
    columns: t_columns,
    joins: List(Join),
    wheres: List(ConvertedWhere(t_value)),
    order_by: List(TableColumn),
    group_by: List(TableColumn),
    limit: Option(Int),
  )
}

// For when not being able to spread due to different generics
fn query_replace_columns(
  query: Query(Nil, t_wheres),
  columns: a,
) -> Query(a, t_wheres) {
  Query(
    table: query.table,
    columns: columns,
    joins: query.joins,
    wheres: query.wheres,
    order_by: query.order_by,
    group_by: query.group_by,
    limit: query.limit,
  )
}

pub fn from(table: String) -> Query(Nil, wheres_type) {
  Query(
    table: table,
    columns: Nil,
    joins: [],
    wheres: [],
    order_by: [],
    group_by: [],
    limit: None,
  )
}

pub fn select1(
  query: Query(Nil, t_wheres),
  column1: Column(a, value),
) -> Query(Column(a, value), t_wheres) {
  query
  |> query_replace_columns(column1)
}

pub fn select3(
  query: Query(Nil, t_where),
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
) -> Query(#(Column(a, value), Column(b, value), Column(c, value)), t_where) {
  query
  |> query_replace_columns(#(column1, column2, column3))
}

// TableColumn

pub type TableColumn {
  TableColumn(table: String, column: String)
}

// Where

pub type Where(a, b, value) {
  Equal(columns: WhereColumns(a, value))
  NotEqual(columns: WhereColumns(a, value))
  IsNull(column: Column(Option(a), value))
  IsNotNull(column: Column(Option(a), value))
  Greater(columns: WhereColumns(a, value))
  GreaterOrEqual(columns: WhereColumns(a, value))
  Lower(columns: WhereColumns(a, value))
  LowerOrEqual(columns: WhereColumns(a, value))
  Or(where1: Where(a, b, value), where2: Where(b, a, value))
}

pub type WhereColumns(a, value) {
  ColumnValue(column: Column(a, value), val: a)
  Columns(column1: Column(a, value), column2: Column(a, value))
  ColumnsOneNullable(
    column1: Column(a, value),
    column2: Column(Option(a), value),
  )
}

/// Where in a listable format
pub type ConvertedWhere(value) {
  ConvertedEqual(columns: ConvertedWhereColumns(value))
  ConvertedNotEqual(columns: ConvertedWhereColumns(value))
  ConvertedIsNull(column: TableColumn)
  ConvertedIsNotNull(column: TableColumn)
  ConvertedGreater(columns: ConvertedWhereColumns(value))
  ConvertedGreaterOrEqual(columns: ConvertedWhereColumns(value))
  ConvertedLower(columns: ConvertedWhereColumns(value))
  ConvertedLowerOrEqual(columns: ConvertedWhereColumns(value))
  ConvertedOr(where1: ConvertedWhere(value), where2: ConvertedWhere(value))
}

pub type ConvertedWhereColumns(value) {
  ConvertedColumnValue(column: TableColumn, val: value)
  ConvertedColumns(column1: TableColumn, column2: TableColumn)
}

pub fn where(
  query: Query(t_columns, t_value),
  where: Where(a, b, t_value),
) -> Query(t_columns, t_value) {
  Query(
    ..query,
    wheres: query.wheres
      |> list.append([convert_where(where)]),
  )
}

fn convert_where(where: Where(a, b, value)) -> ConvertedWhere(value) {
  case where {
    Equal(columns) -> ConvertedEqual(convert_where_columns(columns))
    NotEqual(columns) -> ConvertedNotEqual(convert_where_columns(columns))
    IsNull(column) -> ConvertedIsNull(TableColumn(column.table, column.name))
    IsNotNull(column) ->
      ConvertedIsNotNull(TableColumn(column.table, column.name))
    Greater(columns) -> ConvertedGreater(convert_where_columns(columns))
    GreaterOrEqual(columns) ->
      ConvertedGreaterOrEqual(convert_where_columns(columns))
    Lower(columns) -> ConvertedLower(convert_where_columns(columns))
    LowerOrEqual(columns) ->
      ConvertedLowerOrEqual(convert_where_columns(columns))
    Or(where1, where2) ->
      ConvertedOr(convert_where(where1), convert_where_redirect(where2))
  }
}

pub fn unwrap_converted_wheres(
  converted_wheres: List(ConvertedWhere(value)),
) -> List(Option(ConvertedWhereColumns(value))) {
  converted_wheres
  |> list.map(fn(converted_where) {
    case converted_where {
      ConvertedEqual(columns) -> [Some(columns)]
      ConvertedNotEqual(columns) -> [Some(columns)]
      ConvertedGreater(columns) -> [Some(columns)]
      ConvertedGreaterOrEqual(columns) -> [Some(columns)]
      ConvertedLower(columns) -> [Some(columns)]
      ConvertedLowerOrEqual(columns) -> [Some(columns)]
      ConvertedOr(where1, where2) ->
        [unwrap_converted_wheres([where1, where2])] |> list.flatten()
      _ -> [None]
    }
  })
  |> list.flatten()
}

// Needed for OR, because it has generics a and b swapped
fn convert_where_redirect(where: Where(a, b, value)) -> ConvertedWhere(value) {
  convert_where(where)
}

fn convert_where_columns(
  where_columns: WhereColumns(a, value),
) -> ConvertedWhereColumns(value) {
  case where_columns {
    ColumnValue(column, val) ->
      ConvertedColumnValue(
        TableColumn(column.table, column.name),
        column.column_type().encoding.encoder(val),
      )
    Columns(column1, column2) ->
      ConvertedColumns(
        TableColumn(column1.table, column1.name),
        TableColumn(column2.table, column2.name),
      )
    ColumnsOneNullable(column1, column2) ->
      ConvertedColumns(
        TableColumn(column1.table, column1.name),
        TableColumn(column2.table, column2.name),
      )
  }
}

// Join

pub type Join {
  Join(column1: TableColumn, column2: TableColumn)
}

pub fn join(
  query: Query(t_columns, t_wheres),
  column1: Column(a, value),
  column2: Column(a, value),
) -> Query(t_columns, t_wheres) {
  Query(
    ..query,
    joins: query.joins
      |> list.append([
        Join(
          TableColumn(column1.table, column1.name),
          TableColumn(column2.table, column2.name),
        ),
      ]),
  )
}

// Limit
pub fn limit(
  query: Query(t_columns, t_wheres),
  amount: Int,
) -> Query(t_columns, t_wheres) {
  Query(..query, limit: Some(amount))
}
