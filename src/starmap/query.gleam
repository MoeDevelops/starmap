import gleam/list
import gleam/option.{type Option, None, Some}
import starmap/schema.{type Column, type Table}

pub type Query(t_table, t_columns, t_wheres) {
  Query(
    table: Table(t_table),
    columns: t_columns,
    joins: List(Join),
    wheres: Option(t_wheres),
    order_by: List(TableColumn),
    group_by: List(TableColumn),
    limit: Option(Int),
  )
}

pub type TableColumn {
  TableColumn(table: String, column: String)
}

pub type Where(a, b) {
  Equal(columns: WhereColumns(a, b))
  NotEqual(columns: WhereColumns(a, b))
  Greater(columns: WhereColumns(a, b))
  GreaterOrEqual(columns: WhereColumns(a, b))
  Lower(columns: WhereColumns(a, b))
  LowerOrEqual(columns: WhereColumns(a, b))
  And(where1: Where(a, b), where2: Where(a, b))
  Or(where1: Where(a, b), where2: Where(a, b))
}

pub type WhereColumns(a, b) {
  OneColumn(Column(a, b), a)
  TwoColumns(Column(a, b), Column(a, b))
}

pub type Join {
  Join(column1: TableColumn, column2: TableColumn)
}

// For when not being able to spread due to different generics
fn query_replace_columns(
  query: Query(t_table, Nil, t_wheres),
  columns: a,
) -> Query(t_table, a, t_wheres) {
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

pub fn from(table: Table(t_table)) -> Query(t_table, Nil, wheres_type) {
  Query(
    table: table,
    columns: Nil,
    joins: [],
    wheres: None,
    order_by: [],
    group_by: [],
    limit: None,
  )
}

pub fn inner_join(
  query: Query(t_table, t_columns, t_wheres),
  column1: Column(a, value),
  column2: Column(a, value),
) -> Query(t_table, t_columns, t_wheres) {
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
  query: Query(t_table, Nil, t_wheres),
  column1: Column(a, value),
) -> Query(t_table, Column(a, value), t_wheres) {
  query
  |> query_replace_columns(column1)
}

pub fn select3(
  query: Query(t_table, Nil, t_where),
  column1: Column(a, value),
  column2: Column(b, value),
  column3: Column(c, value),
) -> Query(
  t_table,
  #(Column(a, value), Column(b, value), Column(c, value)),
  t_where,
) {
  query
  |> query_replace_columns(#(column1, column2, column3))
}

pub fn limit(
  query: Query(t_table, t_columns, t_wheres),
  amount: Int,
) -> Query(t_table, t_columns, t_wheres) {
  Query(..query, limit: Some(amount))
}
