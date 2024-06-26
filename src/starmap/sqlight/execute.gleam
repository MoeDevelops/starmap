import gleam/dynamic.{type Dynamic}
import gleam/list
import gleam/result
import sqlight.{type Connection, type Error, type Value}
import starmap/insertion.{type Insertion}
import starmap/query.{type Query}
import starmap/schema.{type Column}
import starmap/sqlight/conversion

pub fn query(query: Query(a), conn: Connection) -> Result(List(Dynamic), Error) {
  query
  |> conversion.query()
  // Still todo!
  |> sqlight.query(conn, [], dynamic.dynamic)
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
  |> conversion.insertion3()
  |> sqlight.query(conn, values, decoder)
  |> result.map(fn(_) { Nil })
}
