import gleam/dynamic
import gleam/list
import starmap/schema.{type Column, type Encoding, type Table}

pub type Query(a) {
  Query(
    table: String,
    inner_joins: List(InnerJoin),
    selects: List(Select),
    encoding: a,
  )
}

pub type InnerJoin {
  InnerJoin(table1: String, column1: String, table2: String, column2: String)
}

pub type Select {
  Select(table: String, column: String)
}

pub fn from(table: Table(a)) -> Query(Nil) {
  Query(table.name, [], [], Nil)
}

pub fn inner_join(
  query: Query(q),
  column1: Column(a, b),
  column2: Column(a, b),
) -> Query(q) {
  Query(
    ..query,
    inner_joins: query.inner_joins
      |> list.append([
        InnerJoin(
          column1.table_name,
          column1.name,
          column2.table_name,
          column2.name,
        ),
      ]),
  )
}

pub fn select1(
  query: Query(Nil),
  column1: Column(a, b),
) -> Query(Encoding(a, b)) {
  Query(
    table: query.table,
    inner_joins: query.inner_joins,
    selects: [Select(column1.table_name, column1.name)],
    encoding: column1.column_type().encoding,
  )
}

pub fn select2(
  query: Query(Nil),
  column1: Column(a, b),
  column2: Column(c, d),
) -> Query(#(Encoding(a, b), Encoding(c, d))) {
  Query(
    table: query.table,
    inner_joins: query.inner_joins,
    selects: [
      Select(column1.table_name, column1.name),
      Select(column2.table_name, column2.name),
    ],
    encoding: #(column1.column_type().encoding, column2.column_type().encoding),
  )
}

pub fn select3(
  query: Query(Nil),
  column1: Column(a, b),
  column2: Column(c, d),
  column3: Column(e, f),
) -> Query(#(Encoding(a, b), Encoding(c, d), Encoding(e, f))) {
  Query(
    table: query.table,
    inner_joins: query.inner_joins,
    selects: [
      Select(column1.table_name, column1.name),
      Select(column2.table_name, column2.name),
      Select(column3.table_name, column3.name),
    ],
    encoding: #(
      column1.column_type().encoding,
      column2.column_type().encoding,
      column3.column_type().encoding,
    ),
  )
}

pub fn encodings_to_tuple3_decoder(
  encodings: #(Encoding(a, b), Encoding(c, d), Encoding(e, f)),
) {
  let #(enc1, enc2, enc3) = encodings

  dynamic.tuple3(enc1.decoder, enc2.decoder, enc3.decoder)
}
