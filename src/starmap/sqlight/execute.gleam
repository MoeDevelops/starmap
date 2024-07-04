import gleam/dynamic
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import sqlight.{type Connection, type Error, type Value}
import starmap/creation.{type CreateTable}
import starmap/insertion.{type Insertion}
import starmap/query.{type Query, ConvertedColumnValue, ConvertedColumns}
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
    dynamic.element(0, query.columns.column_type.encoding.decoder),
  )
}

pub fn query2(
  query: Query(#(Column(a, Value), Column(b, Value)), Value),
  conn: Connection,
) -> Result(List(#(a, b)), Error) {
  let #(column1, column2) = query.columns
  let parameters = get_parameters(query)

  query
  |> convert.query2()
  |> sqlight.query(
    conn,
    parameters,
    dynamic.tuple2(
      column1.column_type.encoding.decoder,
      column2.column_type.encoding.decoder,
    ),
  )
}

pub fn query3(
  query: Query(#(Column(a, Value), Column(b, Value), Column(c, Value)), Value),
  conn: Connection,
) -> Result(List(#(a, b, c)), Error) {
  let #(column1, column2, column3) = query.columns
  let parameters = get_parameters(query)

  query
  |> convert.query3()
  |> sqlight.query(
    conn,
    parameters,
    dynamic.tuple3(
      column1.column_type.encoding.decoder,
      column2.column_type.encoding.decoder,
      column3.column_type.encoding.decoder,
    ),
  )
}

pub fn query4(
  query: Query(
    #(Column(a, Value), Column(b, Value), Column(c, Value), Column(d, Value)),
    Value,
  ),
  conn: Connection,
) -> Result(List(#(a, b, c, d)), Error) {
  let #(column1, column2, column3, column4) = query.columns
  let parameters = get_parameters(query)

  query
  |> convert.query4()
  |> sqlight.query(
    conn,
    parameters,
    dynamic.tuple4(
      column1.column_type.encoding.decoder,
      column2.column_type.encoding.decoder,
      column3.column_type.encoding.decoder,
      column4.column_type.encoding.decoder,
    ),
  )
}

pub fn query5(
  query: Query(
    #(
      Column(a, Value),
      Column(b, Value),
      Column(c, Value),
      Column(d, Value),
      Column(e, Value),
    ),
    Value,
  ),
  conn: Connection,
) -> Result(List(#(a, b, c, d, e)), Error) {
  let #(column1, column2, column3, column4, column5) = query.columns
  let parameters = get_parameters(query)

  query
  |> convert.query5()
  |> sqlight.query(
    conn,
    parameters,
    dynamic.tuple5(
      column1.column_type.encoding.decoder,
      column2.column_type.encoding.decoder,
      column3.column_type.encoding.decoder,
      column4.column_type.encoding.decoder,
      column5.column_type.encoding.decoder,
    ),
  )
}

pub fn query6(
  query: Query(
    #(
      Column(a, Value),
      Column(b, Value),
      Column(c, Value),
      Column(d, Value),
      Column(e, Value),
      Column(f, Value),
    ),
    Value,
  ),
  conn: Connection,
) -> Result(List(#(a, b, c, d, e, f)), Error) {
  let #(column1, column2, column3, column4, column5, column6) = query.columns
  let parameters = get_parameters(query)

  query
  |> convert.query6()
  |> sqlight.query(
    conn,
    parameters,
    dynamic.tuple6(
      column1.column_type.encoding.decoder,
      column2.column_type.encoding.decoder,
      column3.column_type.encoding.decoder,
      column4.column_type.encoding.decoder,
      column5.column_type.encoding.decoder,
      column6.column_type.encoding.decoder,
    ),
  )
}

fn get_parameters(query: Query(t_columns, Value)) -> List(Value) {
  query.wheres
  |> query.unwrap_converted_wheres()
  |> option.values()
  |> list.map(fn(column) {
    case column {
      ConvertedColumnValue(_, val) -> Some(val)
      ConvertedColumns(_, _) -> None
    }
  })
  |> option.values()
}

pub fn create_table3(
  create_table: CreateTable(
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
  let encoding1 = column1.column_type.encoding
  let encoding2 = column2.column_type.encoding
  let encoding3 = column3.column_type.encoding
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
  let encoding1 = column1.column_type.encoding
  let encoding2 = column2.column_type.encoding
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
