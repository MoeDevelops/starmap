import gleam/dynamic
import gleam/list
import gleam/result
import sqlight.{type Connection, type Error, type Value}
import starmap/creation.{type CreateTable}
import starmap/insertion.{type Insertion}
import starmap/query.{type Query}
import starmap/schema.{type Column}
import starmap/sqlight/convert

pub fn query1(
  query: Query(Column(a, value), t_wheres),
  conn: Connection,
) -> Result(List(a), Error) {
  query
  |> convert.query1()
  |> sqlight.query(
    conn,
    [],
    dynamic.element(0, query.columns.column_type().encoding.decoder),
  )
}

pub fn query3(
  query: Query(
    #(Column(a, value), Column(b, value), Column(c, value)),
    t_wheres,
  ),
  conn: Connection,
) -> Result(List(#(a, b, c)), Error) {
  let #(column1, column2, column3) = query.columns

  query
  |> convert.query3()
  |> sqlight.query(
    conn,
    [],
    dynamic.tuple3(
      column1.column_type().encoding.decoder,
      column2.column_type().encoding.decoder,
      column3.column_type().encoding.decoder,
    ),
  )
}

pub fn create_table3(
  create_table: CreateTable(
    t_table,
    #(Column(a, value), Column(b, value), Column(c, value)),
  ),
  conn: Connection,
) {
  create_table
  |> convert.create_table3()
  |> sqlight.exec(conn)
}

pub fn insertion3(
  insertion: Insertion(
    #(Column(a, Value), Column(b, Value), Column(c, Value)),
    #(a, b, c),
  ),
  conn: Connection,
) -> Result(Nil, Error) {
  let #(column1, column2, column3) = insertion.columns
  let encoding1 = column1.column_type().encoding
  let encoding2 = column2.column_type().encoding
  let encoding3 = column3.column_type().encoding
  let decoder =
    dynamic.tuple3(encoding1.decoder, encoding2.decoder, encoding3.decoder)

  let values =
    insertion.values
    |> list.fold([], fn(values, x) {
      let #(value1, value2, value3) = x

      values
      |> list.append([
        encoding1.encoder(value1),
        encoding2.encoder(value2),
        encoding3.encoder(value3),
      ])
    })

  insertion
  |> convert.insertion3()
  |> sqlight.query(conn, values, decoder)
  |> result.map(fn(_) { Nil })
}

pub fn insertion2(
  insertion: Insertion(#(Column(a, Value), Column(b, Value)), #(a, b)),
  conn: Connection,
) -> Result(Nil, Error) {
  let #(column1, column2) = insertion.columns
  let encoding1 = column1.column_type().encoding
  let encoding2 = column2.column_type().encoding
  let decoder = dynamic.tuple2(encoding1.decoder, encoding2.decoder)

  let values =
    insertion.values
    |> list.fold([], fn(values, x) {
      let #(value1, value2) = x

      values
      |> list.append([encoding1.encoder(value1), encoding2.encoder(value2)])
    })

  insertion
  |> convert.insertion2()
  |> sqlight.query(conn, values, decoder)
  |> result.map(fn(_) { Nil })
}
