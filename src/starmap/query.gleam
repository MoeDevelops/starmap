import gleam/list
import starmap/schema.{type Column, type Table}

pub opaque type Query {
  Query(
    table: String,
    inner_joins: List(#(#(String, String), #(String, String))),
    columns: List(#(String, String)),
  )
}

pub fn from(table: Table(a)) -> Query {
  Query(table.name, [], [])
}

pub fn inner_join(
  query: Query,
  table1: Table(a),
  column1: Column(c, d),
  table2: Table(b),
  column2: Column(c, d),
) -> Query {
  Query(
    ..query,
    inner_joins: query.inner_joins
      |> list.append([
        #(#(table1.name, column1.name), #(table2.name, column2.name)),
      ]),
  )
}

pub fn select1(query: Query, table: Table(a), column1: Column(b, c)) -> Query {
  Query(
    ..query,
    columns: query.columns
      |> list.append([#(table.name, column1.name)]),
  )
}

pub fn select2(
  query: Query,
  table: Table(a),
  column1: Column(b, c),
  column2: Column(d, e),
) -> Query {
  Query(
    ..query,
    columns: query.columns
      |> list.append([#(table.name, column1.name), #(table.name, column2.name)]),
  )
}

pub fn select3(
  query: Query,
  table: Table(a),
  column1: Column(b, c),
  column2: Column(d, e),
  column3: Column(f, g),
) -> Query {
  Query(
    ..query,
    columns: query.columns
      |> list.append([
        #(table.name, column1.name),
        #(table.name, column2.name),
        #(table.name, column3.name),
      ]),
  )
}
