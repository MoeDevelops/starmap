import gleam/list
import gleam/option.{type Option, None, Some}
import starmap/schema.{type Column}

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

pub type TableColumn {
  TableColumn(table: String, column: String)
}

pub type Where(a, value) {
  Equal(columns: WhereColumns(a, value))
  NotEqual(columns: WhereColumns(a, value))
  IsNull(column: Column(Option(a), value))
  Greater(columns: WhereColumns(a, value))
  GreaterOrEqual(columns: WhereColumns(a, value))
  Lower(columns: WhereColumns(a, value))
  LowerOrEqual(columns: WhereColumns(a, value))
  Or(where1: Where(a, value), where2: Where(a, value))
}

pub type WhereColumns(a, value) {
  Column(column: Column(a, value), val: a)
  Columns(column1: Column(a, value), column2: Column(a, value))
}

/// Where in a listable format
pub type ConvertedWhere(value) {
  ConvertedEqual(columns: ConvertedWhereColumns(value))
  ConvertedIsNull(column: TableColumn)
}

pub type ConvertedWhereColumns(value) {
  ConvertedColumn(column: TableColumn, val: value)
  ConvertedColumns(column1: TableColumn, column2: TableColumn)
}

pub type Join {
  Join(column1: TableColumn, column2: TableColumn)
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

pub fn inner_join(
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

pub fn where(
  query: Query(t_columns, t_value),
  where: Where(a, t_value),
) -> Query(t_columns, t_value) {
  Query(
    ..query,
    wheres: query.wheres
      |> list.append([
        case where {
          IsNull(column) ->
            ConvertedIsNull(TableColumn(column.table, column.name))
          _ -> panic as "Not implemented"
        },
      ]),
  )
}

pub fn limit(
  query: Query(t_columns, t_wheres),
  amount: Int,
) -> Query(t_columns, t_wheres) {
  Query(..query, limit: Some(amount))
}
